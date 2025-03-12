import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/employee/profile/data/model/employee_profile_model.dart';

class EmployeeProfileRepository {
  final SecureStorageService _storageService = Get.find<SecureStorageService>();

  Future<EmployeeProfileModel> getEmployeeProfile() async {
    try {
      final token = await _storageService.readAccessToken();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/employees/profile');
      
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return EmployeeProfileModel.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Failed to get profile: ${errorData['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error getting profile: ${e.toString()}');
    }
  }

  Future<bool> updateEmployeeProfile(String name, String phone) async {
    try {
      final token = await _storageService.readAccessToken();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/employees/profile');
      
      final body = {
        'name': name,
        'phone': phone,
      };
      
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }
}