import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/screens/home_screen.dart';
import 'package:gsm_chat/screens/other/register.dart';
import 'package:gsm_chat/screens/other/register_merchant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CustomLogin extends StatefulWidget {
  const CustomLogin({Key key}) : super(key: key);

  @override
  _CustomLoginState createState() => _CustomLoginState();
}

class _CustomLoginState extends State<CustomLogin> {
  String email, password;
  bool showProgress = false;
  final _auth = FirebaseAuth.instance;

  AuthMethods _repo = new AuthMethods();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GSM Chat"),
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showProgress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login Page",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value; //get the value entered by user.
                },
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value; //get the value entered by user.
                },
                decoration: InputDecoration(
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    try {
                      final newuser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      print(newuser);
                      if (newuser != null) {
                        Fluttertoast.showToast(
                            msg: "Login Successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blueAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                        setState(() {
                          showProgress = false;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  minWidth: 200.0,
                  height: 45.0,
                  child: Text(
                    "Login",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Text(
                  "Register as MEMBER",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterMerchant()),
                  );
                },
                child: Text(
                  "Register as MERCHANT",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
