import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/features/employee/auth/join/data/model/joining_model.dart';

class EmployeeJoinRepository {
  Future<Map<String, dynamic>> verifyEmployee(EmployeeJoinRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.employeeVerifyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Account verified successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}