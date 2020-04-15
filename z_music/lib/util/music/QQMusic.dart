import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:z_music/Model/Api.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/Model/ReqExc.dart';
import 'package:z_music/util/music/BasicMusic.dart';
import 'package:z_music/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class QQMusic implements BasicMusic {
  static String search_jsonpCallback = "";
  static String musicinfo_jsonpCallback = "";
  static String lyric_jsonpCallback = "";
  static String uin = "821768698";
  QQMusic() {
    if (search_jsonpCallback == "")
      search_jsonpCallback = "MusicJsonCallback508892649653171";
    if (musicinfo_jsonpCallback == "")
      musicinfo_jsonpCallback = "getplaysongvkey9450374523862113";
    if(lyric_jsonpCallback == "")
      lyric_jsonpCallback = "jsonp1";
  }

  @override
  Future<Music> getMusicInfo(Music music) async {
    var data = {
      "req": {
        "module": "CDN.SrfCdnDispatchServer",
        "method": "GetCdnDispatch",
        "param": {"guid": "5464878", "calltype": 0, "userip": ""}
      },
      "req_0": {
        "module": "vkey.GetVkeyServer",
        "method": "CgiGetVkey",
        "param": {
          "guid": "5464878",
          "songmid": [music.mid],
          "songtype": [0],
          "uin": uin,
          "loginflag": 1,
          "platform": "20"
        }
      },
      "comm": {"uin": uin, "format": "json", "ct": 24, "cv": 0}
    };
    var apiUrl = Util.stringFormat(ApiList.qq_getMusicInfo, [
      musicinfo_jsonpCallback,
      "0",
      jsonEncode(data)
      // UrlEncode().encode(jsonEncode(data))
    ]);
    await http.get(apiUrl).then((response) {
      RegExp reg =
          new RegExp(r"(?=" + musicinfo_jsonpCallback + "\()(.*)(?=\))");
      var jsonStr = Util.onlyMatchOne(reg, utf8.decode(response.bodyBytes));
      jsonStr = jsonStr.substring(1, jsonStr.length - 1);
      var jsonMap = jsonDecode(jsonStr);
      if (jsonMap["code"] == 0) {
        music.playUrl = jsonMap["req_0"]["data"]["sip"][0] +
            jsonMap["req_0"]["data"]["midurlinfo"][0]["purl"];
      } else {
        throw ReqException("请求异常,请尝试打开网页版qq音乐解锁");
      }
    });
    //获取音乐的歌词数据
    var lyricApiUrl = Util.stringFormat(ApiList.qq_lyric, [
      music.id,
      lyric_jsonpCallback,
      uin
    ]);
    Map<String,String> headers = {
      "Referer":"https://y.qq.com/n/yqq/song/"+music.mid+".html",
    };
    var lyricStr = "";
    await http.get(lyricApiUrl,headers: headers).then((response){
      RegExp reg =
          new RegExp(r"(?=" + lyric_jsonpCallback + "\()(.*)(?=\))");
      var jsonStr = Util.onlyMatchOne(reg, response.body);
      jsonStr = jsonStr.substring(1, jsonStr.length - 1);
      var jsonMap = jsonDecode(jsonStr);
      lyricStr = parse(jsonMap["lyric"]).body.innerHtml;
    });
    music.lyric = await getMusicLyrics(lyricStr);
    print(music.playUrl);
    return music;
  }

  @override
  Future<List<Music>> searchLits(String key, int page, int pageSize) async {
    List<Music> result = List<Music>();
    var apiUrl = Util.stringFormat(ApiList.qq_searchlist,
        [page.toString(), pageSize.toString(), key, search_jsonpCallback, uin]);
    await http.get(apiUrl).then((response) {
      RegExp reg = new RegExp(r"(?=" + search_jsonpCallback + "\()(.*)(?=\))");
      var jsonStr = Util.onlyMatchOne(reg, response.body);
      jsonStr = jsonStr.substring(1, jsonStr.length - 1);
      var jsonMap = jsonDecode(jsonStr);
      if (jsonMap["code"] == 0) {
        //此时表示没有数据
        if (jsonMap["data"]["song"]["list"].length == 0) {
          return result;
        } else {
          for (int i = 0; i < jsonMap["data"]["song"]["list"].length; i++) {
            var jsonObject = jsonMap["data"]["song"]["list"][i];
            Music music = Music(
              name: jsonObject["title"],
              singer: jsonObject["singer"][0]["title"],
              albumId: jsonObject["album"]["id"].toString(),
              albumName: jsonObject["album"]["title"],
              id: jsonObject["id"].toString(),
              mid:jsonObject["mid"],
              duration: jsonObject["interval"],
              coverUrl: Util.stringFormat(
                  ApiList.qq_coverImg, [jsonObject["album"]["pmid"]]),
              isfree: jsonObject["pay"]["pay_play"] == 0 ? 1 : 0,
              basicMusic:QQMusic()
            );
            result.add(music);
          }
        }
      }
      //此时表示请求失败
      else {
        throw ReqException("请求异常,请尝试打开网页版qq音乐解锁");
      }
    });
    await getMusicInfo(result[0]);
    // await getMusicInfo(result[1]);
    return result;
  }

  @override
  Future<List<Lyric>> getMusicLyrics(String lyricStr) async{
    List<Lyric> lyrics = List<Lyric>();
    var lyricStrList = lyricStr.split('\n');
    for(int i = 5;i<lyricStrList.length;i++){
      var int_m = int.parse(lyricStrList[i].substring(1,3));
      var int_s = int.parse(lyricStrList[i].substring(4,6));
      var int_ms = int.parse(lyricStrList[i].substring(7,9));
      var text = "";
      if(lyricStrList[i].length >= 10){
        text = lyricStrList[i].substring(10,lyricStrList[i].length);
      }
      if(text.isEmpty){
        continue;
      }
      Lyric lyric = Lyric(
        startMiSeconds: int_m*60000+int_s*1000+int_ms*10,
        startTime: lyricStrList[i].substring(1,9),
        text: text,
      );
      lyrics.add(lyric);
    }
    return lyrics;
  }

  
}
