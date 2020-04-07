class KuGouSearchLitsRes {
  int status;
  KuGouSearchLitsRes_data data;
  int error_code;
  String error_msg;

  KuGouSearchLitsRes(
    {
      this.status,
      this.data,
      this.error_code,
      this.error_msg
    }
  );

  factory KuGouSearchLitsRes.fromJson(Map<String,dynamic> json){
    return KuGouSearchLitsRes(
      status: json["status"],
      data: json["data"] == null?null:KuGouSearchLitsRes_data.fromJson(json["data"]),
      error_code: json["error_code"],
      error_msg: json["error_msg"]
    );
  }

}

class KuGouSearchLitsRes_data {
  int total;
  int page;
  int pagesize;
  List<KuGouSearchLitsRes_data_list> lists;

  KuGouSearchLitsRes_data({this.total, this.page, this.pagesize, this.lists});

  factory KuGouSearchLitsRes_data.fromJson(Map<String, dynamic> json) {
    var tempLists = json["lists"] as List;
    List<KuGouSearchLitsRes_data_list> dataLists =
        tempLists.map((i) => KuGouSearchLitsRes_data_list.fromJson(i)).toList();

    return KuGouSearchLitsRes_data(
        total: json["total"],
        page: json["page"],
        pagesize: json["pagesize"],
        lists: dataLists
    );
  }
}

class KuGouSearchLitsRes_data_list {
  String SongName;
  String FileName;
  String AlbumID;
  String ID;
  String AlbumName;
  int Duration;
  String SingerName;

  String FileHash;
  String SQFileHash;
  String HQFileHash;
  String MvHash;

  KuGouSearchLitsRes_data_list(
      {this.SongName,
      this.FileName,
      this.AlbumID,
      this.ID,
      this.AlbumName,
      this.Duration,
      this.SingerName,
      this.FileHash,
      this.SQFileHash,
      this.HQFileHash,
      this.MvHash});

  factory KuGouSearchLitsRes_data_list.fromJson(Map<String, dynamic> json) {
    return KuGouSearchLitsRes_data_list(
        SongName: json["SongName"],
        FileName: json["FileName"],
        AlbumID: json["AlbumID"],
        ID: json["ID"],
        AlbumName: json["AlbumName"],
        Duration: json["Duration"],
        SingerName: json["SingerName"],
        FileHash: json["FileHash"],
        SQFileHash: json["SQFileHash"],
        HQFileHash: json["HQFileHash"],
        MvHash: json["MvHash"]);
  }
}
