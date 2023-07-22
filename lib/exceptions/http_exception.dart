class HttpRequestException implements Exception {
  final String errorMessage;
  final int statusCode;

  HttpRequestException({
    required this.errorMessage,
    required this.statusCode,
  });

  @override
  String toString() {
    return errorMessage;
  }
}
