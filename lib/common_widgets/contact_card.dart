import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';

class ContactCard extends StatefulWidget {
  @override
  _ContactCardState createState() => _ContactCardState();
  const ContactCard({
    Key key,
    this.name,
    this.contact,
    this.address,
  });
  final name;
  final contact;
  final address;
}

class _ContactCardState extends State<ContactCard> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    String contact = "";
    var _keys = widget.contact.keys.toList();
    var _values = widget.contact.values.toList();
    for(int i=0; i<_keys.length; i++){
      contact = contact + (_keys[i].toString() + ": " + _values[i].toString() + "\n");
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          width: MediaQuery.of(context).copyWith().size.width,
          height: MediaQuery.of(context).copyWith().size.height / 5,
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,8.0),
                  child: Container(
                    child: Text(
                      widget.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                  child: Container(
                    child: Text(
                      contact,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,4.0),
                  child: Container(
                    child: Text(
                      "Address: ${widget.address}",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
