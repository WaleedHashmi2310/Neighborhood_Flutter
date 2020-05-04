import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/app/sign_in/sign_in_bloc.dart';
import 'package:neighborhood/app/sign_in/social_sign_in_button.dart';
import 'package:neighborhood/app/sign_in/email_sign_in_form.dart';
import 'package:neighborhood/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
      builder: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>
        (builder: (context, bloc, _) => SignInPage(bloc: bloc)),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Can\'t Sign In',
      exception: exception,
    ).show(context);
  }

//  Future<void> _signInAnonymously(BuildContext context) async{
//    try{
//      final auth = Provider.of<AuthBase>(context);
//      await auth.signInAnonymously();
//    }on PlatformException catch(e){
//      _showSignInError(context, e);
//    }
//  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    try{
      await bloc.signInWithGoogle();
    }on PlatformException catch(e){
      if (e.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, e);
      }
    }
  }
  Future<void> _signInWithFacebook(BuildContext context) async{
    try{
      await bloc.signInWithFacebook();
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
        body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot){
            return _buildContent(context, snapshot.data);
          }
        )
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 24.0,0.0,24.0),
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: 48.0,
                          left: 4.0,
                          right: 1.0,
                          child: SizedBox(
                            width: 184.0,
                            height: 8.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor.withOpacity(0.9)
                              ),
                            )
                          )
                        ),
                        Text(
                          'Sign in',
                          style: TextStyle(fontSize: 48.0, color: Colors.black87, fontFamily: 'AirbnbCerealBold'),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),

                    SizedBox(width: 16.0),

                    SizedBox(child: _buildHeader(isLoading), height: 20.0, width: 20.0,)

                  ],
                ),

                SizedBox(height: 24.0),

                EmailSignInForm(),

                SizedBox(
                  height: 16.0,
                ),

                Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          )
                      ),

                      SizedBox(width: 12.0),

                      Text(
                        "or",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0) ,
                      ),

                      SizedBox(width: 12.0),

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
                    onPressed: isLoading ? null : () => _signInWithGoogle(context),
                  ),

                    SizedBox(width: 16.0),

                    SocialSignInButton(
                      assetName: 'images/facebook-logo.png',
                      color: Color(0xFF334D92),
                      text: "Facebook",
                      textColor: Colors.white,
                      onPressed: isLoading ? null : () => _signInWithFacebook(context),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }

  // ignore: missing_return
  Widget _buildHeader(bool isLoading) {
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      );
    }else{
      return Container();
    }
  }

}