import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/manager/create_meeting/data/model/create_meeting_model.dart';

class CreateMeetingRepository {
  final SecureStorageService _storageService = Get.find<SecureStorageService>();

  Future<CreateMeetingResponse> createMeeting(CreateMeetingRequest request) async {
    try {
      final token = await _storageService.readAccessToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/managers/meetings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()), // Request data as JSON
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateMeetingResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create meeting: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating meeting: ${e.toString()}');
    }
  }
}
