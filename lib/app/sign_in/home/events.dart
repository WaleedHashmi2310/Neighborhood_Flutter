import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/expandable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
                  .snapshots(),
              // ignore: missing_return
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
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