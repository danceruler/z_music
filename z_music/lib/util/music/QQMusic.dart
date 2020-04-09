import 'dart:convert';

import 'package:z_music/Model/Api.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/Model/ReqExc.dart';
import 'package:z_music/util/music/BasicMusic.dart';
import 'package:z_music/util/util.dart';
import 'package:http/http.dart' as http;

class QQMusic implements BasicMusic {
  static String search_jsonpCallback = "";
  static String musicinfo_jsonpCallback = "";
  static String uin = "821768698";
  QQMusic() {
    if (search_jsonpCallback == "")
      search_jsonpCallback = "MusicJsonCallback508892649653171";
    if (musicinfo_jsonpCallback == "")
      musicinfo_jsonpCallback = "getplaysongvkey9450374523862113";
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
          "songmid": [music.id],
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
    print(apiUrl);
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
      return music;
    });
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
              id: jsonObject["mid"],
              duration: jsonObject["interval"],
              coverUrl: Util.stringFormat(
                  ApiList.qq_coverImg, [jsonObject["album"]["pmid"]]),
              isfree: jsonObject["pay"]["price_track"] != 0 ? 0 : 1,
            );
            result.add(music);
          }
        }
        return result;
      }
      //此时表示请求失败
      else {
        throw ReqException("请求异常,请尝试打开网页版qq音乐解锁");
      }
    });
  }
}
