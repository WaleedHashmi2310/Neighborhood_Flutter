import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/platform_alert_dialog.dart';
import 'package:neighborhood/services/auth.dart';
import 'dart:io';


import 'package:provider/provider.dart';

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({
    Key key,
    this.username,
    this.uid,
    this.docID,
    this.title,
    this.description,
    this.category,
    this.image,
    this.time,
    this.type,
  });
  final String username;
  final uid;
  final docID;
  final String title;
  final String description;
  final String category;
  final String image;
  final time;
  final type;

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {

  final db = Firestore.instance;
  Color _iconColor = Colors.grey;
  String timeStamp;
  bool canDelete = false;
  Color _binColor = Colors.grey;

  String getInitials(name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = names.length;

    if(numWords < names.length) {
      numWords = names.length;
    }
    for(var i = 0; i < numWords; i++){
      initials += '${names[i][0]}';
    }
    return initials;
  }

  void getTime() {
    final old = widget.time.toDate();
    final now = DateTime.now();
    final difference = now.difference(old).inDays;
    if (difference == 0)
      timeStamp = "Today";
    else if(difference == 1)
      timeStamp = "Yesterday";
    else
      timeStamp = "$difference " + "days ago";
  }

  @override
  Widget build(BuildContext context) {

  if(widget.username != null && widget.title != null && widget.description != null && widget.category != null &&widget.time != null){
    getTime();
    checkUser();
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Card(
            elevation: 2.0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: CircleAvatar(
                              backgroundColor: Theme
                                  .of(context)
                                  .accentColor,
                              child: Text(
                                  "${getInitials(widget.username)}",
                                  style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w500)
                              ),
                              radius: 16.0,
                            )
                        ),

                        SizedBox(width: 8.0),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.username,
                                style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500, fontSize: 14.0),
                              ),
                            ),
                            Container(
                              child: Text(
                                timeStamp,
                                style: TextStyle(color: Colors.grey, fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        Container(
                          child: Text(
                            widget.category,
                            style: TextStyle(color: Colors.black54, fontSize: 12.0),
                          ),
                        )
                      ]
                  ),
                ),

                imageBuilder(context),

                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                        )),
                    collapsed: Text(
                      widget.description,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              widget.description,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: IconButton(
                              icon: Icon(Icons.favorite_border,
                                color: _iconColor,
                                size: 24.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _iconColor = Colors.red;
                                });
                              },
                            )
                        ),
                        Container(
                            child: Text(
                              "Upvote",
                              style: TextStyle(color: Colors.grey),
                            )
                        ),
                        SizedBox(width: 12.0,),
                        Container(
                            child: IconButton(
                              icon: Icon(Icons.comment,
                                color: Colors.grey,
                                size: 24.0,
                              ),
                            )
                        ),
                        Container(
                            child: Text(
                              "Comment",
                              style: TextStyle(color: Colors.grey),
                            )
                        ),

                        Spacer(),

                        deletePost(context),
                      ]
                  ),
                ),
              ],
            ),
          ),
        )
    );
  } else {
    return Container(
      color: Colors.white,
    );
  }

  }

  Widget imageBuilder(BuildContext context){
    if (widget.image != null){
      return SizedBox(
        height: 150,
        child: Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage(widget.image),
                fit: BoxFit.contain,
            )
          ),
        ),
      );
    }else{
      return SizedBox(
        height: 1.0,
      );
    }
  }

  checkUser() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.getUserData();
    final userUID = user.uid;
    if(userUID.toString() == widget.uid.toString()){
      setState(() {
      canDelete = true;
      });
    }
  }

  void deletePostMessage() async{
    if(canDelete == true){
      await db
          .collection("Neighborhoods")
          .document("Demo")
          .collection("Messages")
          .document(widget.docID)
          .delete();
    }
    setState(() {
      canDelete = false;
    });
  }

  void deletePostEvent() async{
    if(canDelete == true){
      await db
          .collection("Neighborhoods")
          .document("Demo")
          .collection("Events")
          .document(widget.docID)
          .delete();
    }
    setState(() {
      canDelete = false;
    });
  }

  void _confirmDelete(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Post?', style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
//          side: BorderSide(color: Colors.grey[300], width: 1.6),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 14.0),
                ),
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _binColor = Colors.grey;
                  });
                },
              ),
              FlatButton(
                child: Text('Continue'),
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  if(widget.type == "Message")
                    deletePostMessage();
                  else
                    deletePostEvent();
                  Navigator.of(context).pop();
                  setState(() {
                    canDelete = false;
                    _binColor = Colors.grey;
                  });
                  setState(() {

                  });
                },
              ),
            ],
          );
        }
    );
  }



  Widget deletePost(BuildContext context){
    if (canDelete == true){
      return Container(
          child: IconButton(
            icon: Icon(Icons.delete,
              color: _binColor,
              size: 24.0,
            ),
            onPressed: () {
              _confirmDelete(context);
              setState(() {
                _binColor = Colors.red;
                canDelete = false;
              });
            }
          )
      );
    } else {
      return Container(width: 0.0, height: 0.0,);
    }


  }
}