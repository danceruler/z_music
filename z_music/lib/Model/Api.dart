

import 'package:cookie_jar/cookie_jar.dart';

class ApiList{
  static const kugou_searchList = "https://songsearch.kugou.com/song_search_v2?callback={4}&keyword={0}&page={1}&pagesize={2}&userid=-1&clientver=&platform=WebFilter&tag=em&filter=2&iscorrection=1&privilege_filter=0&_={3}";
  static const kugou_getMusicInfo = "https://wwwapi.kugou.com/yy/index.php?r=play/getdata&callback={0}&hash={1}&album_id={2}&dfid=1aJS0t0U5yRr0qQNef02gPgO&mid=a1d421b9093150b003fbcd4de3ac3b15&platid=4&_={3}";
  static const kugou_mobile_musicinfo = "https://m3ws.kugou.com/api/v1/song/get_song_info?cmd=playInfo&hash={0}&from=mkugou&apiver=2&mid=193ec0b068520872b2803af3a5dd7515&userid=0&platid=4&dfid=1iARnm4XWB5b0rPlMz3n45tj";
  static const kugou_mobile_lyric = "https://m3ws.kugou.com/app/i/krc.php?cmd=100&keyword=&hash={0}&timelength=141000&d=0.46360261656668444";
  static const kugou_mobile_img = "https://mtools.kugou.com/api/v1/singer_header/get_by_hash?hash={0}&size=200&format=jsonp&callback={1}}";

  static const qq_searchlist = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.center&searchid=46898848196070831&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p={0}&n={1}&w={2}&g_tk_new_20200303=126304154&g_tk=126304154&jsonpCallback={3}&loginUin={4}&hostUin=0&format=jsonp&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0";
  static const qq_getMusicInfo = "https://u.y.qq.com/cgi-bin/musicu.fcg?callback={0}&g_tk=1&jsonpCallback={0}&loginUin={1}&hostUin=0&format=jsonp&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0&data={2}";
  static const qq_coverImg = "https://y.gtimg.cn/music/photo_new/T002R300x300M000{0}.jpg?max_age=2592000";
  static const qq_lyric = "https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_yqq.fcg?nobase64=1&musicid={0}&callback={1}&g_tk_new_20200303=5381&g_tk=5381&jsonpCallback={1}&loginUin={2}&hostUin=0&format=jsonp&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0";
}

class Api {  
  static final CookieJar cookieJar = new CookieJar();
}

