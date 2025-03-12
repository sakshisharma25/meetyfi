import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/core/utils/enums.dart';
import 'package:Meetyfi/features/manager/auth/login/data/model/manager_login_model.dart';
import 'package:Meetyfi/features/manager/auth/login/data/repo/manager_login_repo.dart';

class LoginController extends GetxController {
  final LoginRepository _loginRepository = LoginRepository();
  
  final email = ''.obs;
  final password = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final Rx<UserType> userType = UserType.manager.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;
  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void setUserType(UserType type) => userType.value = type;

  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final loginRequest = LoginRequestModel(
        email: email.value,
        password: password.value,
        userType: userType.value,
      );

      final result = await _loginRepository.login(loginRequest);

      if (result['success']) {
        Get.offAllNamed('/manager-dashboard');
      } else {
        _showSnackbar('Error', result['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _loginRepository.logout();
    Get.offAllNamed('/manager-login');
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _loginRepository.isLoggedIn();
    if (isLoggedIn) {
      Get.offAllNamed('/manager-dashboard');
    }
  }

  bool _validateInputs() {
    if (email.value.isEmpty || !GetUtils.isEmail(email.value)) {
      _showSnackbar('Error', 'Please enter a valid email');
      return false;
    }
    if (password.value.isEmpty) {
      _showSnackbar('Error', 'Please enter your password');
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

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
}