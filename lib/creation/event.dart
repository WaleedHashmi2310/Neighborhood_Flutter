import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighborhood/creation/result.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  final db = Firestore.instance;
  var uuid = Uuid();
  Result result;
  

  final title = TextEditingController();

  @override
  final event = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    event.dispose();
    title.dispose();
    super.dispose();
  }

  void sendData() async {
    var fName = uuid.v4();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
        .child(fName);
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);
    var downUrl = await(await task.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();

    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.getUserData();
    var comments = new Map();
    await db
        .collection("Neighborhoods")
        .document("Demo")
        .collection("Events")
        .add({
      'user': user.uid,
      'user_name': user.displayName,
      'title': titleField,
      'description': eventField,
      'image': url,
      'comments': comments,
      'timestamp': DateTime.now(),
    });
  }
  
  String titleField;
  String eventField;
  var userID;

  final _eventKey = GlobalKey<FormState>();
  //Result result = Result();
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

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
              margin: new EdgeInsets.only(
                  right: blockSize * 10.0,
                  top: blockSize * 10.0),
              child: TextFormField(
                controller: title,
                maxLength: 30,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a Title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize * 25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Title',
                  labelText: 'Title',
                ),
                onSaved: (String value) {},
              ),
            ),
            Container(
              margin:
              EdgeInsets.only(right: blockSize * 10, top: blockSize * 5),
              child: TextFormField(
                controller: event,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(blockSize * 25.0),
                    borderSide: BorderSide(),
                  ),
                  icon: Icon(Icons.keyboard_arrow_right),
                  hintText: 'Enter event description',
                  labelText: 'Description',
                ),
                onSaved: (String value) {},
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: blockSize * 5.0, top: blockSize * 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: blockSize * 5),
                    child: FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'Pick Image',
                      child: new Icon(Icons.add_a_photo),
                      backgroundColor: Theme.of(context).accentColor,
                      elevation: 1.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: blockSize * 15),
                    child: SizedBox(
                      height: blockSize * 15,
                      width: blockSize * 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(blockSize * 18.0),
                            side: BorderSide(
                                color: Theme.of(context).accentColor)),
                        color: Theme.of(context).accentColor,
                        elevation: 1.0,
                        onPressed: () {
                          if (_eventKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Event Created!')));
                          }
                          titleField = title.text;
                          eventField = event.text;
                          sendData();
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
            Container(
              margin:
              EdgeInsets.only(right: blockSize * 64, top: blockSize * 2),
              child: _image == null
                  ? Text('No Image')
                  : SizedBox(
                height: 100 % blockSize,
                width: 100 % blockSize,
                child: Image.file(_image),
              ),
            ),
          ],
        ),
      ),
    );

    return form;
  }
}
