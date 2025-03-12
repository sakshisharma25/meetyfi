import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/manager/auth/login/data/model/manager_login_model.dart';

class LoginRepository {
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<Map<String, dynamic>> login(LoginRequestModel loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest.toJson()),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(data);
        
        // Save user data to secure storage
        await _saveUserData(loginResponse);
        
        return {
          'success': true,
          'message': 'Login successful',
          'data': loginResponse,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<void> _saveUserData(LoginResponseModel loginResponse) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _secureStorage.writeAccessToken(loginResponse.accessToken);
    await _secureStorage.writeTokenTimestamp(now);
    await _secureStorage.writeUserId(loginResponse.userData.id);
    await _secureStorage.writeUserEmail(loginResponse.userData.email);
    await _secureStorage.writeUserName(loginResponse.userData.name);
    await _secureStorage.writeUserType(loginResponse.userData.userType);
    await _secureStorage.writeIsVerified(loginResponse.userData.isVerified);
    await _secureStorage.writeCompanyName(loginResponse.userData.companyName);
    await _secureStorage.writeCompanySize(loginResponse.userData.companySize);
    await _secureStorage.writeRole(loginResponse.userData.role);
    await _secureStorage.writeDepartment(loginResponse.userData.department);
    await _secureStorage.writeManagerId(loginResponse.userData.managerId);
  }

  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await _secureStorage.isLoggedIn();
  }
}