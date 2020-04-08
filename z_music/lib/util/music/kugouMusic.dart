
import 'package:z_music/Model/Api.dart';
import 'package:z_music/Model/HttpReponse.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/util/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'BasicMusic.dart';

class KugouMusic implements BasicMusic{
  static String requestCallback = "";
  static String timeStamp = "";

  KugouMusic() {
    if (timeStamp == "") timeStamp = Util.currentTimeMillis().toString();
    if (requestCallback == "")
      requestCallback = "jQuery112409513165674145783_" + timeStamp;
  }

  @override
  Future<List<Music>> searchLits(
      String key, int page, int pageSize) async {
    try {
      List<Music> result = new List<Music>();
      String apiUrl = Util.stringFormat(ApiList.kugou_searchList, [
        key,
        page.toString(),
        pageSize.toString(),
        timeStamp,
        requestCallback
      ]);
      print(apiUrl);
      await http.get(apiUrl).then((response) {
        RegExp reg = new RegExp(r"(?="+requestCallback+"\()(.*)(?=\))");
        var jsonStr = Util.onlyMatchOne(reg, response.body);
        jsonStr = jsonStr.substring(1,jsonStr.length-1);
        var resModel = KuGouSearchLitsRes.fromJson(jsonDecode(jsonStr));
        print(resModel);
        for(KuGouSearchLitsRes_data_list item in resModel.data.lists){
          Music music = new Music(
            id: item.ID,
            albumId: item.AlbumID,
            name: item.SongName.replaceAll('<em>', '').replaceAll('</em>', ''),
            playUrl:"",
            coverUrl: "",
            singer:item.SingerName,
            duration:item.Duration,
            albumName:item.AlbumName,
            fileHash:item.FileHash,
            sqFileHash: item.SQFileHash,
            hqFileHash: item.HQFileHash,
            mvHash: item.MvHash
          );
          result.add(music);
        }
      });
      // var musicInfo = getMusicInfo(result[0]);
      return result;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<Music> getMusicInfo(Music music) async{
    String apiUrl = Util.stringFormat(ApiList.kugou_getMusicInfo, 
    [
      requestCallback,
      music.fileHash,
      music.albumId,
      timeStamp
    ]);
    await http.get(apiUrl).then((response){ 
      RegExp reg = new RegExp(r"(?="+requestCallback+"\()(.*)(?=\))");
      var jsonStr = Util.onlyMatchOne(reg, response.body);
      jsonStr = jsonStr.substring(1,jsonStr.length-2);
      var jsonMap = jsonDecode(jsonStr);
      music.coverUrl = jsonMap["data"]["img"];
      music.playUrl = jsonMap["data"]["play_url"];
      print("coverurl:"+music.coverUrl);
      print("playurl:"+music.playUrl);
    });
    return music;
  }

}
