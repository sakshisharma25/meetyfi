import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/employee/auth/login/data/model/employee_login_model.dart';

class EmployeeLoginRepository {
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<Map<String, dynamic>> loginEmployee(EmployeeLoginRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final loginResponse = EmployeeLoginResponseModel.fromJson(data);
        
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

  Future<void> _saveUserData(EmployeeLoginResponseModel response) async {
    // Save token with timestamp for expiration check
    final now = DateTime.now().millisecondsSinceEpoch;
    await _secureStorage.writeAccessToken(response.accessToken);
    await _secureStorage.writeTokenTimestamp(now);
    
    // Save user data
    await _secureStorage.writeUserId(response.userData.id);
    await _secureStorage.writeUserEmail(response.userData.email);
    await _secureStorage.writeUserName(response.userData.name);
    await _secureStorage.writeUserType(response.userData.userType);
    await _secureStorage.writeIsVerified(response.userData.isVerified);
    
    if (response.userData.role != null) {
      await _secureStorage.writeRole(response.userData.role!);
    }
    
    if (response.userData.department != null) {
      await _secureStorage.writeDepartment(response.userData.department!);
    }
    
    if (response.userData.managerId != null) {
      await _secureStorage.writeManagerId(response.userData.managerId!);
    }
  }
}