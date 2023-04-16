import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/create.dart';
import 'package:gsm_chat/models/friend.dart';
import 'package:gsm_chat/models/group.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/resources/chat_group_methods.dart';
import 'package:gsm_chat/resources/chat_methods.dart';
import 'package:gsm_chat/resources/friend_methods.dart';
import 'package:gsm_chat/resources/group_methods.dart';
import 'package:gsm_chat/screens/chatscreens/chat_group_screen.dart';
import 'package:gsm_chat/screens/chatscreens/chat_screen.dart';
import 'package:gsm_chat/screens/chatscreens/widgets/cached_image.dart';
import 'package:gsm_chat/screens/pageviews/widgets/last_message_container.dart';
import 'package:gsm_chat/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/widgets/custom_chat_list.dart';
import 'package:gsm_chat/widgets/custom_friend_tile.dart';
import 'package:gsm_chat/widgets/custom_group_tile.dart';
import 'package:gsm_chat/widgets/custom_merchant_tile.dart';
import 'package:gsm_chat/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

class GroupView extends StatelessWidget {
  final Group group;
  
  final GroupMethods _authMethods = GroupMethods();

  GroupView(this.group);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return FutureBuilder<Group>(
      future: _authMethods.getGroupDetailsById(
          userProvider.getUser.uid, group.name),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Group user = snapshot.data;
          print(snapshot.data.name);

          return ViewLayout(group: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Group group;
  final ChatGroupMethods _chatMethods = ChatGroupMethods();

  ViewLayout({
    @required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGroupTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatGroupScreen(
              group: group,
            ),
          )),
      title: Text(
        group.name,
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(groupName: group.name),
      ),
    );
  }
}
