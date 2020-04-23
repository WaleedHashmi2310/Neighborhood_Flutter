import 'package:flutter/material.dart';
import 'package:neighborhood/services/auth_provider.dart';
import 'dart:async';


class HomePage extends StatelessWidget {


  Future<void> _signOut(BuildContext context) async{
    try{
      final auth = AuthProvider.of(context);
      await auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Signing Out'),
            content: Text('Are you sure you want to sign out?', style: TextStyle(fontFamily: 'AirbnbCerealLight'),),
            actions: [
              FlatButton(
                child: Text(
                    'Cancel',
                ),
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Continue'),
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  _signOut(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: Colors.white,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
//              child: Text(
//                'DRAWER',
//                style: TextStyle(color: Colors.white)
//              )

              ),
              ListTile(
                leading: Icon(Icons.sort),
                title: Text('View all Crime & Safety'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.sort),
                title: Text('View all Lost & Found'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.sort),
                title: Text('View all for Sale & Free'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              SizedBox(height: 176.0),
              ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red[400],),
                  title:Text('Sign Out', style: TextStyle(color: Colors.red[400]),),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmSignOut(context);
                  }
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        title: Text(
            'Askari XI',
            style: TextStyle(color: Colors.black87, fontSize: 22.0, fontFamily: 'AirbnbCerealBold')

        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: new IconThemeData(color: Colors.black87),
        titleSpacing: 0.0,
        elevation: 0.0,
      ),
    );
  }
}
