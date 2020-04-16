
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PublicV{
  double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
  
}

//播放顺序
class PlayOrder{
  //顺序播放
  static int sequential = 0;
  //随机播放
  static int random = 1;
  //单曲循环
  static int loop = 2;
  
  static String getName(int playorder){
    switch(playorder){
      case 0:
        return "顺序播放";
      case 1:
        return "随机播放";
      case 2:
        return "单曲循环";
      default:
        return "";
    }

  }
}

//播放栏封面图
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;    // X方向的偏移量
  double offsetY;    // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

