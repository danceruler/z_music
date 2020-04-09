class ReqException implements Exception{
  final message;
  ReqException([this.message]);
  String toString() {
    if (message == null) return "ReqException";
    return "ReqException: $message";
  }
}