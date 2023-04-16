import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gsm_chat/models/call.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/resources/call_methods.dart';
import 'package:gsm_chat/screens/callscreens/call_screen.dart';
import 'package:gsm_chat/screens/callscreens/voice_call_screen.dart';

class VoiceCallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallScreen(call: call),
          ));
    }
  }
}