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
  //variables to store data
  String titlefield;
  String flag;
  String descriptionfield;
  Result result;
  final db = Firestore.instance;//Connection to database
  final _alertKey = GlobalKey<FormState>();
  //Result result = Result();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;//Gets width of user screen
    var blockSize = width / 100;
    var form = Form(
      key: _alertKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Code for alert box
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize *10),//Alligns alert box
              child: TextFormField(
                controller: title,
                maxLength: 60,//max characters in alert
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
                    borderRadius: new BorderRadius.circular(blockSize * 5.0),//tapers Alert box border
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
            //code for text beneath alert box
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
                //Code for Post Alert Button
            Container(
              margin: EdgeInsets.only(left: blockSize * 32, top: blockSize * 6),
              child: SizedBox(
                height: blockSize * 15,//height of button
                width: blockSize * 50,//width of button
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(blockSize*25.0),//Circular border for button
                      side: BorderSide(color: Theme.of(context).accentColor)),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    //If all fields valid, send data
                    if (_alertKey.currentState.validate()) {
                      // If the form is valid, display a snackbar.

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Alert Created')));

                      flag = 'A';
                      titlefield = title.text;
                      print('TITLE IS $titlefield');
                      sendData();// Function to send data
                    }
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
  //Function to send data to database
  void sendData() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.getUserData();
    var finalUser = await auth.getName(user);
    await db
        .collection("Neighborhoods")
        .document("Demo")
        .collection("Alerts")
        .add({
      'user': user.uid,
      'user_name': finalUser,
      'alert': titlefield,
      'timestamp': DateTime.now(),
    });
  }

}