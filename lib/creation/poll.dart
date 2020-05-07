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

  String titlefield;
  String optionfield1;
  String optionfield2;
  String optionfield3;
  String optionfield4;

  String flag;
  final _pollKey = GlobalKey<FormState>();
  //Result result = Result();
  Result result;
  final db = Firestore.instance;
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
    var width = MediaQuery.of(context).size.width;
    var blockSize = width / 100;
    var form = Form(
      key: _pollKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize *10),
              child: TextFormField(
                controller: question,
                maxLength: 60,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Ask a Question';
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
                  hintText: 'Ask a Question',
                  labelText: 'Question',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),
              child: TextFormField(
                controller: option1,
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
                    borderRadius: new BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 1',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),
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
                    borderRadius: new BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 2',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),
              child: TextFormField(
                controller: option3,
                maxLength: 30,
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 3',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),
              child: TextFormField(
                controller: option4,
                maxLength: 30,
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Write an Option',
                  labelText: 'Option 4',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: blockSize * 25, top: blockSize * 5, bottom:blockSize * 5 ),
              child: SizedBox(
                height: 50,
                width: 200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(blockSize*18.0),
                      side: BorderSide(color: Theme.of(context).accentColor)),
                  color: Theme.of(context).accentColor,
                  elevation: 1.0,
                  onPressed: () {

                    if (_pollKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Poll Created!')));
                    }
                    titlefield = question.text;
                    optionfield1 = option1.text;
                    optionfield2 = option2.text;
                    optionfield3= option3.text;
                    optionfield4 = option4.text;
                    sendData();
                    flag= 'P';
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
