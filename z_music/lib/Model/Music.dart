

import 'package:audioplayer/audioplayer.dart';
import 'package:z_music/Model/AppProvider.dart';
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

class Player{
  static AudioPlayer audioPlayer = new AudioPlayer();
  //当前播放时间
  static Duration playingPosition = Duration.zero;

  MusicModel musicModel;
  Player({this.musicModel}){
    audioPlayer.onAudioPositionChanged.listen((e){
      playingPosition = e;
    });
    audioPlayer.onPlayerStateChanged.listen((e){
      if(e == AudioPlayerState.PLAYING){
        
      }else if(e == AudioPlayerState.COMPLETED){
        musicModel.next();
      }else if(e == AudioPlayerState.STOPPED){
        
      }else if(e == AudioPlayerState.PAUSED){
        
      }
    });
  }
}
