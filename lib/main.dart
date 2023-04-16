import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/provider/image_upload_provider.dart';
import 'package:gsm_chat/provider/user_provider.dart';
import 'package:gsm_chat/resources/auth_methods.dart';
import 'package:gsm_chat/screens/home_screen.dart';
import 'package:gsm_chat/screens/other/custom_login.dart';
import 'package:gsm_chat/screens/search_merchant_screen.dart';
import 'package:gsm_chat/screens/search_screen.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthMethods _repo = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "Skype Clone",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
          '/search_merchant_screen': (context) => SearchMerchantScreen(),
          '/login_screen': (context) => CustomLogin(),
        },
        theme: ThemeData(brightness: Brightness.dark),
        home: FutureBuilder(
          future: _repo.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return CustomLogin();
            }
          },
        ),
      ),
    );
  }
}
