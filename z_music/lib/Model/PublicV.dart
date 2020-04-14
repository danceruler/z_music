
import 'dart:ui';

import 'package:flutter/cupertino.dart';


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
}

