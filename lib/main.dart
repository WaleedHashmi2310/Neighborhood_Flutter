import 'package:flutter/material.dart';
import 'package:neighborhood/services/auth_provider.dart';
import'package:provider/provider.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:neighborhood/app/sign_in/landing_page.dart';
import 'package:neighborhood/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    FlutterStatusbarcolor.setStatusBarColor(Colors.grey);
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primaryColor: Colors.white,
          primaryColorLight: Color(0x666ad1),
          primaryColorDark: Color(0x001970),
          accentColor: Colors.lightBlue[700],
          fontFamily: 'AirbnbCereal',
        ),
        home: LandingPage(),
      ),
    );
  }
}
