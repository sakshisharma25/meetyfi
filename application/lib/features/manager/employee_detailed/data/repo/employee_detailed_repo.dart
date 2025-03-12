import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/manager/employee_detailed/data/model/employee_detailed_model.dart';

class EmployeeDetailRepository {
  final SecureStorageService _storage = SecureStorageService();
  // Fallback method to get token
  Future<String?> _getToken() async {
    try {
      // Try to get from shared preferences as a fallback
      return await _storage.readAccessToken();
    } catch (e) {
      print('Error reading token: $e');
      return null;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  Future<Map<String, dynamic>> getEmployeeDetail(int employeeId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/managers/employees/$employeeId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final employeeDetail = EmployeeDetailModel.fromJson(data);
        return {
          'success': true,
          'data': employeeDetail,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch employee details',
        };
      }
    } catch (e) {
      print('Error fetching employee details: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}