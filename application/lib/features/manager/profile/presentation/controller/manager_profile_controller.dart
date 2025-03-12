import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/manager/profile/data/model/manager_profile_model.dart';
import 'package:Meetyfi/features/manager/profile/data/repo/manager_profile_repo.dart';

class ManagerProfileController extends GetxController {
  final ManagerProfileRepository repository;
  
  ManagerProfileController({required this.repository});

  final Rx<ManagerProfileModel?> profile = Rx<ManagerProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isImageUploading = false.obs;
  final RxBool isEditMode = false.obs;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final profileData = await repository.getManagerProfile();
      profile.value = profileData;
      
      // Set text controllers with current values
      nameController.text = profileData.name;
      phoneController.text = profileData.phone;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditMode() {
    // If canceling edit mode, reset fields to original values
    if (isEditMode.value) {
      nameController.text = profile.value?.name ?? '';
      phoneController.text = profile.value?.phone ?? '';
      selectedImage.value = null;
    }
    
    isEditMode.toggle();
  }


  Future<void> updateProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar(
        'Incomplete Information',
        'Name and phone number are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
      return;
    }

    try {
      isUpdating.value = true;
      
      String? imageUrl;
      if (selectedImage.value != null) {
        isImageUploading.value = true;
        imageUrl = await repository.uploadProfileImage(selectedImage.value!);
        isImageUploading.value = false;
      }
      
      final request = ProfileUpdateRequest(
        name: nameController.text,
        phone: phoneController.text,
        profilePicture: imageUrl,
      );
      
      final success = await repository.updateManagerProfile(request);
      
      if (success) {
        await fetchProfile();
        // Exit edit mode after successful update
        isEditMode.value = false;
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> loadProfile() async {
    await fetchProfile();
  }

  void logout() async {
    try {
      final SecureStorageService _storageService = Get.find<SecureStorageService>();
      await _storageService.clearAll();
      
      // Show temporary success message before navigation
      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
      
      // Slight delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed("/manager-login");
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
    }
  }
}