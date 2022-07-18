import 'package:http/http.dart' as http;

class HttpException {
  bool success;
  int statusCode;
  dynamic errorMessage;

  HttpException({
    required this.success,
    required this.statusCode,
    required this.errorMessage,
  });

  factory HttpException.fromResponse(http.Response response,
      [dynamic message]) {
    var statusCode = response.statusCode;
    var success = isCodeSuccessful(statusCode);
    var errorMessage = message ?? response.reasonPhrase!;

    return HttpException(
        success: success, statusCode: statusCode, errorMessage: errorMessage);
  }

  static bool isCodeSuccessful(int code) {
    if (code >= 0 && code < 400) {
      return true;
    } else if (code >= 400) {
      return false;
    }

    throw Exception('Unknown status');
  }
}
