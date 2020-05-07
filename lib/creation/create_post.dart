import 'package:flutter/material.dart';
import 'package:neighborhood/creation/message.dart';
import 'package:neighborhood/creation/poll.dart';
import 'package:neighborhood/creation/event.dart';
import 'package:neighborhood/creation/alert.dart';


//neighborhood->Demo->Collection->
class CreatePost extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Message'),
    Tab(text: 'Poll'),
    Tab(text: 'Event'),
    Tab(text: 'Alert'),
  ];

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        primaryColorLight: Colors.lightBlue[300],
        primaryColorDark: Color(0x001970),
        accentColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Text('Create Post', style: TextStyle(color: Colors.black87, fontSize: 22.0, fontFamily: 'AirbnbCerealBold')),
              backgroundColor: Theme.of(context).primaryColor,
              titleSpacing: 0.0,
              elevation: 1.0,
              //automaticallyImplyLeading: true,
              leading: IconButton(
                  icon: Icon(Icons.close, color: Colors.black87,),
                  // Replace false with location to exit to
                  onPressed: () => Navigator.pop(context)),
              bottom: TabBar(
                //isScrollable: true,
                tabs: myTabs,
                indicatorColor: Theme.of(context).accentColor,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black54,
              )),
          body: TabBarView(
              children: <Widget>[Message(), Poll(), Event(), Alert()]
          ),
        ),
      ),
    );
  }
}