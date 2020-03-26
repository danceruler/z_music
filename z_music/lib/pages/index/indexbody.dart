import 'package:flutter/material.dart';
import 'dart:ui';

Widget IndexBody(){
  return Container(
    margin: EdgeInsets.fromLTRB(0, MediaQueryData.fromWindow(window).padding.top, 0, 0),
    child: Column(
      children: <Widget>[
       Row(
         children: <Widget>[
           Container(
             width: 150.0,
             height: 50.0,
             alignment: Alignment.center,
             child: Text('音乐馆',style: TextStyle(fontSize: 40),),
           ),
           Expanded(
             child: searchContainer()
            )
         ],
       ),
       
     ],
   ),
  );
}

Widget searchTextField(){
  return TextField(
    cursorColor: Colors.white,
    decoration: InputDecoration(
      contentPadding:new EdgeInsets.only(left:0.0),
      border:InputBorder.none,
      hintText:'Search',
      hintStyle: new TextStyle(fontSize:14,color:Colors.grey),
    ),
    style:new TextStyle(fontSize:14,color:Colors.grey),
  );
}

Widget searchContainer(){
  return Container(
    decoration: new BoxDecoration(
      border: Border.all(color:Colors.grey,width:2.0),
      color: Colors.white,
      borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
    ),
    alignment: Alignment.center,
    height: 50,
    child: searchTextField(),
    margin: EdgeInsets.only(top: 20,right: 10),
  );
}