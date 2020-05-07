import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/contact_card.dart';
class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {

  Widget build(BuildContext context) {
    final db = Firestore.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
        'Emergency Helplines',
        style: TextStyle(color: Colors.black87, fontSize: 22.0, fontFamily: 'AirbnbCerealBold')
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: new IconThemeData(color: Colors.black87),
        titleSpacing: 0.0,
        elevation: 1.0,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87,),
            // Replace false with location to exit to
            onPressed: () => Navigator.pop(context)),
      ),
      body:  Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection("Neighborhoods")
                  .document("Demo")
                  .collection("Contacts")
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
                        return new ContactCard(
                          name: document['name'],
                          contact: document['contact'],
                          address: document['address'],
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

