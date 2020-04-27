import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neighborhood/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }


  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(

      title: Text(title, style: TextStyle(fontFamily: 'AirbnbCereal', fontSize: 20.0),),
      content: Text(
        content,
        style: TextStyle(fontSize: 16.0, fontFamily: 'AirbnbCerealLight'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        )
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          child: Text(
            cancelActionText,
            style: TextStyle(color: Theme.of(context).accentColor)
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
    }
    actions.add(
      PlatformAlertDialogAction(
        child: Text(
          defaultActionText,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        onPressed: () => {
          Navigator.of(context).pop()
        },
      ),
    );
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({this.child, this.onPressed});
  final Widget child;
  final VoidCallback onPressed;


  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
