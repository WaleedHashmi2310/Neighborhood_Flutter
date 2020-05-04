import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighborhood/creation/result.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';

class Alert extends StatefulWidget {
 
  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> {

  final title = new TextEditingController();

  @override

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    //title.dispose();
    super.dispose();
  }

  String titlefield;
  String flag;
  String descriptionfield;
  Result result;
  final db = Firestore.instance;
  final _alertKey = GlobalKey<FormState>();
  //Result result = Result();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var blockSize = width / 100;
    var form = Form(
      key: _alertKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize *10),
              child: TextFormField(
                controller: title,
                maxLength: 30,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an Alert';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Alert!',
                  labelText: 'Alert!',
                ),
                onSaved: (String value) {
                  titlefield = value;
                },
              ),
            ),
            Container(
                child: Text(
                  '''   
              
    Alerts are the most important and time sensitive
    messages.
              
    Everyone in your neighbourhood will have this alert 
    pinned on their feed for a maximum of 24 hours''',
                  maxLines: 20,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black),
                )),
            Container(
              margin: EdgeInsets.only(left: blockSize * 25, top: blockSize * 15),
              child: SizedBox(
                height: blockSize * 15,
                width: blockSize * 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(blockSize*18.0),
                      side: BorderSide(color: Theme.of(context).accentColor)),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (_alertKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Posting your Alert')));
                    }
                    flag= 'A';
                    titlefield=title.text;
                    print('TITLE IS $titlefield');
                    sendData();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return form;
  }
  void sendData() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.getUserData();
    await db
        .collection("Neighborhoods")
        .document("Demo")
        .collection("Events")
        .add({
      'user': user.uid,
      'user_name': user.displayName,
      'user': 'Insert UserID',
      'alert': titlefield
    });
  }

}
