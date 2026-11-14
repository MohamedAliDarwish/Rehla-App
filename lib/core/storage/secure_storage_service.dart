import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Private constructor
  SecureStorageService._internal();

  // Singleton instance
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  // Getter to get instance from it when needed
  static SecureStorageService get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyToken = 'auth_token';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyUserEmail = 'auth_user_email';
  static const String _keyUserPhone = 'auth_user_phone';

  // Save Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Get Token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  // Delete Token
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Save User Info
  Future<void> saveUserData({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (name != null) await _storage.write(key: _keyUserName, value: name);
    if (email != null) await _storage.write(key: _keyUserEmail, value: email);
    if (phone != null) await _storage.write(key: _keyUserPhone, value: phone);
  }

  // Get User Info
  Future<Map<String, String?>> getUserData() async {
    final name = await _storage.read(key: _keyUserName);
    final email = await _storage.read(key: _keyUserEmail);
    final phone = await _storage.read(key: _keyUserPhone);
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  // Logout / Clear all auth data
  Future<void> logout() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUserName);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUserPhone);
  }

  // Clear everything from storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
