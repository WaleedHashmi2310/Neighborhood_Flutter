import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({
    Key key,
    this.username,
    this.title,
    this.description,
    this.category,
    this.image,
  });
  final String username;
  final String title;
  final String description;
  final String category;
  final String image;

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {

  Color _iconColor = Colors.grey;

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

  @override
  Widget build(BuildContext context) {
//    var time = DateTime(2020, 5, 4);
//    var currentTime = DateTime.now();
//    final difference = currentTime.difference(time).inDays;
  if(widget.username != null && widget.title != null && widget.description != null && widget.category != null){
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: CircleAvatar(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColorLight,
                              child: Text(
                                  "${getInitials(widget.username)}",
                                  style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w500)
                              ),
                              radius: 16.0,
                            )
                        ),

                        SizedBox(width: 8.0),

                        Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.username,
                                style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500, fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        Container(
                          child: Text(
                            widget.category,
                            style: TextStyle(color: Colors.black54, fontSize: 12.0),
                          ),
                        )
                      ]
                  ),
                ),

                imageBuilder(context),

                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                        )),
                    collapsed: Text(
                      widget.description,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              widget.description,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
                Container(
//                  decoration: BoxDecoration(
//                    border: Border(
//                      top: BorderSide(
//                        color: Colors.grey[400],
//                      )
//                    )
//                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: IconButton(
                              icon: Icon(Icons.favorite_border,
                                color: _iconColor,
                                size: 24.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _iconColor = Colors.red;
                                });
                              },
                            )
                        ),
                        Container(
                            child: Text(
                              "Upvote",
                              style: TextStyle(color: Colors.grey),
                            )
                        ),
                        SizedBox(width: 12.0,),
                        Container(
                            child: IconButton(
                              icon: Icon(Icons.comment,
                                color: Colors.grey,
                                size: 24.0,
                              ),
                            )
                        ),
                        Container(
                            child: Text(
                              "Comment",
                              style: TextStyle(color: Colors.grey),
                            )
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        )
    );
  } else {
    return Container(
      color: Colors.white,
    );
  }

  }

  Widget imageBuilder(BuildContext context){
    if (widget.image != null){
      return SizedBox(
        height: 150,
        child: Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage(widget.image),
                fit: BoxFit.fill,
            )
          ),
        ),
      );
    }else{
      return SizedBox(
        height: 1.0,
      );
    }
  }
}