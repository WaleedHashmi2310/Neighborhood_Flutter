import 'package:flutter/material.dart';

class CustomCircularButton extends StatelessWidget {
  CustomCircularButton({
    this.assetName,
    this.color,
    this.onPressed,
  });
  final Color color;
  final double height = 56.0;
  final double width = 56.0;
  final VoidCallback onPressed;
  final String assetName;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: ClipOval(
        child: Container(
          color: color,
          height: height, // height of the button
          width: width, // width of the button
          child: Center(
              child: Image.asset(assetName)
          ),
        ),
      ),
    );
  }
}