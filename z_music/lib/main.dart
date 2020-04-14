// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/util/music/kugouMusic.dart';

/// This is an example of a counter application using `provider` + [ChangeNotifier].
///
/// It builds a typical `+` button, with a twist: the texts using the counter
/// are built using the localization framework.
///
/// This shows how to bind our custom [ChangeNotifier] to things like [LocalizationsDelegate].

void main() => runApp(MyApp());

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
    var musicinfo =
        await KugouMusic().getMusicInfo(musicList[index]);
    _music = musicinfo;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: Consumer<Counter>(
        builder: (context, counter, _) {
          return MaterialApp(
            // supportedLocales: const [Locale('fr', 'CH')],
            localizationsDelegates: [
              // DefaultMaterialLocalizations.delegate,
              // DefaultWidgetsLocalizations.delegate,
              _ExampleLocalizationsDelegate(counter.count),
            ],
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class ExampleLocalizations {
  static ExampleLocalizations of(BuildContext context) {
    return Localizations.of<ExampleLocalizations>(
        context, ExampleLocalizations);
  }

  const ExampleLocalizations(this._count);

  final int _count;

  String get title => 'Tapped $_count times';
}

class _ExampleLocalizationsDelegate
    extends LocalizationsDelegate<ExampleLocalizations> {
  const _ExampleLocalizationsDelegate(this.count);

  final int count;

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<ExampleLocalizations> load(Locale locale) {
    return SynchronousFuture(ExampleLocalizations(count));
  }

  @override
  bool shouldReload(_ExampleLocalizationsDelegate old) => old.count != count;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Title()),
      body: const Center(child: CounterLabel()),
      floatingActionButton: const IncrementCounterButton(),
    );
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
        Text("musicName:" + '${counter.music.name}'),
        MaterialButton(
          onPressed: () => counter.initMusic(),
          child: Text("更新音乐"),
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(ExampleLocalizations.of(context).title);
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
            onPressed: () => Provider.of<Counter>(context,listen: false).initMusic(),
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
