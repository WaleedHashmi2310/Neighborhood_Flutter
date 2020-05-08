import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:neighborhood/home/profile.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:neighborhood/creation/result.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:uuid/uuid.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  var uuid = Uuid();
  final db = Firestore.instance;//Establishes connection to database

  List<String> _category = [
    'General',
    'For Sale',
    'Crime & Safety',
    'Lost & Found'
  ];// The list for the dropdown menu

  //variables to store data from textfield
  String categoryField;
  String titleField;
  String messageField;
  var userID;

  final _messageKey = GlobalKey<FormState>();
  //Result result = Result();
  String _selectedCategory;
  File _image;
  //Controllers for text fields.
  final title = TextEditingController();

  @override
  final message = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    message.dispose();
    title.dispose();
    super.dispose();
  }
 //Function to get image from phone gallery
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
//Function to send data to database
  void sendData() async {
    String url;
    if (_image != null){
      var fName = uuid.v4();
      final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
          .child(fName);
      final StorageUploadTask task = firebaseStorageRef.putFile(_image);
      var downUrl = await(await task.onComplete).ref.getDownloadURL();
      url = downUrl.toString();
    }

    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.getUserData();
    var finalUser = await auth.getName(user);
    var comments = new Map();
    //Sends data to its relevant category in the database
    await db
        .collection("Neighborhoods")
        .document("Demo")
        .collection("Messages")
        .add({
      'user': user.uid,
      'user_name': finalUser,
      'category': categoryField,
      'title': titleField,
      'description': messageField,
      'image': url,
      'comments': comments,
      'timestamp': DateTime.now(),
    });
  }




  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width; //Gets width of the user's screen
    var blockSize = width / 100;
    var form = Form(
      key: _messageKey,
      child: SingleChildScrollView( //Ensures scrollability
        child: Column(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(
                  left: blockSize * 10,
                  right: blockSize * 10.0,
                  top: blockSize * 10.0),
              child: DropdownButtonFormField(//Creates the drop down menu
                hint: Text('Please choose a category'),
                value: _selectedCategory,
                onChanged: (newValue) {
                  //storing value of from dropdown menu
                  setState(() {
                    _selectedCategory = newValue;
                    categoryField = newValue;
                  });
                },
                //maps category list above to dropdown menu
                items: _category.map((_category) {
                  return DropdownMenuItem(
                    child: new Text(_category),
                    value: _category,
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(blockSize * 5),//Tapers the category menu border
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            //Code for title box
            Container(
              margin:
              EdgeInsets.only(top: blockSize * 5, right: blockSize * 10),//aligns title textbox on screen
              child: TextFormField(
                controller: title,
                maxLength: 60,//Max characters the text box can hold
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a Title';//returns this error if box is empty when "Post" button is pressed
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard_arrow_right),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(blockSize * 5.0), //Tapers the title box
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Title',
                  labelText: 'Title',
                ),
                onSaved: (String value) {},
              ),
            ),
            //Code for Message box
            Container(
              margin:
              EdgeInsets.only(right: blockSize * 10, top: blockSize * 5), //Aligns the message box on screen
              child: TextFormField(
                controller: message,
                keyboardType: TextInputType.multiline, //Message can be as long as you want
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your Message'; // error displayed if message box is empty
                  }
                  return null;
                },
                //Decoration widget
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(blockSize * 5.0),//Tapers message box
                    borderSide: BorderSide(),
                  ),
                  icon: Icon(Icons.keyboard_arrow_right),//arrow on the left side of the box
                  hintText: 'Enter your Message',
                  labelText: 'Message',
                ),
                onSaved: (String value) {},
              ),
            ),
            //Code for add image button
            Container(
              margin: EdgeInsets.only(
                  left: blockSize * 10.0, top: blockSize * 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: FloatingActionButton(
                      onPressed: getImage,//Calls the get image function written above
                      tooltip: 'Pick Image',
                      child: new Icon(Icons.add_photo_alternate, color: Colors.white,),//photo icon for button
                      backgroundColor: Theme.of(context).accentColor,
                      elevation: 1.0,
                    ),
                  ),
                  //Code for Post button
                  Container(
                    margin: EdgeInsets.only(left: blockSize * 15),//Alligns button on screen at bottom right
                    child: SizedBox(
                      height: blockSize * 15,// height of button box
                      width: blockSize * 50,//width of button box
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(blockSize * 18.0),//curves the button edges
                            side: BorderSide(
                                color: Theme.of(context).accentColor)),
                        color: Theme.of(context).accentColor,
                        elevation: 1.0,
                        onPressed: () {
                          //if all fields are valid, send data to server
                          if (_messageKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Message Created!')));

                            titleField = title.text;
                            messageField = message.text;
                            sendData();//Function to send data to server
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
            //Code to display uploaded image 
            Container(
              margin:
              EdgeInsets.only(right: blockSize * 40, top: blockSize * 2),
              child: _image == null
                  ? Text('No Image')//When there is no image
                  : SizedBox(
                height: blockSize*50,//Image height
                width: blockSize*50,//Image width
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