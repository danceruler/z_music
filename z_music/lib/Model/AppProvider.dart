import 'package:flutter/foundation.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/Model/PublicV.dart';



class MusicModel with ChangeNotifier{
  //当前播放歌单
  List<Music> _playList;
  //当前播放歌曲在歌单内的下标
  int _playIndex;
  //播放顺序
  int _playOrder = PlayOrder.sequential;
  
  
  get playList => _playList;
  get playIndex => _playIndex;
  get playOrder => _playOrder;

  //下一首
  void next(){

  }

  //上一首
  void last(){

  }

  //播放
  void play(){

  }

  //暂停
  void pause(){

  }



}

class Counter with ChangeNotifier {
  int _count;
  Counter(this._count);

  void add() {
    _count++;
    notifyListeners();//2
  }
  get count => _count;//3
}