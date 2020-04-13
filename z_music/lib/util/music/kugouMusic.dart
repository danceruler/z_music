import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:z_music/Model/Api.dart';
import 'package:z_music/Model/HttpReponse.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/Model/ReqExc.dart';
import 'package:z_music/util/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'BasicMusic.dart';

//酷狗音乐获取音乐列表时无法判断音乐是否免费
//不要短时间内多次调用getMusicInfo，
class KugouMusic implements BasicMusic {
  static String requestCallback = "";
  static String requestMobileImgCallback = "";
  static String timeStamp = "";

  KugouMusic() {
    if (timeStamp == "") timeStamp = Util.currentTimeMillis().toString();
    if (requestCallback == "")
      requestCallback = "jQuery112409513165674145783_" + timeStamp;
    if (requestMobileImgCallback == "")
      requestMobileImgCallback = "kgJSONP179900027";
  }

  @override
  Future<List<Music>> searchLits(String key, int page, int pageSize) async {
    List<Music> result = new List<Music>();
    String apiUrl = Util.stringFormat(ApiList.kugou_searchList, [
      key,
      page.toString(),
      pageSize.toString(),
      timeStamp,
      requestCallback
    ]);

    await http.get(apiUrl).then((response) {
      RegExp reg = new RegExp(r"(?=" + requestCallback + "\()(.*)(?=\))");
      var jsonStr = Util.onlyMatchOne(reg, response.body);
      jsonStr = jsonStr.substring(1, jsonStr.length - 1);
      var resModel = KuGouSearchLitsRes.fromJson(jsonDecode(jsonStr));
      if (resModel.status == 1) {
        for (KuGouSearchLitsRes_data_list item in resModel.data.lists) {
          Music music = new Music(
              id: item.ID,
              albumId: item.AlbumID,
              name:
                  item.SongName.replaceAll('<em>', '').replaceAll('</em>', ''),
              playUrl: "",
              coverUrl: "",
              singer: item.SingerName,
              duration: item.Duration,
              albumName: item.AlbumName,
              fileHash: item.FileHash,
              sqFileHash: item.SQFileHash,
              hqFileHash: item.HQFileHash,
              mvHash: item.MvHash);
          result.add(music);
        }
      } else {
        throw ReqException("请求异常，请确定该网络是否可以正常使用酷狗音乐网页版播放歌曲");
      }
    });
    await getMusicInfo(result[0]);
    return result;
  }

  @override
  Future<Music> getMusicInfo(Music music) async {
    try {
      String apiUrl = Util.stringFormat(ApiList.kugou_getMusicInfo,
          [requestCallback, music.fileHash, music.albumId, timeStamp]);
      Map<String, String> headers = {
        "Accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language":
            "zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2",
        "Cache-Control": "max-age=0",
        "Connection": "keep-alive",
        "Cookie":
            "kg_mid=a1d421b9093150b003fbcd4de3ac3b15; Hm_lvt_aedee6983d4cfc62f509129360d6bb3d=1586421377,1586439179,1586509537,1586510990; kg_dfid=1aJS0t0U5yRr0qQNef02gPgO; Hm_lpvt_aedee6983d4cfc62f509129360d6bb3d=1586511002; kg_dfid_collect=d41d8cd98f00b204e9800998ecf8427e",
        "Host": "wwwapi.kugou.com",
        "If-Modified-Since": "Fri, 10 Apr 2020 09:55:57 GMT",
        "TE": "Trailers",
        "Upgrade-Insecure-Requests": "1",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0"
      };
      await http.get(apiUrl, headers: headers).then((response) {
        RegExp reg = new RegExp(r"(?=" + requestCallback + "\()(.*)(?=\))");
        var jsonStr = Util.onlyMatchOne(reg, response.body);
        jsonStr = jsonStr.substring(1, jsonStr.length - 2);
        var jsonMap = jsonDecode(jsonStr);
        if (jsonMap["err_code"] == 0) {
          music.coverUrl = jsonMap["data"]["img"];
          music.playUrl = jsonMap["data"]["play_url"];
          music.isfree = music.playUrl == "" ? 0 : 1;
        } else {
          throw ReqException("请求异常，请确定该网络是否可以正常使用酷狗音乐网页版播放歌曲");
        }
      });
      return music;
    } on ReqException catch (e) {
      //电脑网页版接口获取不到歌曲信息，用手机版接口获取
      return await getMusicInfoByMobileApi(music);
    }
  }

  Future<Music> getMusicInfoByMobileApi(Music music) async {
    try {
      var playApiUrl =
          Util.stringFormat(ApiList.kugou_mobile_musicinfo, [music.fileHash]);
      Map<String, String> tempheaders = {
        "Accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language":
            "zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2",
        "Cache-Control": "max-age=0",
        "Connection": "keep-alive",
        "Cookie":
            "kg_mid=a1d421b9093150b003fbcd4de3ac3b15; Hm_lvt_aedee6983d4cfc62f509129360d6bb3d=1586421377,1586439179,1586509537,1586510990; kg_dfid=1aJS0t0U5yRr0qQNef02gPgO; Hm_lpvt_aedee6983d4cfc62f509129360d6bb3d=1586511002; kg_dfid_collect=d41d8cd98f00b204e9800998ecf8427e",
        "Host": "m3ws.kugou.com",
        "TE": "Trailers",
        "Upgrade-Insecure-Requests": "1",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0",
        "Referer": "https://m3ws.kugou.com"
      };
      await http.get(playApiUrl, headers: tempheaders).then((response) {
        var jsonMap = jsonDecode(response.body);
        if (jsonMap["error"] == "需要付费") {
          music.isfree = 0;
          music.playUrl = "";
        } else {
          music.isfree = 1;
          music.playUrl = jsonMap["backup_url"][0];
        }
      });
      var imgApiUrl = Util.stringFormat(
          ApiList.kugou_mobile_img, [music.fileHash, requestMobileImgCallback]);
      await http.get(imgApiUrl).then((response) {
        var jsonMap = jsonDecode(response.body);
        if (jsonMap["status"] == 1) {
          music.coverUrl = jsonMap["url"];
        }
      });
      var lyricApiUrl =
          Util.stringFormat(ApiList.kugou_mobile_lyric, [music.fileHash]);
      var lyricStr = "";
      await http.get(lyricApiUrl).then((response) {
        lyricStr = utf8.decode(response.bodyBytes);
      });
      music.lyric = await getMusicLyrics(lyricStr);
    } catch (e) {}
    return music;
  }

  @override
  Future<List<Lyric>> getMusicLyrics(String lyricStr) async {
    List<Lyric> lyrics = List<Lyric>();
    var lyricStrList = lyricStr.split('\n');
    for(int i = 10;i<lyricStrList.length;i++){
      if(lyricStrList[i].length < 10) continue;
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
