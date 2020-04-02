import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:z_music/page2.dart';
import './indexbody.dart';

class IndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>{
    final _bottomNavigationColor = Colors.green;
    int _currentIndex = 0;

    List<Widget> list = List();

    @override
    void initState() {
      list
        ..add(IndexBody())
        ..add(Page2());
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    
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
      body: list[_currentIndex],
      bottomNavigationBar:BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text(
                'HOME',
                style: TextStyle(),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.music_note,
              ),
              title: Text(
                'Music',
                style: TextStyle(),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.file_download,
              ),
              title: Text(
                'Download',
                style: TextStyle(),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text(
                'My',
                style: TextStyle(),
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ) 
    );
  }
}