import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _cachedToken;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _secureStorage.write(key: 'access_token', value: token);
  }

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    _cachedToken = await _secureStorage.read(key: 'access_token');
    return _cachedToken;
  }

  Future<void> deleteToken() async {
    _cachedToken = null;
    await _secureStorage.delete(key: 'access_token');
  }

  Future<void> clearAll() async {
    _cachedToken = null;
    await _secureStorage.deleteAll();
  }

  // Value
  Future<String?> getValue(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> setValue(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> deleteValue(String key) async {
    await _secureStorage.delete(key: key);
  }
}