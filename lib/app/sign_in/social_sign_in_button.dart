import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    Color color,
    String text,
    Color textColor,
    double height,
    double width,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        super(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              assetName,
              height: 20.0,
            ),

            SizedBox(width: 8.0),

            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 14.0),
            )
          ],
        ),
        color: color,
        height: 48.0,
        width: 132.0,
        onPressed: onPressed,
      );
}
