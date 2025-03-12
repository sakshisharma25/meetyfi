import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/manager/profile/data/model/manager_profile_model.dart';

class ManagerProfileRepository {
  final SecureStorageService _storageService = Get.find<SecureStorageService>();

  // Method to get manager profile
  Future<ManagerProfileModel> getManagerProfile() async {
    try {
      final token = await _storageService.readAccessToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/managers/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return ManagerProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: ${e.toString()}');
    }
  }

  // Method to update manager profile
  Future<bool> updateManagerProfile(ProfileUpdateRequest request) async {
    try {
      final token = await _storageService.readAccessToken();
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/managers/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final token = await _storageService.readAccessToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/api/upload'),
      )..headers.addAll({
          'Authorization': 'Bearer $token',
        })
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: 'profile_image.jpg',
        ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Assuming the API returns the image URL in the response
        return json.decode(response.body)['url'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error uploading image: ${e.toString()}');
    }
  }
}
