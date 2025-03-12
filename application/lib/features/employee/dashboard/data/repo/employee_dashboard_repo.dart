import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/employee/dashboard/data/model/employee_dashboard_model.dart';
import 'package:Meetyfi/features/employee/profile/data/model/employee_profile_model.dart';

class EmployeeDashboardRepository {
  final SecureStorageService _storageService = Get.find<SecureStorageService>();

  // Fetch employee profile to get the name
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

  Future<ManagerAvailability> getManagerAvailability(DateTime date, String time) async {
    try {
      final token = await _storageService.readAccessToken();
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/employees/managers/availability')
          .replace(queryParameters: {
        'date': formattedDate,
        'time': time,
      });
      
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ManagerAvailability.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Failed to get manager availability: ${errorData['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error getting manager availability: ${e.toString()}');
    }
  }

  Future<CreateMeetingResponseEmployee> createMeeting(CreateMeetingRequestEmployee request) async {
    try {
      final token = await _storageService.readAccessToken();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/employees/meetings');
      
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateMeetingResponseEmployee.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        return CreateMeetingResponseEmployee(
          success: false,
          message: errorData['message'] ?? 'Failed to create meeting',
        );
      }
    } catch (e) {
      return CreateMeetingResponseEmployee(
        success: false,
        message: 'Error creating meeting: ${e.toString()}',
      );
    }
  }

  Future<bool> updateLocation() async {
    try {
      // Request location permission
      
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = 'Unknown location';
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address = '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}'
            .replaceAll(RegExp(r'^, |, $'), ''); // Remove leading/trailing commas
      }

      final request = LocationUpdateRequest(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      final token = await _storageService.readAccessToken();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/employees/location');
      
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error updating location: $e');
      return false;
    }
  }
}