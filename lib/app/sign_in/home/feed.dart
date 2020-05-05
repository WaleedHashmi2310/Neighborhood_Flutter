import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/expandable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection("Neighborhoods")
              .document("Demo")
              .collection("Messages")
              .snapshots(),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState){
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document){
                    return new ExpandableCard(
                      title: document['title'],
                      description: document['description'],
                      username: document['user_name'],
                      category: document['category'],
                      image: document['image'],
                    );
                  }).toList(),
                );
            }
          }
        )
    );
  }
}







