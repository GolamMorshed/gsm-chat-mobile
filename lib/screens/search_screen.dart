import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/resources/friend_methods.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

import 'chatscreens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethods _repository = AuthMethods();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

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
    


    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: UniversalVariables.blueColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final FriendMethods _requestMethods = FriendMethods();
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    User sender;

    bool type = false;

    final List<User> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((User user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool _getUserType = user.type;

                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesUsername && _getUserType == type ||
                    matchesName && _getUserType == type);
              }).toList()
            : userList.where((User user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool _getUserType = user.type;

                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (_getUserType == type);
              }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);

        return CustomTile(
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
          onPressed: () {
            Request _request = Request(
                receiverId: suggestionList[index].uid,
                senderId: userProvider.getUser.uid,
                type: "text",
                message: "Pending",
                timestamp: Timestamp.now(),);

            _requestMethods.addFriendToDb(_request, sender, suggestionList[index]);
          },
        );
      }),
    );
  }
}
