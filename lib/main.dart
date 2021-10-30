import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phone_secure/pages/login/login.dart';
import 'package:phone_secure/pages/login/register.dart';




void main() {
  //This should be used while in development mode, do NOT do this when you want to release to production, the aim of this answer is to make the development a bit easier for you, for production, you need to fix your certificate issue and use it properly, look at the other answers for this as it might be helpful for your case.
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      title: 'Phone Security App',
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      //home: WelcomePage(),
      home: LoginPage(),
      //home: RegisterPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
