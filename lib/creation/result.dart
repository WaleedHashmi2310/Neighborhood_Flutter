import 'package:flutter/material.dart';
//Ignore this file
//
//
//
//
//
//
//
//
//
class Result{

  String flag='';
  String title;
  String post='';
  String category='';
  String option1;
  String option2;
  String option3;
  String option4;
  Result(this.flag,this.title,this.post,this.category,this.option1,this.option2,this.option3,this.option4);
 
  Map<String, dynamic> toMessage() => {
    'category': category,
    'title': title,
    'post': post,
  };

   Map<String, dynamic> toPoll() => {
    'title': title,
    'description': post,
    'option1': option1,
    'option2': option2,
    'option3': option3,
    'option4': option4,
  };
   Map<String, dynamic> toEvent() => {
    'title': title,
    'description': post,
  };
   Map<String, dynamic> toAlert() => {
    'alert': title,
  };
  void printTitle(){
    print('title is $title');
  }
}