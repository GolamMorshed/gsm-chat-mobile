import 'package:flutter/material.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gsm_chat/screens/other/custom_login.dart';
import 'package:gsm_chat/screens/pageviews/chat_list_screen.dart';
import 'package:gsm_chat/screens/pageviews/drawer/friend_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/friend_request.dart';
import 'package:gsm_chat/screens/pageviews/drawer/group_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/member_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/merchant_list.dart';
import 'package:gsm_chat/screens/pageviews/widgets/new_chat_button.dart';
import 'package:gsm_chat/screens/pageviews/widgets/user_circle.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/widgets/appbar.dart';


class FriendRequestScreen extends StatelessWidget {
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
                child: Text('Drawer Header'),
              ),
              ListTile(
              title: Text('Home Page'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatListScreen()));
              },
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendListScreen()));
              },
            ),
            ListTile(
              title: Text('Friend Request'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendRequestScreen()));
              },
            ),
            ListTile(
              title: Text('Group'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GroupListScreen()));
              },
            ),
            ListTile(
              title: Text('Calendar'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomLogin()));
              },
            ),
            ],
          )
        ),
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        // body: ChatListContainer(),
      ),
    );
  }
}