import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Meetyfi/features/manager/create_meeting/data/model/create_meeting_model.dart';
import 'package:Meetyfi/features/manager/create_meeting/data/repo/create_meeting_repo.dart';

class CreateMeetingController extends GetxController {
  final CreateMeetingRepository repository;
  
  CreateMeetingController({required this.repository});

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final clientNameController = TextEditingController();
  final clientEmailController = TextEditingController();
  final clientPhoneController = TextEditingController();
  
  // Form keys
  final formKey = GlobalKey<FormState>();
  
  // Observable values
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  final RxInt selectedDuration = 30.obs;
  final RxBool isLoading = false.obs;
  
  // Duration options
  final List<int> durationOptions = [15, 30, 45, 60, 90, 120];

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    clientNameController.dispose();
    clientEmailController.dispose();
    clientPhoneController.dispose();
    super.onClose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
    }
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(selectedDate.value);
  }

  String get formattedTime {
    final hour = selectedTime.value.hour.toString().padLeft(2, '0');
    final minute = selectedTime.value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get timeForApi {
    final hour = selectedTime.value.hour.toString().padLeft(2, '0');
    final minute = selectedTime.value.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  void setDuration(int duration) {
    selectedDuration.value = duration;
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a meeting title';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a meeting description';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a meeting location';
    }
    return null;
  }

  String? validateClientName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter client name';
    }
    return null;
  }

  String? validateClientEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter client email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateClientPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter client phone number';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> createMeeting() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    try {
      isLoading.value = true;
      
      final request = CreateMeetingRequest(
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate.value,
        time: timeForApi,
        duration: selectedDuration.value,
        location: locationController.text,
        clientInfo: ClientInfo(
          name: clientNameController.text,
          email: clientEmailController.text,
          phone: clientPhoneController.text,
        ),
      );
      
      final response = await repository.createMeeting(request);
      
      if (response.success) {
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Meeting created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}