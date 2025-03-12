import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/features/employee/auth/join/data/model/joining_model.dart';
import 'package:Meetyfi/features/employee/auth/join/data/repo/joining_repo.dart';

class EmployeeJoinController extends GetxController {
  final EmployeeJoinRepository _repository = EmployeeJoinRepository();
  
  final verificationToken = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  // Get the token from URL if available
  @override
  void onInit() {
    super.onInit();
    // Check if token is passed in the URL
    if (Get.parameters.containsKey('token')) {
      verificationToken.value = Get.parameters['token']!;
    }
  }

  void setVerificationToken(String value) => verificationToken.value = value;
  void setPassword(String value) => password.value = value;
  void setConfirmPassword(String value) => confirmPassword.value = value;
  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> verifyAccount() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final request = EmployeeJoinRequestModel(
        verificationToken: verificationToken.value,
        password: password.value,
      );

      final result = await _repository.verifyEmployee(request);

      if (result['success']) {
        Get.offAllNamed('/employee-login');
        _showSnackbar('Success', 'Your account has been verified successfully. Please log in.');
      } else {
        _showSnackbar('Error', result['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (verificationToken.value.isEmpty) {
      _showSnackbar('Error', 'Please enter the verification key');
      return false;
    }
    if (password.value.isEmpty) {
      _showSnackbar('Error', 'Please enter a password');
      return false;
    }
    if (password.value.length < 8) {
      _showSnackbar('Error', 'Password must be at least 8 characters long');
      return false;
    }
    if (password.value != confirmPassword.value) {
      _showSnackbar('Error', 'Passwords do not match');
      return false;
    }
    return true;
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
}