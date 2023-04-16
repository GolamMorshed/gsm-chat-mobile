import 'package:flutter/material.dart';
import 'package:gsm_chat/models/contact.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/resources/chat_methods.dart';
import 'package:gsm_chat/resources/friend_methods.dart';
import 'package:gsm_chat/screens/chatscreens/chat_screen.dart';
import 'package:gsm_chat/screens/chatscreens/widgets/cached_image.dart';
import 'package:gsm_chat/screens/pageviews/widgets/last_message_container.dart';
import 'package:gsm_chat/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/widgets/custom_chat_list.dart';
import 'package:gsm_chat/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();
  final FriendMethods _requestMethds = FriendMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    User sender;

    return CustomChatTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        (contact != null ? contact.name : null) != null ? contact.name : "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
      onPressed: () {
        Request _request = Request(
            receiverId: contact.uid,
            senderId: userProvider.getUser.uid,
            type: "Pending");

        _requestMethds.addFriendToDb(_request, sender, contact);
      },
    );
  }
}
