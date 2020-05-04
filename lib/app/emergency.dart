import 'package:flutter/material.dart';

class Emergency extends StatelessWidget {

  Widget build(BuildContext context) {
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
      )
    );
  }
}