import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_music/Model/AppProvider.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/Widgets/RunLamp.dart';
import 'package:z_music/Widgets/painter/MusicPlayButtonPainter.dart';

// class MusicControl extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MusicControl();
// }

class MusicControl extends StatelessWidget {
  final double height = 45;
  @override
  Widget build(BuildContext context) {
    final musicModel = Provider.of<MusicModel>(context);
    final player = Provider.of<Player>(context);
    final width = MediaQuery.of(context).size.width;
    return new Container(
      color: Colors.white,
      height: height,
      child: Row(
        children: <Widget>[
          Container(
            height: height,
            width: 70,
          ),
          Expanded(
            child: RunLamp(
                Text(
                    '${musicModel.playingMusic.name == null ? '' : musicModel.playingMusic.name}${musicModel.playingMusic.singer == null ? '' : '-' + musicModel.playingMusic.singer}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    )),
                new Duration(seconds: 4),
                230.0,
                100.0,
                // 100,
                // 200
                width - 175,
                musicModel.playingMusic.name == null
                    ? 0
                    : double.parse(
                        (musicModel.playingMusic.name.length * 13).toString())),
          ),
          Container(
            height: height,
            width: 15,
          ),
          Container(
            height: height,
            width: 45,
            child: GestureDetector(
              onTap: () => Player.audioPlayer.state == AudioPlayerState.PLAYING?Player.audioPlayer.pause():Player.audioPlayer.play(Player.playingMusic.playUrl),
              child:MusicPlayButton(),
            ) 
          ),
          Container(
            height: height,
            width: 45,
            color: Colors.lightGreen,
          ),
        ],
      ),
    );
  }
}

class MusicPlayButton extends StatefulWidget {



  @override
  State<StatefulWidget> createState() => _MusicPlayButton();

  
}

class _MusicPlayButton extends State<MusicPlayButton> {
  @override
  Widget build(BuildContext context) {
    // final player = Provider.of<Player>(context);
    return CustomPaint(
      painter: MusicPlayButtonPainter(
        nowSecond: Player.playingPosition.inSeconds,
        allSeconds: Player.playingMusic.duration == null?1: Player.playingMusic.duration,
        isplaying:  Player.playState == AudioPlayerState.PLAYING?1:0
      ),
      size: Size(45,45)
    );
  }
}
