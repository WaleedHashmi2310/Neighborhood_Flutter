import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood/services/auth.dart';

class ProfileView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Container(
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: auth.getUserData(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done){
                  return getUserInformation(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              }
          )
        ],
      ),
    );
  }
}

Widget getUserInformation(context, snapshot){

  final db = Firestore.instance;
  final user = snapshot.data;

  Future<String> getName(user) async {
    final DocumentReference doc = db.collection("Users").document(user.uid);
    dynamic data;
    await doc.get().then<dynamic>((DocumentSnapshot snapshot) async {
      data = snapshot.data;
    });
    return data["name"];
  }


  return Container(
    child:
      FutureBuilder(
          future: getName(user),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done ) {
              return displayUserData(context, snapshot);
            } else {
              return CircularProgressIndicator();
            }
          }
      ),
  );

}

Widget displayUserData(context, snapshot){
  final name = snapshot.data;

  String getInitials(name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = 2;

    if(numWords < names.length) {
      numWords = names.length;
    }
    for(var i = 0; i < numWords; i++){
      initials += '${names[i][0]}';
    }
    return initials;
  }
  return Row(
    children: <Widget>[
      CircleAvatar(
        backgroundColor: Theme
            .of(context)
            .primaryColorLight,
        child: Text(
            "${getInitials(name)}",
            style: TextStyle(color: Colors.white)
        ),
        radius: 30.0,
      ),
      SizedBox(width: 12.0),
      Text(
        "${name}",
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    ],
  );



}

