import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/manager/home/data/model/meeting_model_manager.dart';

class MeetingRepository {
  final SecureStorageService _storageService = SecureStorageService();
  
  Future<List<ManagerMeetingModel>> getMeetingsForDate(DateTime date) async {
    try {
      final token = await _storageService.readAccessToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/managers/meetings?status=accepted&date_from=$dateStr&date_to=$dateStr&page=1&limit=50'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> meetingsJson = data['meetings'] ?? [];
        return meetingsJson.map((json) => ManagerMeetingModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load meetings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meetings: $e');
    }
  }

  Future<bool> updateAvailability(bool isAvailable) async {
    try {
      final token = await _storageService.readAccessToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/employees/availability'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'is_available': isAvailable,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating availability: $e');
    }
  }
}