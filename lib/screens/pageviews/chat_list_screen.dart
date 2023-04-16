import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/contact.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/resources/chat_methods.dart';
import 'package:gsm_chat/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gsm_chat/screens/login_screen.dart';
import 'package:gsm_chat/screens/other/custom_login.dart';
import 'package:gsm_chat/screens/pageviews/drawer/friend_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/friend_request.dart';
import 'package:gsm_chat/screens/pageviews/drawer/group_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/member_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/merchant_list.dart';
import 'package:gsm_chat/screens/pageviews/widgets/contact_view.dart';
import 'package:gsm_chat/screens/pageviews/widgets/new_chat_button.dart';
import 'package:gsm_chat/screens/pageviews/widgets/quiet_box.dart';
import 'package:gsm_chat/screens/pageviews/widgets/user_circle.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/widgets/appbar.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  AuthMethods _repo = AuthMethods();

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.logout_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            _repo.signOut();
            Navigator.pushNamed(context, "/login_screen");
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: UserCircle(),
              ),
              ListTile(
                title: Text('Member List'),
                onTap: () {
                  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MemberListScreen()));
                },
              ),
              ListTile(
                title: Text('Merchant List'),
                onTap: () {
                  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MerchantListScreen()));
                },
              ),
              ListTile(
                title: Text('Friend List'),
                onTap: () {
                  CustomLogin();
                  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FriendListScreen()));
                },
              ),
              ListTile(
                title: Text('Friend Request'),
                onTap: () {
                  CustomLogin();
                  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FriendRequestScreen()));
                },
              ),
              ListTile(
                title: Text('Group'),
                onTap: () {
                  CustomLogin();
                  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupListScreen()));
                },
              ),
              ListTile(
                title: Text('Calendar'),
                onTap: () {
                  CustomLogin();
                  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomLogin()));
                },
              ),
            ],
          )
        ),
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
