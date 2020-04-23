import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/custom_raised_button.dart';


class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    double height,
    double width,
    VoidCallback onPressed,
  }) : assert(text != null),
        super(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 16.0),
        ),
        color: color,
        onPressed: onPressed,
        height: 48.0,
        width: 10000.0,
      );
}
