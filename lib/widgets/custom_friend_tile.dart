import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/utils/universal_variables.dart';

class CustomFriendTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureTapCallback onAccept, onReject;
  final GestureLongPressCallback onLongPress;
  final stream;

  CustomFriendTile(
      {@required this.leading,
      @required this.title,
      this.icon,
      @required this.subtitle,
      this.trailing,
      this.margin = const EdgeInsets.all(0),
      this.onTap,
      this.onAccept,
      this.onReject,
      this.onLongPress,
      this.mini = true,
      this.stream});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: GestureDetector(
                onTap: onTap,
                onLongPress: onLongPress,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
                  margin: margin,
                  child: Row(
                    children: <Widget>[
                      leading,
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: mini ? 10 : 15),
                          padding:
                              EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color:
                                          UniversalVariables.separatorColor))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  title,
                                  SizedBox(height: 5),
                                  Row(
                                    children: <Widget>[
                                      icon ?? Container(),
                                      subtitle,
                                    ],
                                  )
                                ],
                              ),
                              trailing ?? Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: stream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        var docList = snapshot.data.documents;

                        var requestlist = snapshot.data.toString();

                        print(docList);

                        if (docList.isNotEmpty) {
                          Request message = Request.fromMap(docList.last.data);

                          if(message.message == "Pending"){
                            return Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: onAccept,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: onReject,
                                ),
                              ],
                            );
                          }else{
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }
                      return Text(
                        "..",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
