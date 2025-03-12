import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/features/manager/auth/signup/data/model/signup_model.dart';
import 'package:Meetyfi/features/manager/auth/signup/data/repo/signup_repo_m.dart';

class SignupController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final name = ''.obs;
  final companyName = ''.obs;
  final phone = ''.obs;
  final companySize = 0.obs;
  final otp = ''.obs;
  
  final RxBool isLoading = false.obs;
  final RxBool isEmailSent = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;
  void setConfirmPassword(String value) => confirmPassword.value = value;
  void setName(String value) => name.value = value;
  void setCompanyName(String value) => companyName.value = value;
  void setPhone(String value) => phone.value = value;
  void setCompanySize(int value) => companySize.value = value;
  void setOtp(String value) => otp.value = value;
  
  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> signup() async {
    if (!_validateSignupInputs()) return;

    try {
      isLoading.value = true;

      final signupModel = SignupModel(
        email: email.value,
        password: password.value,
        name: name.value,
        companyName: companyName.value,
        phone: phone.value,
        companySize: companySize.value,
      );

      final result = await SignupRepository.signup(signupModel);

      if (result['success']) {
        isEmailSent.value = true;
        Get.toNamed('/verify-email');
      } else {
        _showSnackbar('Error', result['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyEmail() async {
    if (!_validateOtp()) return;

    try {
      isLoading.value = true;

      final result = await SignupRepository.verifyEmail(email.value, otp.value);

      if (result['success']) {
        _showApprovalDialog();
      } else {
        _showSnackbar('Error', result['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showApprovalDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Registration Successful'),
        content: Text('Your account has been registered. You will receive an email once your account is approved by the admin.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.offAllNamed('/login');
            },
            child: Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  bool _validateSignupInputs() {
    if (email.value.isEmpty || !GetUtils.isEmail(email.value)) {
      _showSnackbar('Error', 'Please enter a valid email');
      return false;
    }
    if (password.value.isEmpty || password.value.length < 6) {
      _showSnackbar('Error', 'Password must be at least 6 characters');
      return false;
    }
    if (password.value != confirmPassword.value) {
      _showSnackbar('Error', 'Passwords do not match');
      return false;
    }
    if (name.value.isEmpty) {
      _showSnackbar('Error', 'Please enter your name');
      return false;
    }
    if (companyName.value.isEmpty) {
      _showSnackbar('Error', 'Please enter company name');
      return false;
    }
    if (phone.value.isEmpty) {
      _showSnackbar('Error', 'Please enter phone number');
      return false;
    }
    if (companySize.value <= 0) {
      _showSnackbar('Error', 'Please enter a valid company size');
      return false;
    }
    return true;
  }

  bool _validateOtp() {
    if (otp.value.isEmpty || otp.value.length != 6) {
      _showSnackbar('Error', 'Please enter valid 6-digit OTP');
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