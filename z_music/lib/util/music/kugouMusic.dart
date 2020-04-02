import 'dart:html';
import 'package:z_music/Model/Api.dart';
import 'package:z_music/Model/Music.dart';
import 'package:z_music/util/util.dart';



class KugouMusic{

  static String requestCallback = "";

  KugouMusic(){ 
    if(requestCallback == "") requestCallback = "jQuery112409513165674145783_"+Util.currentTimeMillis().toString();
  }
  List<SearchMusic> searchLits(String key,int page,int pageSize){
    List<SearchMusic> result;
    String apiUrl = ApiList.kugou_searchList;
    
    return result;
  }
}