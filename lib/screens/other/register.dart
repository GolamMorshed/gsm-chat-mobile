import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/screens/other/custom_login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String firstName, lastName, email, password;
  String profileURL = "https://hawkingnight.com/image/user.png";
  bool showProgress = false;
  final _auth = FirebaseAuth.instance;

  AuthMethods _repo = AuthMethods();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Authentication"),
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showProgress,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Registration Page",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    firstName = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your First Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    lastName = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Last Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  // obscureText: true,
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
                        final newuser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        String _name = firstName + " " + lastName;
                        authenticateUser(newuser, _name, profileURL);
                        addToMySql(newuser, _name, profileURL);
                
                        if (newuser != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomLogin()),
                          );
                          setState(() {
                            showProgress = false;
                          });
                        }
                      } catch (e) {}
                    },
                    minWidth: 200.0,
                    height: 45.0,
                    child: Text(
                      "Register",
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
                      MaterialPageRoute(builder: (context) => CustomLogin()),
                    );
                  },
                  child: Text(
                    "Already Registred? Login Now",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w900),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void authenticateUser(FirebaseUser user, String name, String profilePhoto) {
    _repo.authenticateUser(user).then((isNewUser) {
      setState(() {
        // isLoggedIn = false;
      });

      if (isNewUser) {
        _repo.addDataToDb(user, name, profilePhoto).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return CustomLogin();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return CustomLogin();
        }));
      }
    });
  }

  void addToMySql(FirebaseUser user, String name, String profilePhoto) async {
    Uri apiLink =
        Uri.parse("https://hawkingnight.com/chat/public/api/user/register");

    final response = await http.post(apiLink, headers: {
      "Accept": "application/json"
    }, body: {
      "uid": user.uid,
      "name": name,
      "email": email,
      "password": password,
      "image": profilePhoto,
    });

    if (response.statusCode == 201) {
      Fluttertoast.showToast(
          msg: "Register Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CustomLogin()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.body)));
    }
  }
}
