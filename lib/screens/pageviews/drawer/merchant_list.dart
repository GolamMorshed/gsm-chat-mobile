import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/contact.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/resources/chat_methods.dart';
import 'package:gsm_chat/resources/friend_methods.dart';
import 'package:gsm_chat/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gsm_chat/screens/chatscreens/chat_screen.dart';
import 'package:gsm_chat/screens/other/custom_login.dart';
import 'package:gsm_chat/screens/pageviews/chat_list_screen.dart';
import 'package:gsm_chat/screens/pageviews/drawer/friend_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/friend_request.dart';
import 'package:gsm_chat/screens/pageviews/drawer/group_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/member_list.dart';
import 'package:gsm_chat/screens/pageviews/drawer/merchant_list.dart';
import 'package:gsm_chat/screens/pageviews/widgets/contact_view.dart';
import 'package:gsm_chat/screens/pageviews/widgets/merchant_quiet_box.dart';
import 'package:gsm_chat/screens/pageviews/widgets/new_chat_button.dart';
import 'package:gsm_chat/screens/pageviews/widgets/quiet_box.dart';
import 'package:gsm_chat/screens/pageviews/widgets/user_circle.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/widgets/appbar.dart';
import 'package:gsm_chat/widgets/custom_merchant_tile.dart';
import 'package:provider/provider.dart';

class MerchantListScreen extends StatelessWidget {
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
            Navigator.pushNamed(context, "/search_merchant_screen");
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
        )),
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  AuthMethods _repository = AuthMethods();

  final ChatMethods _chatMethods = ChatMethods();

  List<User> userList;

  @override
  void initState() {
    super.initState();

    getUserList();
  }

  Future getUserList() async {
    await _repository.getCurrentUser().then((FirebaseUser user) {
      _repository.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final FriendMethods _requestMethods = FriendMethods();
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    bool type = true;

    final List<User> suggestionList = userList.where((User user) {
      bool _getUserType = user.type;
      return (_getUserType == type);
    }).toList();

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return MerchantQuietBox();
              }
              return ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder: ((context, index) {
                  User searchedUser = User(
                      uid: suggestionList[index].uid,
                      profilePhoto: suggestionList[index].profilePhoto,
                      name: suggestionList[index].name,
                      username: suggestionList[index].username);

                  return CustomMerchantTile(
                    mini: false,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    receiver: searchedUser,
                                  )));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(searchedUser.profilePhoto),
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(
                      searchedUser.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      searchedUser.name,
                      style: TextStyle(color: UniversalVariables.greyColor),
                    ),
                  );
                }),
              );
            } else if (snapshot.error) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {}

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
