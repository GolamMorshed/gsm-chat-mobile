import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/utils/universal_variables.dart';

class CustomGroupTile extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final stream;

  CustomGroupTile(
      {
      @required this.title,
      this.icon,
      this.subtitle,
      this.margin = const EdgeInsets.all(0),
      this.onTap,
      this.mini = true,
      this.stream});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
                  margin: margin,
                  child: Row(
                    children: <Widget>[
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
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
