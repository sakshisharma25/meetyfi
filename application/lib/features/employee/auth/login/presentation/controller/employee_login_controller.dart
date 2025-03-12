import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/features/employee/auth/login/data/model/employee_login_model.dart';
import 'package:Meetyfi/features/employee/auth/login/data/repo/employee_login_repo.dart';

class EmployeeLoginController extends GetxController {
  final EmployeeLoginRepository _repository = EmployeeLoginRepository();
  
  final email = ''.obs;
  final password = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;
  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final request = EmployeeLoginRequestModel(
        email: email.value,
        password: password.value,
      );

      final result = await _repository.loginEmployee(request);

      if (result['success']) {
        Get.offAllNamed('/employee-dashboard');
        _showSnackbar('Success', 'Login successful');
      } else {
        _showSnackbar('Error', result['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (email.value.isEmpty) {
      _showSnackbar('Error', 'Please enter your email');
      return false;
    }
    if (!GetUtils.isEmail(email.value)) {
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
}