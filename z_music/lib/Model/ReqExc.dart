class ReqException implements Exception{
  final message;
  ReqException([this.message]){
    // print(this.toString());
  }
  String toString() {
    if (message == null) return "ReqException";
    return "ReqException: $message";
  }
}