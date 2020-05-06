import 'package:flutter/material.dart';
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
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Neighborhood',
        theme: ThemeData(
          primaryColor: Colors.white,
          primaryColorLight: Colors.lightBlue[300],
          primaryColorDark: Color(0x001970),
          accentColor: Colors.lightBlue,
          fontFamily: 'Roboto',
        ),
        home: LandingPage(),
      ),
    );
  }
}
