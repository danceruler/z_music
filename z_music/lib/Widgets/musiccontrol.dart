import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_music/Model/AppProvider.dart';

class MusicControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MusicControl();
}

class _MusicControl extends State<MusicControl> {
  @override
  Widget build(BuildContext context) {
    final musicModel = Provider.of<MusicModel>(context);
    return new Stack(
      // alignment: const FractionalOffset(0.5, 0.7),
      children: <Widget>[
        new Container(
          height: 60,
          child: new Column(
            children: <Widget>[
              // Container(
              //   height: 15,
              //   width: 2,
              //   decoration: new BoxDecoration(
              //     color: Colors.transparent,
              //   ),
              // ),
              Container(
                height: 60,
                width: 1000,
                decoration: new BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // new Positioned(
        //   top: 0,
        //   left: 0,
        //   child: Container(
        //     child: ClipOval(
        //       child: Image(
        //         image: musicModel.playingMusic.coverUrl == null
        //             ? AssetImage("images/logo.png")
        //             : NetworkImage(musicModel.playingMusic.coverUrl),
        //         height: 60,
        //         width: 60,
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );

    return Row(
      children: <Widget>[
        Container(
          child: ClipOval(
            child: Image(
              image: musicModel.playingMusic.coverUrl == null
                  ? AssetImage("images/logo.png")
                  : NetworkImage(musicModel.playingMusic.coverUrl),
              height: 65,
              width: 65,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
