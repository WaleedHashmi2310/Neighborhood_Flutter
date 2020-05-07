import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/alert_card.dart';
import 'package:neighborhood/common_widgets/expandable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Alerts extends StatefulWidget {
  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection("Neighborhoods")
                  .document("Demo")
                  .collection("Alerts")
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              // ignore: missing_return
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                      ),
                    );
                  default:
                    return new ListView(
                      physics: const BouncingScrollPhysics(),
                      children: snapshot.data.documents.map((
                          DocumentSnapshot document) {
                        return new AlertCard(
                          alert: document['alert'],
                          dismissed: document['dismissed'],
                          docID: document.documentID,
                        );
                      }).toList(),
                    );
                }
              }
          )
      ),
    );
  }
}