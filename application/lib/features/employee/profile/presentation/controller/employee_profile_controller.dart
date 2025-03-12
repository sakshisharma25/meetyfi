import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/employee/profile/data/model/employee_profile_model.dart';
import 'package:Meetyfi/features/employee/profile/data/repo/employee_profile_repo.dart';


class EmployeeProfileController extends GetxController {
  final EmployeeProfileRepository repository;
  
  EmployeeProfileController({required this.repository});

  // Observable values
  final Rx<EmployeeProfileModel?> employeeProfile = Rx<EmployeeProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  final RxBool isUpdating = false.obs;
  
  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchEmployeeProfile() async {
    try {
      isLoading.value = true;
      final profile = await repository.getEmployeeProfile();
      employeeProfile.value = profile;
      
      // Initialize form controllers with current values
      nameController.text = profile.name;
      phoneController.text = profile.phone ?? '';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    
    // Reset form controllers to current values when toggling
    if (isEditMode.value && employeeProfile.value != null) {
      nameController.text = employeeProfile.value!.name;
      phoneController.text = employeeProfile.value!.phone ?? '';
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty && !GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    try {
      isUpdating.value = true;
      
      final success = await repository.updateEmployeeProfile(
        nameController.text,
        phoneController.text,
      );
      
      if (success) {
        // Refresh profile data
        await fetchEmployeeProfile();
        
        // Exit edit mode
        isEditMode.value = false;
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> logout() async {
    try {
      final SecureStorageService _storageService = Get.find<SecureStorageService>();
      await _storageService.clearAll();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}