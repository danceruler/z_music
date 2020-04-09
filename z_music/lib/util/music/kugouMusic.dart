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
  static String timeStamp = "";

  KugouMusic() {
    if (timeStamp == "") timeStamp = Util.currentTimeMillis().toString();
    if (requestCallback == "")
      requestCallback = "jQuery112409513165674145783_" + timeStamp;
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
        getMusicInfo(result[0]);
      } else {
        throw ReqException("请求异常，请尝试打开网页版酷狗音乐解锁");
      }
    });
    return result;
  }

  @override
  Future<Music> getMusicInfo(Music music) async {
    String apiUrl = Util.stringFormat(ApiList.kugou_getMusicInfo,
        [requestCallback, music.fileHash, music.albumId, timeStamp]);
    await http.get(apiUrl).then((response) {
      RegExp reg = new RegExp(r"(?=" + requestCallback + "\()(.*)(?=\))");
      var jsonStr = Util.onlyMatchOne(reg, response.body);
      jsonStr = jsonStr.substring(1, jsonStr.length - 2);
      var jsonMap = jsonDecode(jsonStr);
      if (jsonMap["err_code"] == 0) {
        music.coverUrl = jsonMap["data"]["img"];
        music.playUrl = jsonMap["data"]["play_url"];
        music.isfree = music.playUrl == "" ? 0 : 1;
        return music;
      } else {
        throw ReqException("请求异常，请尝试打开网页版酷狗音乐解锁");
      }
    });
    return music;
  }
}
