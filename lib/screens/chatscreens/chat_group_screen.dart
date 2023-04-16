import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gsm_chat/constants/strings.dart';
import 'package:gsm_chat/enum/view_state.dart';
import 'package:gsm_chat/models/group.dart';
import 'package:gsm_chat/models/messages.dart';
import 'package:gsm_chat/models/messages_group.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/models/verify.dart';
import 'package:gsm_chat/provider/image_upload_provider.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/resources/chat_group_methods.dart';
import 'package:gsm_chat/resources/chat_methods.dart';
import 'package:gsm_chat/resources/storage_group_methods.dart';
import 'package:gsm_chat/screens/callscreens/pickup/pickup_layout.dart';
import 'package:gsm_chat/screens/chatscreens/widgets/cached_image.dart';
import 'package:gsm_chat/utils/call_utilities.dart';
import 'package:gsm_chat/utils/permissions.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:gsm_chat/utils/utilities.dart';
import 'package:gsm_chat/utils/voice_call_utilities.dart';
import 'package:gsm_chat/widgets/appbar.dart';
import 'package:gsm_chat/widgets/custom_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChatGroupScreen extends StatefulWidget {
  final Group group;

  ChatGroupScreen({this.group});

  @override
  _ChatGroupScreenState createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {
  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  final StorageGroupMethods _storageMethods = StorageGroupMethods();
  final ChatGroupMethods _chatMethods = ChatGroupMethods();
  final AuthMethods _authMethods = AuthMethods();

  ScrollController _listScrollController = ScrollController();

  User sender;
  List userId = [];
  List memberList = [];

  String _currentUserId;

  bool isWriting = false;

  bool showEmojiPicker = false;

  ImageUploadProvider _imageUploadProvider;

  Map<String, dynamic> verifyMap;
  Map<String, dynamic> userMap;

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      _chatMethods.fetchUser(user.uid).then((value) {
        print(value['name']);
        setState(() {
          sender = User(
            uid: value['uid'],
            name: value['name'],
            profilePhoto: value['profile_photo'],
          );
        });
      });
      getData(user.uid);
    });
  }

  void getData(userId) async {
    Uri getAPILink = Uri.parse(
        "https://hawkingnight.com/chat/public/api/group/fetch/member");

    final response = await http.post(getAPILink,
        body: {"group_name": widget.group.name, "user_id": userId});

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "SUCCESS") {
        userMap = jsonDecode(response.body);
        print(userMap);

        for (var userMapping in userMap['member']) {
          memberList.add(userMapping);
        }

        // return Future.value('Data Download Successfully');
      } else {
        print('Failed to fetch!');
        return Future.value('Data Download Failed');
      }
    }
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(GROUP_MESSAGES_COLLECTION)
          .document(widget.group.name)
          .collection(widget.group.name)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _listScrollController.animateTo(
            _listScrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        });

        return ListView.builder(
          padding: EdgeInsets.all(10),
          controller: _listScrollController,
          reverse: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            // mention the arrow syntax if you get the time
            userId.add(snapshot.data.documents[index]['senderId']);

            return chatMessageGroupItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageGroupItem(DocumentSnapshot snapshot) {
    MessageGroup _message = MessageGroup.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : groupLayout(_message),
      ),
    );
  }

  Widget senderLayout(MessageGroup message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessageGroup(message),
      ),
    );
  }

  getMessageGroup(MessageGroup message) {
    return message.type != MESSAGE_TYPE_IMAGE
        ? Column(
            children: [
              Text(
                message.senderName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                message.message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl,
                height: 250,
                width: 250,
                radius: 10,
              )
            : Text("Url was null");
  }

  Widget groupLayout(MessageGroup message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessageGroup(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                        onTap: () => pickImage(source: ImageSource.gallery),
                      ),
                      ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab,
                      ),
                      ModalTile(
                        title: "Contact",
                        subtitle: "Share contacts",
                        icon: Icons.contacts,
                      ),
                      ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location,
                      ),
                      ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule,
                      ),
                      ModalTile(
                        title: "Create Poll",
                        subtitle: "Share polls",
                        icon: Icons.poll,
                      )
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessageGroup() {
      print(sender.uid);
      var text = textFieldController.text;

      MessageGroup _message = MessageGroup(
        groupName: widget.group.name,
        senderId: sender.uid,
        senderName: sender.name,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });

      textFieldController.text = "";

      _chatMethods.addGroupMessageToDb(_message, sender.uid, widget.group.name);
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      // keyboard is visible
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.face),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.camera_alt),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessageGroup(),
                  ))
              : Container()
        ],
      ),
    );
  }

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        image: selectedImage,
        groupName: widget.group.name,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.group.name,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.video_call,
            ),
            onPressed: () async {
              User receiver;
              for (int i = 0; i < memberList.length; i++) {
                _chatMethods.fetchUser(memberList[i]).then((value) async {
                  receiver = User(
                    uid: value['uid'],
                    name: value['name'],
                    profilePhoto: value['profile_photo'],
                  );
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                        from: sender,
                        to: receiver,
                        context: context,
                      )
                    : {};
                });
              }
            }),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () async {
              User receiver;
              for (int i = 0; i < memberList.length; i++) {
                _chatMethods.fetchUser(memberList[i]).then((value) async {
                  receiver = User(
                    uid: value['uid'],
                    name: value['name'],
                    profilePhoto: value['profile_photo'],
                  );
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? VoiceCallUtils.dial(
                        from: sender,
                        to: receiver,
                        context: context,
                      )
                    : {};
                });
              }
            }
        )
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
