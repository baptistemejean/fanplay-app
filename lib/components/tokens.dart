import 'dart:ffi';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Tokens {
  static Future<void> saveToken(String key, String token) {
    final storage = FlutterSecureStorage();

    return storage.write(key: key, value: token);
  }

  static Future<String?> getToken(String key) {
    final storage = FlutterSecureStorage();

    return storage.read(key: key);
  }

  static removeTokens() {
    final storage = FlutterSecureStorage();

    storage.delete(key: 'access_token');
    storage.delete(key: 'refresh_token');
  }
}
