
import 'package:z_music/Model/Api.dart';
import 'package:z_music/Model/HttpReponse.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/util/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KugouMusic {
  static String requestCallback = "";
  static String timeStamp = "";

  KugouMusic() {
    if (timeStamp == "") timeStamp = Util.currentTimeMillis().toString();
    if (requestCallback == "")
      requestCallback = "jQuery112409513165674145783_" + timeStamp;
  }

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
        Iterable<RegExpMatch> matches = reg.allMatches(response.body);
        var jsonStr = "";
        for(RegExpMatch m in matches){
          for(int i = 0 ;i<m.groupCount+1;i++){
            if(m.group(i).length > 0) {
              jsonStr = m.group(i);
              break;
            }
          }
        }
        jsonStr = jsonStr.substring(1,jsonStr.length);
        jsonStr = jsonStr.substring(0,jsonStr.length-1);
        var resModel = KuGouSearchLitsRes.fromJson(jsonDecode(jsonStr));
        print(resModel);
        for(KuGouSearchLitsRes_data_list item in resModel.data.lists){
          Music music = new Music(
            name: item.SongName.replaceAll('<em>', '').replaceAll('</em>', ''),
            playUrl:"",
            coverUrl: "",
            singer:item.SingerName,
            duration:item.Duration,
            albumName:item.AlbumName
          );
          result.add(music);
        }
      });
      return result;
    } catch (e) {
      print(e);
    }
  }
}
