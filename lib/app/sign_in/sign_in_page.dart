import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neighborhood/app/sign_in/social_sign_in_button.dart';
import 'package:neighborhood/app/sign_in/email_sign_in_form.dart';
import 'package:neighborhood/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';


class SignInPage extends StatelessWidget {

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async{
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    }on PlatformException catch(e){
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    }on PlatformException catch(e){
      if (e.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, e);
      }
    }
  }
  Future<void> _signInWithFacebook(BuildContext context) async{
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    }on PlatformException catch(e){
      if (e.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background1.png"),
          fit: BoxFit.cover,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 40.0, color: Colors.black87, fontFamily: 'AirbnbCerealBold'),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.0),

                EmailSignInForm(),

                SizedBox(height: 16.0),

                Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          )
                      ),

                      SizedBox(width: 16.0),

                      Text(
                        "OR",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0) ,
                      ),

                      SizedBox(width: 16.0),

                      Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          )
                      ),
                    ]
                ),

                SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                  SocialSignInButton(
                    assetName: 'images/google-logo-white.png',
                    color: Colors.blue[400],
                    text: "Google",
                    textColor: Colors.white,
                    onPressed: () => _signInWithGoogle(context),
                  ),

                    SizedBox(width: 16.0),

                    SocialSignInButton(
                      assetName: 'images/facebook-logo.png',
                      color: Color(0xFF334D92),
                      text: "Facebook",
                      textColor: Colors.white,
                      onPressed: () => _signInWithFacebook(context),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}