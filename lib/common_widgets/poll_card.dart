import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood/services/auth.dart';
class PollCard extends StatefulWidget {
  @override
  _PollCardState createState() => _PollCardState();
  const PollCard({
    Key key,
    this.username,
    this.title,
    this.optionsAndVotes,
    this.voted,
    this.totalVotes,
    this.docID,
    this.time,
    this.uid,
  });
  final String username;
  final String title;
  final Map optionsAndVotes;
  final List voted;
  final totalVotes;
  final docID;
  final time;
  final uid;
}

class _PollCardState extends State<PollCard> {
  final db = Firestore.instance;
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
  var _pollAlreadyDone = false;
  void checkDone() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.currentUserUID();
    if (widget.voted.contains(user)){
      setState(() {
        _pollAlreadyDone = true;
      });
    }
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
      timeStamp = "$difference" + "days ago";
  }



  @override
  Widget build(BuildContext context) {
    checkUser();
    getTime();
    checkDone();
    var _keys = widget.optionsAndVotes.keys.toList();
    var _values = widget.optionsAndVotes.values.toList();
    var totalOptions = _keys.length;
    var option1 = _keys[0];
    var option2 = _keys[1];
    var option3 = null;
    var option4 = null;
    var vote1 = _values[0];
    var vote2 = _values[1];
    var vote3 = null;
    var vote4 = null;
    var percentage1 = 0.0;
    var percentage2 = 0.0;
    var percentage3 = 0.0;
    var percentage4 = 0.0;

    if(totalOptions == 3){
      option3 = _keys[2];
      vote3 = _values[2];
      if (vote3 > 0 && widget.totalVotes > 0)
        percentage3 = (vote3 / widget.totalVotes);
    }

    if(totalOptions == 4){
      option3 = _keys[2];
      vote3 = _values[2];
      if (vote3 > 0 && widget.totalVotes > 0)
        percentage3 = (vote3 / widget.totalVotes);

      option4 = _keys[3];
      vote4 = _values[3];
      if (vote4 > 0 && widget.totalVotes > 0)
        percentage4 = (vote4 / widget.totalVotes);
    }


    if (vote1 > 0 && widget.totalVotes > 0)
      percentage1 = (vote1 / widget.totalVotes);
    if (vote2 > 0 && widget.totalVotes > 0)
      percentage2 = (vote2 / widget.totalVotes);


    var factor = 1.0;
    if (totalOptions == 2)
      factor = 1.9;
    if (totalOptions == 3)
      factor = 1.6;
    if (totalOptions == 4)
      factor = 1.4;

    return Container(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          width: MediaQuery.of(context).copyWith().size.width,
          height: MediaQuery.of(context).copyWith().size.height / factor,
          child: Card(
            elevation: 2.0,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: CircleAvatar(
                              backgroundColor: Theme
                                  .of(context)
                                  .accentColor,
                              child: Text(
                                  "${getInitials(widget.username)}",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500)
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
                                style: TextStyle(color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0),
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
                            "Poll",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0),
                          ),
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Question: ${widget.title}",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ),


                Column(
                  children: <Widget>[
                    displayOption(option1, percentage1, widget.docID),
                    displayOption(option2, percentage2, widget.docID),
                    if(totalOptions == 3)
                      displayOption(option3, percentage3, widget.docID),
                    if(totalOptions == 4)
                      displayOptionFour(option3, percentage3, option4, percentage4, widget.docID),
                  ],
                ),

                Spacer(),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (_pollAlreadyDone == true)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Poll already completed", style: TextStyle(color: Colors.grey),),
                      ),
                    if (_pollAlreadyDone == false)
                      Text("Poll already completed", style: TextStyle(color: Colors.white),),
                    Spacer(),
                    if(canDelete == true)
                      deletePost(context),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayOption(option, percentage, ID) {
    void check () async {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.currentUserUID();
      await db
          .collection("Neighborhoods")
          .document("Demo")
          .collection("Polls")
          .document(ID)
          .updateData({
        'totalvotes': widget.totalVotes + 1,
        'options_and_votes.$option': widget.optionsAndVotes[option]+1,
        'voted': FieldValue.arrayUnion([user]),
      });
    }

    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    option,
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.w600,),
                  ),
                  SizedBox(height: 8.0),
                  if (_pollAlreadyDone == true)
                    disabledProgress(percentage)
                  else
                    enabledProgress(percentage)
                ],
              ),
            ),
          ),
          onPressed: () {
            if (_pollAlreadyDone == true)
              return null;
            else
              return check();
          }
        ),
      ],
    );
  }

  Widget displayOptionFour(option3, percentage3, option4, percentage4, ID) {
    void check2 (option) async {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.currentUserUID();
      await db
          .collection("Neighborhoods")
          .document("Demo")
          .collection("Polls")
          .document(ID)
          .updateData({
        'totalvotes': widget.totalVotes + 1,
        'options_and_votes.$option': widget.optionsAndVotes[option]+1,
        'voted': FieldValue.arrayUnion([user]),
      });
    }
    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    option3,
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.0),
                  if (_pollAlreadyDone == true)
                    disabledProgress(percentage3)
                  else
                    enabledProgress(percentage3)
                ],
              ),
            ),
          ),
          onPressed: () {
            if (_pollAlreadyDone == true)
              return null;
            else
              return check2(option3);
          },
        ),
        FlatButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    option4,
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.0),
                  if (_pollAlreadyDone == true)
                    disabledProgress(percentage4)
                  else
                    enabledProgress(percentage4)

                ],
              ),
            ),
          ),
          onPressed: () {
            if (_pollAlreadyDone == true)
              return null;
            else
              return check2(option4);
          },
        ),
      ],
    );
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

  void deletePoll() async{
    if(canDelete == true){
      await db
          .collection("Neighborhoods")
          .document("Demo")
          .collection("Polls")
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
                  deletePoll();
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

  Widget enabledProgress(percentage){
    return LinearPercentIndicator(
      width: MediaQuery
          .of(context)
          .size
          .width - 90,
      animation: true,
      lineHeight: 20.0,
      animationDuration: 1000,
      percent: percentage,
      center: Text("${(percentage * 100).floor()}%",
        style: TextStyle(fontSize: 12.0, color: Colors.white)),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Theme
          .of(context)
          .accentColor,
    );
  }

  Widget disabledProgress(percentage){
    return LinearPercentIndicator(
      width: MediaQuery
          .of(context)
          .size
          .width - 90,
      animation: true,
      lineHeight: 20.0,
      animationDuration: 1000,
      percent: percentage,
      center: Text("${(percentage * 100).floor()}%",
        style: TextStyle(fontSize: 12.0, color: Colors.white)),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.grey[500]
    );
  }
}