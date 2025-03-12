import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/manager/meeting_request/data/model/meeting_request_model.dart';

class MeetingRequestRepository {
  final SecureStorageService _storageService = SecureStorageService();
  
  Future<List<MeetingRequestModel>> getMeetingRequests({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _storageService.readAccessToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/managers/meetings?status=$status&page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> meetingsJson = data['meetings'] ?? [];
        return meetingsJson.map((json) => MeetingRequestModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load meeting requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meeting requests: $e');
    }
  }

  Future<bool> updateMeetingStatus({
    required int meetingId,
    required String status,
    String reason = '',
  }) async {
    try {
      final token = await _storageService.readAccessToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/managers/meetings/$meetingId/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'status': status,
          'reason': reason,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating meeting status: $e');
    }
  }
}