import 'dart:math';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/Model/PublicV.dart';
import 'package:z_music/util/music/kugouMusic.dart';

class MusicModel with ChangeNotifier {
  //当前播放歌单
  List<Music> _playList;
  //当前播放歌曲在歌单内的下标(第一首为0)
  int _playIndex;

  get playList => _playList;
  get playIndex => _playIndex;

  Player player;
  MusicModel() {
    player = new Player(musicModel: this);
  }

  Music get playingMusic =>
      _playIndex == null ? Music() : _playList[_playIndex];

  //点击歌曲播放并会重新设置当前歌单
  void setPlayList(List<Music> musics) {
    _playList = musics;
    _playIndex = 0;
    Player.playingPosition = Duration.zero;
    play();
    notifyListeners();
  }

  //从当前歌单中选择歌曲播放
  void chooseMusicInPlayList(int index) {
    _playIndex = index;
    Player.playingPosition = Duration.zero;
    play();
    notifyListeners();
  }

  //下一首
  void next() {
    if (Player.playOrder == PlayOrder.sequential) {
      _playIndex = _playIndex == _playList.length - 1 ? 0 : _playIndex + 1;
    } else if (Player.playOrder == PlayOrder.random) {}
    Player.playingPosition = Duration.zero;
    play();
    notifyListeners();
  }

  //上一首
  void last() {
    if (Player.playOrder == PlayOrder.sequential) {
      _playIndex =
          _playIndex == 0 ? _playList[_playList.length - 1] : _playIndex - 1;
    } else if (Player.playOrder == PlayOrder.random) {}
    Player.playingPosition = Duration.zero;
    play();
    notifyListeners();
  }

  //播放
  void play() async {
    if(Player.audioPlayer.state == AudioPlayerState.PLAYING){
      Player.audioPlayer.stop();
    }
    Music music = playList[_playIndex] as Music;
    if (music.isfree == null) {
      music = await music.basicMusic.getMusicInfo(music);
    }
    Player.audioPlayer.play(music.playUrl);
    Player.playingMusic = music;
    notifyListeners();
  }

  //暂停
  void pause() {
    Player.audioPlayer.pause();
    notifyListeners();
  }

  void clickPlaybtn(){
    if(Player.audioPlayer.state == AudioPlayerState.PLAYING){
      pause();
    }else{
      play();
    }
  }
}


class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  Music _music = Music();
  Music get music => _music;

  void increment() {
    _count++;
    notifyListeners();
  }

  void initMusic() async {
    var musicList = await KugouMusic().searchLits("天下", 1, 10);
    var index = Random().nextInt(9);
    var musicinfo = await KugouMusic().getMusicInfo(musicList[index]);
    _music = musicinfo;
    notifyListeners();
  }
}
