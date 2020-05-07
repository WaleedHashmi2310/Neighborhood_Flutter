import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';

class AlertCard extends StatefulWidget {
  @override
  _AlertCardState createState() => _AlertCardState();
  const AlertCard({
    Key key,
    this.alert,
    this.dismissed,
    this.docID,
  });
  final String alert;
  final dismissed;
  final docID;
}

class _AlertCardState extends State<AlertCard> {
  final db = Firestore.instance;
  bool _dismiss = false;
  void checkDone() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await auth.currentUserUID();
    if (widget.dismissed.contains(user)){
      setState(() {
        _dismiss = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkDone();
    if (_dismiss == true)
      return Container(width: 0.0, height: 0.0);
    else
      return alert();
  }

  Widget alert() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          width: MediaQuery.of(context).copyWith().size.width,
          height: MediaQuery.of(context).copyWith().size.height / 5,
          child: Card(
            color: Colors.red[300],
            elevation: 2.0,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,2.0),
                  child: Container(
                    child: Text(
                      "Alert!",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,4.0),
                  child: Container(
                    child: Text(
                      widget.alert,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "DISMISS",
                        style: TextStyle(color:Colors.white),
                      ),
                      onPressed: () async {
                        final auth = Provider.of<AuthBase>(context, listen: false);
                        final user = await auth.currentUserUID();
                        await db
                            .collection("Neighborhoods")
                            .document("Demo")
                            .collection("Alerts")
                            .document(widget.docID)
                            .updateData({
                          'dismissed': FieldValue.arrayUnion([user]),
                        });
                        setState(() {
                          _dismiss = true;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
