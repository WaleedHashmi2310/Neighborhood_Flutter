import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/poll_card.dart';

//StreamBuilder to fetch data from the DB and build the Polls Page

class Polls extends StatefulWidget {
  @override
  _PollsState createState() => _PollsState();
}

class _PollsState extends State<Polls> {
    final db = Firestore.instance;
    var dict;
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection("Neighborhoods")
                        .document("Demo")
                        .collection("Polls")
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
                              return new PollCard(
                                title: document['title'],
                                username: document['user_name'],
                                optionsAndVotes: document['options_and_votes'],
                                voted: document['voted'],
                                totalVotes: document['totalvotes'],
                                docID: document.documentID,
                                time: document['timestamp'],
                                uid: document['user'],
                              );
                            }).toList(),
                          );
                      }
                    }
                ),
              ),
            ]
        ),
      );
    }
}

