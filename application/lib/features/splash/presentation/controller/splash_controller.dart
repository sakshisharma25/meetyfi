import 'package:get/get.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';

class SplashController extends GetxController {
  final SecureStorageService _secureStorage = SecureStorageService();

  @override
  void onInit() {
    super.onInit();
    startSplashTimer();
  }

  void startSplashTimer() async {
    try {
      // Show splash screen for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      
      // Check if user is logged in and token is valid
      final bool isAuthenticated = await _checkAuthentication();
      
      if (isAuthenticated) {
        // Get user type and navigate accordingly
        final userType = await _secureStorage.readUserType();
        
        if (userType == 'manager') {
          Get.offAllNamed('/manager-dashboard');
        } else if (userType == 'employee') {
          Get.offAllNamed('/employee-dashboard');
        } else {
          // Fallback if user type is not recognized
          Get.offAllNamed('/selection-screen');
        }
      } else {
        // Not authenticated, go to selection screen
        Get.offAllNamed('/selection-screen');
      }
    } catch (e) {
      print('Error in startSplashTimer: $e');
      Get.offAllNamed('/selection-screen');
    }
  }

  Future<bool> _checkAuthentication() async {
    try {
      // Get the access token from secure storage
      final token = await _secureStorage.readAccessToken();
      
      // If no token exists, user is not authenticated
      if (token == null || token.isEmpty) {
        return false;
      }
      
      // Get the token save timestamp
      final tokenTimestampStr = await _secureStorage.readTokenTimestamp();
      if (tokenTimestampStr == null) {
        // No timestamp found, consider token invalid
        await _secureStorage.clearAll();
        return false;
      }
      
      // Parse the timestamp
      final tokenTimestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(tokenTimestampStr));
      final currentTime = DateTime.now();
      
      // Calculate the difference in hours
      final difference = currentTime.difference(tokenTimestamp).inHours;
      
      // Check if token is older than 20 hours
      if (difference >= 20) {
        // Token expired, clear storage and return false
        await _secureStorage.clearAll();
        return false;
      }
      
      // Token exists and is valid
      return true;
    } catch (e) {
      print('Error checking authentication: $e');
      // On error, assume not authenticated
      return false;
    }
  }
}