import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/expandable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//StreamBuilder to fetch data from the DB and build the Events Page

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
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
                  .collection("Events")
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
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return new ListView(
                      physics: const BouncingScrollPhysics(),
                      children: snapshot.data.documents.map((
                          DocumentSnapshot document) {
                        return new ExpandableCard(
                          title: document['title'],
                          description: document['description'],
                          username: document['user_name'],
                          category: "Event",
                          image: document['image'],
                          time: document['timestamp'],
                          uid: document['user'],
                          docID: document.documentID,
                          type: "Event",
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