import 'package:flutter/material.dart';
import 'package:neighborhood/app/sign_in/sign_in_page.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:neighborhood/app/sign_in/home_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen:false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        // ignore: missing_return
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.active){
            User user = snapshot.data;
            if (user == null) {
              return SignInPage();
            } else {
              return HomePage();
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
    );
  }
}