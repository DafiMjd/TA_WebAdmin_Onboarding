import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AuthSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyToken = 'token';
  static const _keyEmail = 'email';
  static const _keyExpiryDate = 'expiryDate';

  static Future setToken(String token) async =>
      await _storage.write(key: _keyToken, value: token);
  static Future getToken() async => await _storage.read(key: _keyToken);

  static Future setEmail(String email) async =>
      await _storage.write(key: _keyEmail, value: email);
  static Future getEmail() async => await _storage.read(key: _keyEmail);

  static Future setExpiryDate(DateTime date) async {
    final expiryDate = date.toIso8601String();

    await _storage.write(key: _keyExpiryDate, value: expiryDate);
  }

  static Future<DateTime> getExpiryDate() async {
    final expiryDate = await _storage.read(key: _keyExpiryDate);
    return DateTime.parse(expiryDate!);
  }

  static Future deleteAll() async {
    await _storage.deleteAll();
  }
}
