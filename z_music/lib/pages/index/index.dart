import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './indexbody.dart';

class IndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Colors.red,
      //   // title: Text('标题',style: TextStyle(color: Colors.white),),
      //   // centerTitle: true,
      //   // elevation: 10.0,
      //   // leading: Icon(Icons.home),
      //   // actions: <Widget>[
      //   //   Icon(Icons.add),
      //   // ],
      //   // bottom: PreferredSize(
      //   //   child: Container(
      //   //     height: 50.0,
      //   //     child: Center(
      //   //       child: Text('显示在标题下面的内容'),
      //   //     ),
      //   //     decoration: BoxDecoration(
      //   //       color: Colors.redAccent,
      //   //     ),
      //   //   ),
      //   //   preferredSize: Size.fromHeight(50.0),
      //   // ),
      // ),
      body: IndexBody(),
    );
  }
}