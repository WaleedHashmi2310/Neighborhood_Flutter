import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _nameController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _name => _nameController.text;

  bool _isLoading = false;

  final db = Firestore.instance;


  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();

    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Can\'t Sign Up',
        exception: e,
      ).show(context);
    } finally {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.getUserData();
      final uid = user.uid;
      final name = _name;
      Map<String, String> userMap = {'user':uid, 'name':name, 'email':_email};
      final ref = db.collection('Users');
      ref.document(uid).setData(userMap);
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
        widget.passwordValidator.isValid(_password) && widget.nameValidator.isValid(_name) && !_isLoading;


    return [
      _buildNameField(),
      _buildEmailTextField(),
      _buildPasswordTextField(),

      SizedBox(height: 32.0),

      SignInButton(
        text: 'Sign up',
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
              new TextSpan(text: 'Sign in',
                  style: new TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),

        onPressed: () => _toSignIn(),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      cursorColor: Colors.black87,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        enabled: _isLoading == false,
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.black54,
          fontSize: 18.0,
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState() ,
    );
  }

  TextField _buildEmailTextField() {
//    bool emailValid = widget.emailValidator.isValid(_email);
    return TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        cursorColor: Colors.black87,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          errorStyle: TextStyle(
            color: Colors.black54,
          ),
          enabled: _isLoading == false,
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: _emailEditingComplete,
        onChanged: (email) => _updateState()
    );
  }

  TextField _buildNameField() {
//    bool emailValid = widget.emailValidator.isValid(_email);
    return TextField(
        controller: _nameController,
        focusNode: _nameFocusNode,
        cursorColor: Colors.black87,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          errorStyle: TextStyle(
            color: Colors.black54,
          ),
          enabled: _isLoading == false,
          hintText: 'Full Name',
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        ),
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        onChanged: (name) => _updateState()
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