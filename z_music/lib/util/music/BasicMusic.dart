import 'package:z_music/Model/Music.dart';

class BasicMusic{
  //根据关键字搜索音乐列表数据
  Future<List<Music>> searchLits(String key, int page, int pageSize) async{}
  //获取音乐详细信息
  Future<Music> getMusicInfo(Music music) async{}
}