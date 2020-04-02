class Util{
  String stringFormat(String str,List<String> params){
    for(var i = 0;i<params.length;i++){
      str.replaceAll('{'+i.toString()+'}', params[i]);
    }
    return str;
  }

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }
}