class CacheExceptions implements Exception {
  final int code;
  final String message;
  CacheExceptions(this.code, {this.message = ""});

  @override
  String toString() => message;
}
