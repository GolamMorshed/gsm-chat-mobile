import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/screens/other/custom_login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class RegisterMerchant extends StatefulWidget {
  const RegisterMerchant({Key key}) : super(key: key);

  @override
  _RegisterMerchantState createState() => _RegisterMerchantState();
}

class _RegisterMerchantState extends State<RegisterMerchant> {
  String firstName, lastName, email, password;
  String ssmNo,
      primaryContactNo,
      secondaryContactNo,
      address,
      zipCode,
      city,
      state,
      country,
      bankName,
      bankAccNo;
  String profileURL = "https://hawkingnight.com/image/user.png";
  bool showProgress = false;
  final _auth = FirebaseAuth.instance;

  AuthMethods _repo = AuthMethods();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merchant Registration"),
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
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    firstName = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your First Name",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    lastName = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Last Name",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ssmNo = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your SSM No.",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    primaryContactNo = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Primary Contact No",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    secondaryContactNo = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Secondary Contact No",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    address = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Address",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    zipCode = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Zip Code",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    city = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your City",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    state = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your State",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    country = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Country",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    bankName = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Bank Name",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    bankAccNo = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Bank Account No",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20.0),
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
        _repo.addMerchantDataToDb(user, name, profilePhoto).then((value) {
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
        Uri.parse("https://hawkingnight.com/chat/public/api/merchant/register");

    final response = await http.post(apiLink, headers: {
      "Accept": "application/json"
    }, body: {
      "uid": user.uid,
      "merchant_name": name,
      "image": profilePhoto,
      "ssm_no": ssmNo,
      "primary_contact_no": primaryContactNo,
      "secondary_contact_no": secondaryContactNo,
      "email": email,
      "address": address,
      "zip_code": zipCode,
      "city": city,
      "state": state,
      "country": country,
      "bank_name": bankName,
      "bank_acc_no": bankAccNo,
      "password": password,
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
      print(Text(response.body));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.body)));
    }
  }
}
