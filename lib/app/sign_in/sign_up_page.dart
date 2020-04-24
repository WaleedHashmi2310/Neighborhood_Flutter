import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neighborhood/app/sign_in/sign_in_bloc.dart';
import 'package:neighborhood/app/sign_in/social_sign_in_button.dart';
import 'package:neighborhood/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood/app/sign_in/email_sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
      builder: (_) => SignInBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>
        (builder: (context, bloc, _) => SignUpPage(bloc: bloc)),
    );
  }

  void _showSignUpError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Can\'t Sign Up',
      exception: exception,
    ).show(context);
  }


  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context);
      await auth.signInWithGoogle();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (e.code != "ERROR_ABORTED_BY_USER") {
        _showSignUpError(context, e);
      }
    } finally {
      bloc.setIsLoading(false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (e.code != "ERROR_ABORTED_BY_USER") {
        _showSignUpError(context, e);
      }
    } finally {
      bloc.setIsLoading(false);
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
              builder: (context, snapshot) {
                return _buildContent(context, snapshot.data);
              }
          )
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Center(
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 40.0,
                          color: Colors.black87,
                          fontFamily: 'AirbnbCerealBold'),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(width: 16.0),

                    SizedBox(child: _buildHeader(isLoading),
                      height: 20.0,
                      width: 20.0,)

                  ],
                ),

                SizedBox(height: 24.0),

                EmailSignUpForm(),

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

                      SizedBox(width: 16.0),

                      Text(
                        "OR",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
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
                      onPressed: isLoading ? null : () =>
                          _signInWithGoogle(context),
                    ),

                    SizedBox(width: 16.0),

                    SocialSignInButton(
                      assetName: 'images/facebook-logo.png',
                      color: Color(0xFF334D92),
                      text: "Facebook",
                      textColor: Colors.white,
                      onPressed: isLoading ? null : () =>
                          _signInWithFacebook(context),
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
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      );
    } else {
      return Container();
    }
  }

}