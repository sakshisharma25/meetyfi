import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Meetyfi/core/constants/api_constants.dart';
import 'package:Meetyfi/features/manager/auth/signup/data/model/signup_model.dart';

class SignupRepository {
  static Future<Map<String, dynamic>> signup(SignupModel signup) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signup.toJson()),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Verification email sent',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'An error occurred during signup',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyEmail(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Email verified successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Invalid OTP',
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