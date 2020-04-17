

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:z_music/Model/AppProvider.dart';
import 'package:z_music/Model/PublicV.dart';
import 'package:z_music/util/music/BasicMusic.dart';

class Music{
  String id;
  String mid;
  String albumId;
  String name;
  String playUrl;
  String coverUrl;
  String singer;
  int duration;
  String albumName;
  String fileHash;
  String sqFileHash;
  String hqFileHash;
  String mvHash;
  int isfree;
  List<Lyric> lyric;
  BasicMusic basicMusic;
  Music({
    this.id,this.albumId,
    this.name,this.playUrl,this.coverUrl,this.singer,this.duration,this.albumName,
    this.fileHash,this.sqFileHash,this.hqFileHash,this.mvHash,this.isfree,this.mid,this.basicMusic
  });
}

class Lyric{
  int startMiSeconds;
  String startTime;
  String text;

  Lyric({
    this.startMiSeconds,this.startTime,this.text
  });
}

class Player with ChangeNotifier{
  static AudioPlayer audioPlayer = new AudioPlayer();
  //当前播放时间
  static Duration playingPosition = Duration.zero;
  //播放顺序
  static int playOrder = PlayOrder.sequential;

  static AudioPlayerState playState = AudioPlayerState.STOPPED;
  
  static Music playingMusic = Music();

   //更改播放顺序
  void changePlayOrder() {
    playOrder = playOrder == 2 ? 0 : playOrder + 1;
    notifyListeners();
  }

  MusicModel musicModel;
  Player({this.musicModel}){
    audioPlayer.onAudioPositionChanged.listen((e){
      playingPosition = e;
      notifyListeners();
    });
    audioPlayer.onPlayerStateChanged.listen((e){
      playState = e;
      notifyListeners();
      if(e == AudioPlayerState.PLAYING){

      }else if(e == AudioPlayerState.COMPLETED){
        musicModel.next();
      }else if(e == AudioPlayerState.STOPPED){
        
      }else if(e == AudioPlayerState.PAUSED){
      }
      
    });
  }

}
