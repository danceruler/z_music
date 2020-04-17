// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_music/Model/AppProvider.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/Model/PublicV.dart';
import 'package:z_music/pages/index/index.dart';
import 'package:z_music/util/music/QQMusic.dart';
import 'package:z_music/util/music/kugouMusic.dart';

import 'Widgets/musiccontrol.dart';

/// This is an example of a counter application using `provider` + [ChangeNotifier].
///
/// It builds a typical `+` button, with a twist: the texts using the counter
/// are built using the localization framework.
///
/// This shows how to bind our custom [ChangeNotifier] to things like [LocalizationsDelegate].

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => MusicModel()),
        ChangeNotifierProvider(create: (_) => Player()),
      ],
      child: Consumer<Counter>(
        builder: (context, counter, _) {
          return MaterialApp(
            // supportedLocales: const [Locale('fr', 'CH')],
            // localizationsDelegates: [
            //   // DefaultMaterialLocalizations.delegate,
            //   // DefaultWidgetsLocalizations.delegate,
            //   _ExampleLocalizationsDelegate(counter.count),
            // ],
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

// class ExampleLocalizations {
//   static ExampleLocalizations of(BuildContext context) {
//     return Localizations.of<ExampleLocalizations>(
//         context, ExampleLocalizations);
//   }

//   const ExampleLocalizations(this._count);

//   final int _count;

//   String get title => 'Tapped $_count times';
// }

// class _ExampleLocalizationsDelegate
//     extends LocalizationsDelegate<ExampleLocalizations> {
//   const _ExampleLocalizationsDelegate(this.count);

//   final int count;

//   @override
//   bool isSupported(Locale locale) => locale.languageCode == 'en';

//   @override
//   Future<ExampleLocalizations> load(Locale locale) {
//     return SynchronousFuture(ExampleLocalizations(count));
//   }

//   @override
//   bool shouldReload(_ExampleLocalizationsDelegate old) => old.count != count;
// }

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicModel = Provider.of<MusicModel>(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      // appBar: AppBar(title: const Title()),
      backgroundColor: Colors.blue,
      body: const Center(child: CounterLabel()),
      floatingActionButton: Container(
        child: ClipOval(
          child: Image(
            image: musicModel.playingMusic.coverUrl == null ||
                    musicModel.playingMusic.coverUrl == ""
                ? AssetImage("images/logo.png")
                : NetworkImage(musicModel.playingMusic.coverUrl),
            height: 45,
            width: 45,
            fit: BoxFit.fill,
          ),
        ),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, -(width / 2 - 33), 17),
      bottomNavigationBar: Z_Music_BottomAppBar(),
    );
  }
}

class Z_Music_BottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final musicModel = Provider.of<MusicModel>(context);
    return BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Container(
          height: 100,
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              MusicControl(),
              Divider(
                height: 0.5,
                indent: 0.0,
                color: Color(0xFFdcdcdc),
              ),
              Row(
                //里边可以放置大部分Widget，让我们随心所欲的设计底栏
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      // setState(() {
                      //   _index = 0;
                      // });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.access_alarms, color: Colors.white),
                    color: Colors.white,
                    onPressed: () {
                      // setState(() {
                      //   _index = 1;
                      // });
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class IncrementCounterButton extends StatelessWidget {
  const IncrementCounterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Provider.of<Counter>(context, listen: false).increment();
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class CounterLabel extends StatelessWidget {
  const CounterLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    final musicModel = Provider.of<MusicModel>(context);
    final player = Provider.of<Player>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '${counter.count}',
          // ignore: deprecated_member_use
          style: Theme.of(context).textTheme.display1,
        ),
        MaterialButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SecondPage();
                })),
            child: Text("toNextPage")),
        Text("musicName:" + '${musicModel.playingMusic.name}'),
        MaterialButton(
          onPressed: () async => {
            musicModel.setPlayList(await KugouMusic().searchLits("天下", 1, 10))
          },
          child: Text("更新音乐"),
        ),
        Text("当前播放顺序为" + PlayOrder.getName(Player.playOrder)),
        MaterialButton(
          onPressed: () => player.changePlayOrder(),
          child: Text("修改播放顺序"),
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text(ExampleLocalizations.of(context).title);
    return Text("z_music_demo");
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Text("${Provider.of<Counter>(context).count}"),
          Text("musicName:" + '${Provider.of<Counter>(context).music.name}'),
          MaterialButton(
            onPressed: () =>
                Provider.of<Counter>(context, listen: false).initMusic(),
            child: Text("更新音乐"),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<Counter>(context, listen: false).increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
