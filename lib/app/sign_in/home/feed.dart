import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood/common_widgets/expandable_card.dart';

class Feed extends StatelessWidget {
  String username = "Waleed Hashmi";
  String category = "For Sale & Free";
  String title = "Slightly used couch for sale";
  String description = "Seliing a 3-seater couch in mint condition. Item can be checked at House#23";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ExpandableTheme(
            data:
            const ExpandableThemeData(iconColor: Colors.blue, useInkWell: true),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                ExpandableCard(
                  title: title,
                  description: description,
                  username: username,
                  category: category,
                ),
              ],
            )
        )
    );
  }
}


