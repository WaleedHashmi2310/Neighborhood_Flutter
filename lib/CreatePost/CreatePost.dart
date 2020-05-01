import 'package:flutter/material.dart';
import './message.dart';
import './Poll.dart';
import './event.dart';
import './Alert.dart';

//void main() => runApp(CreatePost());

class CreatePost extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
              title: Text('Create Post'),
              automaticallyImplyLeading: true,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  // Replace false with location to exit to
                  onPressed: () => Navigator.pop(context)),
              bottom: TabBar(
                isScrollable: true,
                tabs: <Widget>[
                  Text('Message'),
                  Text('Poll'),
                  Text('Event'),
                  Text('Alert')
                ],
              )),
          body: TabBarView(
              children: <Widget>[Message(), Poll(), Event(), Alert()]),
        ),
      ),
    );
  }
}
