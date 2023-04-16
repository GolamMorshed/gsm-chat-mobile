import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/screens/home_screen.dart';
import 'package:gsm_chat/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMethods _repo = AuthMethods();

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: loginButton(),
          ),
          isLoggedIn
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      child: ElevatedButton(
        child: Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        onPressed: () => perfomLogin(),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
    );
  }

  void perfomLogin() {
    setState(() {
      isLoggedIn = true;
    });

    _repo.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print('FAILED');
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    // _repo.authenticateUser(user).then((isNewUser) {
    //   setState(() {
    //     isLoggedIn = false;
    //   });

    //   if (isNewUser) {
    //     _repo.addDataToDb(user).then((value) {
    //       Navigator.pushReplacement(context,
    //           MaterialPageRoute(builder: (context) {
    //         return HomeScreen();
    //       }));
    //     });
    //   } else {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) {
    //       return HomeScreen();
    //     }));
    //   }
    // });
  }
}
