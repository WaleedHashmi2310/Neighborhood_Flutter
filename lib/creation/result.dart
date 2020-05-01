import 'package:flutter/material.dart';

class Result{

  String flag;
  String title;
  String post;
  String category;
  List<String> poll;
  Result({this.flag,this.title,this.post,this.category,this.poll}){
  }
  void func(){
    if(flag == 'M'){
      print('flag $flag');
      print('flag $category');
      print('title $title');
      print('post $post');
    }

    if(flag == 'P'){
      print('flag $flag');
      print('title $title');
      print('post $post');
      for(var i in poll){
        print('poll $i');
      }
    }

    if(flag=='A'){
      print('flag $flag');
      print('Alert is $post');
    }

    if(flag=='E'){
      print('flag $flag');
      print('flag $category');
      print('title $title');
      print('post $post');

    }
  }
}