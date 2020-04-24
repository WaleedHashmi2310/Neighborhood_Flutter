import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neighborhood/common_widgets/platform_exception_alert_dialog.dart';
import 'package:neighborhood/app/sign_in/validators.dart';
import 'package:neighborhood/app/sign_in/sign_in_button.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignUpForm extends StatefulWidget with EmailAndPasswordValidators {

  @override
  _EmailSignUpFormState createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _isLoading = false;

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.pop(context);

    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Can\'t Sign Up',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toSignIn(){
    Navigator.pop(context);
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  List<Widget> _buildChildren() {

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) && !_isLoading;


    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),

      SizedBox(height: 32.0),

      SignInButton(
        text: 'Sign Up',
        textColor: Colors.white,
        color: Theme.of(context).accentColor,
        onPressed: submitEnabled?() => _submit(): null,
      ),

      FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            children: <TextSpan>[
              new TextSpan(
                text: 'Already have an account? ',
              ),
              new TextSpan(text: 'Sign In',
                  style: new TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),

        onPressed: () => _toSignIn(),
      ),
    ];
  }

  TextField _buildEmailTextField() {
//    bool emailValid = widget.emailValidator.isValid(_email);
    return TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        cursorColor: Colors.black54,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          ),
          errorStyle: TextStyle(
            color: Colors.black87,
          ),
          enabled: _isLoading == false,
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18.0,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: _emailEditingComplete,
        onChanged: (email) => _updateState()
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      cursorColor: Colors.black87,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
        ),
        enabled: _isLoading == false,
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18.0,
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState() ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildChildren(),
    );
  }

  _updateState() {
    setState(() {
    });
  }
}