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
  final db = Firestore.instance;//link to firebase
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
//This function uploads  all the data from the Message field to the database
  void sendData() async {
    String url;
    if (_image != null){
      var fName = uuid.v4();
      final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
          .child(fName);
      final StorageUploadTask task = firebaseStorageRef.putFile(_image);
      var downUrl = await(await task.onComplete).ref.getDownloadURL();
      url = downUrl.toString();
    }//waiting for image to upload to database.

    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.getUserData();
    var finalUser = await auth.getName(user);
    var comments = new Map();
    //Accesses database tree structure for appropriate storage
    await db
        .collection("Neighborhoods")
        .document("Demo")
        .collection("Events")
        .add({
      'user': user.uid,
      'user_name': finalUser,
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
//This function allows the user to upload an image.
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);//await function, waits for image to upload
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;//Gets the width of the user's screen to adjust size of text boxes accordingly
    var blockSize = width / 100;
    var form = Form(
      key: _eventKey,
      child: SingleChildScrollView(//Creates a scrollable page incase the height of the page is longer than the user's phone screen.
        child: Column(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(
                //Aligns Text box on screen
                  right: blockSize * 10.0,
                  top: blockSize * 10.0),
              child: TextFormField(
                controller: title,
                maxLength: 60,// max length of title is 30 character
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a Title';//Shows error title box is not filled
                  }
                  return null;
                },
                //This is for aesthetic purposes, creates rounded border
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize * 5.0),//Tapers Text box border
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Title',
                  labelText: 'Title',
                ),
                onSaved: (String value) {},
              ),
            ),
            //Container for Description textbox
            Container(
              margin:
              //aligns textbox on screen
              EdgeInsets.only(right: blockSize * 10, top: blockSize * 5),
              child: TextFormField(
                controller: event,// Controller to store value for later use
                keyboardType: TextInputType.multiline,//Message can span across multiple lines.
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the description';//shows error if box is left empty
                  }
                  return null;
                },
                //Decoration for the box
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(blockSize * 5.0),//Tapers boxedge
                    borderSide: BorderSide(),
                  ),
                  icon: Icon(Icons.keyboard_arrow_right),//displays arrow on the left side of the description
                  hintText: 'Enter event description',
                  labelText: 'Description',
                ),
                onSaved: (String value) {
                },
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
                      child: new Icon(Icons.add_a_photo, color: Colors.white,),
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
                            new BorderRadius.circular(blockSize * 25.0),
                            side: BorderSide(
                                color: Theme.of(context).accentColor)
                        ),
                        color: Theme.of(context).accentColor,
                        elevation: 1.0,
                        onPressed: () {
                          if (_eventKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Event Created!')));

                            titleField = title.text;
                            eventField = event.text;
                            sendData();
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
            Container(
              margin:
              EdgeInsets.only(right: blockSize * 40, top: blockSize * 2),
              child: _image == null
                  ? Text('No Image')
                  : SizedBox(
                height: blockSize*50,
                width: blockSize*50,
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