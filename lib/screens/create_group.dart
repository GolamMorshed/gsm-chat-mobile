import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/create.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/resources/friend_methods.dart';
import 'package:gsm_chat/resources/group_methods.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/widgets/custom_add_user.dart';
import 'package:gsm_chat/widgets/custom_friend_tile.dart';
import 'package:gsm_chat/widgets/custom_tile.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'chatscreens/chat_screen.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  AuthMethods _repository = AuthMethods();
  GroupMethods _groupMethods = GroupMethods();


  List<User> userList;
  List selectedUser = [];
  String name = "";
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

  Future _onUserSelected(bool selected, userId) {
    if (selected == true) {
      setState(() {
        selectedUser.add(userId);
      });
    } else {
      setState(() {
        selectedUser.remove(userId);
      });
    }
    print(selectedUser.toString());
  }

  void sendGroupInfo() async {
    Uri getLink = Uri.parse("https://hawkingnight.com/chat/public/api/group/create");

    String finalStr = selectedUser.reduce((value, element) {
      return value + "," + element;
    });

    final response = await http.post(getLink,
        headers: {"Accept": "application/json"},
        body: {"name": name, "users": finalStr});

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Saved!")));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to Save!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(name),
      ),
    );
  }

  searchAppBar(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

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
                name = val;
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
                icon: Icon(Icons.save, color: Colors.white),
                onPressed: () {
                  selectedUser.add(userProvider.getUser.uid);

                  for (int i = 0; i < userList.length + 1; i++) {
                    Detail _create = Detail(
                      name: name,
                      // adminId: userProvider.getUser.uid,
                      // memberId: selectedUser[i]
                      timestamp: Timestamp.now()
                    );

                    _groupMethods.addGroupToDb(
                      _create, userProvider.getUser.uid, selectedUser[i]);
                  }

                  sendGroupInfo();
                  
                  // WidgetsBinding.instance
                  // .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Group Name",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String name) {
    final FriendMethods _requestMethods = FriendMethods();
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    User sender;

    bool type = false;

    final List<User> suggestionList = userList.toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);

        return CustomAddUserTile(
          checkbox: CheckboxListTile(
            value: selectedUser.contains(suggestionList[index].uid),
            title: Text(suggestionList[index].name),
            subtitle: Text(suggestionList[index].email),
            onChanged: (bool selected) {
              _onUserSelected(selected, suggestionList[index].uid);
            },
          ),
        );
      }),
    );
  }
}
