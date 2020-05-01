import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List<String> _category = [
    'General',
    'For Sale',
    'Crime & Safety',
    'Lost & Found'
  ];

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

  String titlefield;
  String categoryfield;
  String messagefield;
  String flag;

  final _messageKey = GlobalKey<FormState>();
  //Result result = Result();
  String _selectedCategory;
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
      key: _messageKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(left: blockSize*10, right: blockSize*10.0, top: blockSize*10.0),
              child: DropdownButtonFormField(
                hint: Text('Please choose a category'),
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                    categoryfield = newValue;
                  });
                },
                items: _category.map((_category) {
                  return DropdownMenuItem(
                    child: new Text(_category),
                    value: _category,
                  );
                }).toList(),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(blockSize *10),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: blockSize*5, right:blockSize*10),
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
                    borderRadius: new BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Title',
                  labelText: 'Title',
                ),
                onSaved: (String value) {
                  titlefield = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: blockSize* 10, top:blockSize * 5),
              child: TextFormField(
                controller: message,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your Message';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(blockSize*25.0),
                    borderSide: BorderSide(),
                  ),
                  icon: Icon(Icons.keyboard_arrow_right),
                  hintText: 'Enter your Message',
                  labelText: 'Message',
                ),
                onSaved: (String value) {
                  messagefield = value;
                  print('value is $value');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: blockSize*10.0, top: blockSize*10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'Pick Image',
                      child: new Icon(Icons.add_a_photo),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: blockSize * 15),
                    child: SizedBox(
                      height: blockSize*15,
                      width: blockSize*50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(blockSize*18.0),
                            side: BorderSide(color: Colors.blueAccent)),
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (_messageKey.currentState.validate()) {
                            // If the form is valid, display a snackbar.

                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Posting your Message')));
                          }
                          flag = 'M';
                          titlefield = title.text;
                          messagefield = message.text;
                          print('Category is $categoryfield');
                          print('Title is $titlefield');
                          print('message is $messagefield');
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
              margin: EdgeInsets.only(right: blockSize * 50, top:blockSize* 5),
              child: _image == null
                  ? Text('No Image Selected.')
                  : SizedBox(
                      height: 100%blockSize,
                      width: 100%blockSize,
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
