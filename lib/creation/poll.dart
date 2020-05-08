import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighborhood/creation/result.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';

class Poll extends StatefulWidget {
  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  //Controllers for all the text fields
  final question = TextEditingController();
  final description = TextEditingController();
  final option1 = TextEditingController();
  final option2 = TextEditingController();
  final option3 = TextEditingController();
  final option4 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    question.dispose();
    description.dispose();
    option1.dispose();
    option2.dispose();
    option3.dispose();
    option4.dispose();
    super.dispose();
  }
  //variables to store text field data
  String titlefield;
  String optionfield1;
  String optionfield2;
  String optionfield3;
  String optionfield4;

  String flag;
  final _pollKey = GlobalKey<FormState>();
  //Result result = Result();
  Result result;
  final db = Firestore.instance;//Database Link

  //Function to send data to database
  void sendData() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.getUserData();
    var finalUser = await auth.getName(user);
    int totalVotes = 0;
    var voted = [];
    var optionsAndVotes = new Map();
    optionsAndVotes["$optionfield1"] = 0;
    optionsAndVotes["$optionfield2"] = 0;
    if (optionfield3.isNotEmpty)
      optionsAndVotes["$optionfield3"] = 0;
    if (optionfield4.isNotEmpty)
      optionsAndVotes["$optionfield4"] = 0;
    await db
        .collection("Neighborhoods")
        .document("Demo")
        .collection("Polls")
        .add({
      'user': user.uid,
      'user_name': finalUser,
      'title': titlefield,
      'timestamp': DateTime.now(),
      'totalvotes': totalVotes,
      'options_and_votes': optionsAndVotes,
      'voted': voted,

    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;//Gets screen width of user's screen
    var blockSize = width / 100;
    var form = Form(
      key: _pollKey,
      child: SingleChildScrollView(//Makes screen scrollable
        child: Column(
          children: <Widget>[
            //Code for Question field
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize *10),
              child: TextFormField(
                controller: question,
                maxLength: 60,//Max length of question
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Ask a Question';//error if field empty
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*5.0),//Tapers border of question box
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Ask a Question',
                  labelText: 'Question',
                ),
              ),
            ),
            //Code for option 1 textfield
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),//Aligns Textfield on screen
              child: TextFormField(
                controller: option1,
                maxLength: 30,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Minimum 2 options required';//Error shown if 2 options not given
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*5.0),//Tapers border
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 1',
                ),
              ),
            ),
            //Code for option 2 textfield
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),//Aligns Textfield on screen
              child: TextFormField(
                controller: option2,
                maxLength: 30,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Minimum 2 options required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*5.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 2',
                ),
              ),
            ),
            //Code for option 3 textfield
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),//Aligns Textfield on screen
              child: TextFormField(
                controller: option3,
                maxLength: 30,
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*5.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 3',
                ),
              ),
            ),
            //Code for option 4 textfield
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),//Aligns Textfield on screen
              child: TextFormField(
                controller: option4,
                maxLength: 30,
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*5.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 4',
                ),
              ),
            ),
            //Code for Post button
            Container(
              margin: EdgeInsets.only(left: blockSize * 25, top: blockSize * 5, bottom:blockSize * 5 ),
              child: SizedBox(
                height: 50,//height of button
                width: 200,//width of button
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(blockSize*25.0),
                      side: BorderSide(color: Theme.of(context).accentColor)),
                  color: Theme.of(context).accentColor,
                  elevation: 1.0,
                  onPressed: () {
                    //If all fields are valid and filled send data to server
                    if (_pollKey.currentState.validate()) {
                      // If the form is valid, display a snackbar.

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Poll Created!')));

                      titlefield = question.text;
                      optionfield1 = option1.text;
                      optionfield2 = option2.text;
                      optionfield3 = option3.text;
                      optionfield4 = option4.text;
                      sendData();//Sends data to server
                      flag = 'P';
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
}