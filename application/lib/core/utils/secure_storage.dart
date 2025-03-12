import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  // Keys
  static const String accessTokenKey = 'access_token';
  static const String tokenTimestampKey = 'token_timestamp';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userTypeKey = 'user_type';
  static const String isVerifiedKey = 'is_verified';
  static const String _tokenTimestampKey = 'token_timestamp';
  static const String companyNameKey = 'company_name';
  static const String companySizeKey = 'company_size';
  static const String roleKey = 'role';
  static const String departmentKey = 'department';
  static const String managerIdKey = 'manager_id';

  // Write methods
  Future<void> writeAccessToken(String token) async {
    await _storage.write(key: accessTokenKey, value: token);
    // Save the current timestamp when saving the token
    await _storage.write(
      key: tokenTimestampKey, 
      value: DateTime.now().millisecondsSinceEpoch.toString()
    );
  }

  Future<void> writeUserId(int id) async {
    await _storage.write(key: userIdKey, value: id.toString());
  }

  Future<void> writeUserEmail(String email) async {
    await _storage.write(key: userEmailKey, value: email);
  }

  Future<void> writeTokenTimestamp(int timestamp) async {
    await _storage.write(key: _tokenTimestampKey, value: timestamp.toString());
  }

  Future<void> writeUserName(String name) async {
    await _storage.write(key: userNameKey, value: name);
  }

  Future<void> writeUserType(String userType) async {
    await _storage.write(key: userTypeKey, value: userType);
  }

  Future<void> writeIsVerified(bool isVerified) async {
    await _storage.write(key: isVerifiedKey, value: isVerified.toString());
  }

  Future<void> writeCompanyName(String companyName) async {
    await _storage.write(key: companyNameKey, value: companyName);
  }

  Future<void> writeCompanySize(int companySize) async {
    await _storage.write(key: companySizeKey, value: companySize.toString());
  }

  Future<void> writeRole(String? role) async {
    if (role != null) {
      await _storage.write(key: roleKey, value: role);
    }
  }

  Future<void> writeDepartment(String? department) async {
    if (department != null) {
      await _storage.write(key: departmentKey, value: department);
    }
  }

  Future<void> writeManagerId(int? managerId) async {
    if (managerId != null) {
      await _storage.write(key: managerIdKey, value: managerId.toString());
    }
  }

  // Read methods
  Future<String?> readAccessToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  Future<String?> readTokenTimestamp() async {
    return await _storage.read(key: tokenTimestampKey);
  }

  Future<int?> readUserId() async {
    final value = await _storage.read(key: userIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  Future<String?> readUserEmail() async {
    return await _storage.read(key: userEmailKey);
  }

  Future<String?> readUserName() async {
    return await _storage.read(key: userNameKey);
  }

  Future<String?> readUserType() async {
    return await _storage.read(key: userTypeKey);
  }

  Future<bool?> readIsVerified() async {
    final value = await _storage.read(key: isVerifiedKey);
    return value != null ? value.toLowerCase() == 'true' : null;
  }

  Future<String?> readCompanyName() async {
    return await _storage.read(key: companyNameKey);
  }

  Future<int?> readCompanySize() async {
    final value = await _storage.read(key: companySizeKey);
    return value != null ? int.tryParse(value) : null;
  }

  Future<String?> readRole() async {
    return await _storage.read(key: roleKey);
  }

  Future<String?> readDepartment() async {
    return await _storage.read(key: departmentKey);
  }

  Future<int?> readManagerId() async {
    final value = await _storage.read(key: managerIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await readAccessToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    
    // Check token expiration
    final tokenTimestampStr = await readTokenTimestamp();
    if (tokenTimestampStr == null) {
      return false;
    }
    
    final tokenTimestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(tokenTimestampStr));
    final currentTime = DateTime.now();
    final difference = currentTime.difference(tokenTimestamp).inHours;
    
    // Token is valid if less than 20 hours old
    return difference < 20;
  }
}