import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  final title = TextEditingController();

  @override
  final description = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    description.dispose();
    title.dispose();
    super.dispose();
  }

  String titlefield;
  String descriptionfield;
  String flag;
  final _eventKey = GlobalKey<FormState>();
  //Result result = Result();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
  var blockSize = width / 100;
    var form = Form(
      key: _eventKey,
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
                    return 'Please enter a Title for your event';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize* 25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Event Title',
                  labelText: 'Event Title',
                ),
                onSaved: (String value) {
                  titlefield = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),
              child: TextFormField(
                controller: description,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please give a Description of your event';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  //contentPadding: const EdgeInsets.symmetric(vertical: 50.0),
                  icon: Icon(Icons.keyboard_arrow_right),
                  hintText: 'Enter your Events Description',
                  labelText: 'Description',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: blockSize * 25, top: blockSize * 15),
              child: SizedBox(
                height: blockSize * 15,
                width: blockSize * 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(blockSize*18.0),
                      side: BorderSide(color: Colors.blueAccent)),
                  color: Colors.blueAccent,
                  onPressed: () {
                    if (_eventKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Creating your Event')));
                    }
                    titlefield = title.text;
                    flag = 'E';
                    descriptionfield = description.text;
                    print('Title is $titlefield');
                    print('message is $descriptionfield');
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
