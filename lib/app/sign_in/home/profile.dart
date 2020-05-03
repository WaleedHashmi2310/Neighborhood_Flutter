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
                  return displayUserInformation(context, snapshot);
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

Widget displayUserInformation(context, snapshot){
  final user = snapshot.data;
  final name = user.displayName;
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
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      CircleAvatar(
        backgroundColor: Theme.of(context).primaryColorLight,
        child: Text(
            "${getInitials(name)}",
            style: TextStyle(color: Colors.white)
        ),
        radius: 30.0,
      ),
      SizedBox(width: 12.0),
      Text(
        "${snapshot.data.displayName}",
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),

    ],
  );

}
