import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Meetyfi/core/utils/life_cycle_observe.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/employee/dashboard/data/model/employee_dashboard_model.dart';
import 'package:Meetyfi/features/employee/dashboard/data/repo/employee_dashboard_repo.dart';
import 'dart:async';

class EmployeeDashboardController extends GetxController {
  final EmployeeDashboardRepository repository;
  final SecureStorageService _storageService = Get.find<SecureStorageService>();
  final AppLifecycleObserver _lifecycleObserver = Get.find<AppLifecycleObserver>();
  
  EmployeeDashboardController({required this.repository});

  // User information
  final RxString employeeName = ''.obs;
  
  // Meeting form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final clientNameController = TextEditingController();
  final clientEmailController = TextEditingController();
  final clientPhoneController = TextEditingController();
  
  // Form key
  final formKey = GlobalKey<FormState>();
  
  // Observable values
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  final RxInt selectedDuration = 30.obs;
  final RxBool isLoading = false.obs;
  final RxBool isCheckingAvailability = false.obs;
  final RxBool isCreatingMeeting = false.obs;
  final Rx<ManagerAvailability?> managerAvailability = Rx<ManagerAvailability?>(null);
  
  // Duration options
  final List<int> durationOptions = [15, 30, 45, 60, 90, 120];
  
  // Location tracking timer
  Timer? _locationTimer;
  final RxBool _isLocationTrackingActive = false.obs;
  Worker? _lifecycleWorker;

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeProfile();
    startLocationTracking();
    
    // Listen to app lifecycle changes
    _lifecycleWorker = ever<AppLifecycleState>(
      _lifecycleObserver.appState,
      (state) {
        if (state == AppLifecycleState.resumed) {
          // App came to foreground
          updateLocation();
          startLocationTracking();
        } else if (state == AppLifecycleState.paused) {
          // App went to background
          stopLocationTracking();
        }
      },
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    clientNameController.dispose();
    clientEmailController.dispose();
    clientPhoneController.dispose();
    stopLocationTracking();
    _lifecycleWorker?.dispose();
    super.onClose();
  }

  Future<void> fetchEmployeeProfile() async {
    try {
      isLoading.value = true;
      final profile = await repository.getEmployeeProfile();
      employeeName.value = profile.name;
    } catch (e) {
      print('Error fetching employee profile: $e');
      // Fallback to stored name if API fails
      final storedName = await _storageService.readUserName();
      if (storedName != null && storedName.isNotEmpty) {
        employeeName.value = storedName;
      } else {
        employeeName.value = 'Employee';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void startLocationTracking() {
    if (_isLocationTrackingActive.value) return;
    
    // Update location immediately
    updateLocation();
    
    // Set up timer for periodic updates
    _locationTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      final now = DateTime.now();
      final hour = now.hour;
      
      // Only update between 9am and 6pm
      if (hour >= 9 && hour < 18) {
        updateLocation();
      }
    });
    
    _isLocationTrackingActive.value = true;
  }

  void stopLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
    _isLocationTrackingActive.value = false;
  }

  Future<void> updateLocation() async {
    try {
      final success = await repository.updateLocation();
      if (success) {
        print('Location updated successfully');
      } else {
        print('Failed to update location');
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> checkManagerAvailability() async {
    if (selectedDate.value.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      Get.snackbar(
        'Invalid Date',
        'Please select a future date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isCheckingAvailability.value = true;
      final timeString = '${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}';
      
      final availability = await repository.getManagerAvailability(
        selectedDate.value,
        timeString,
      );
      
      managerAvailability.value = availability;
      
      if (availability.availableSlots.isEmpty) {
        Get.snackbar(
          'No Availability',
          'Your manager is not available at the selected time. Please choose another time.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check manager availability: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCheckingAvailability.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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
      // Reset availability when date changes
      managerAvailability.value = null;
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
      // Reset availability when time changes
      managerAvailability.value = null;
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
    
    if (managerAvailability.value == null || managerAvailability.value!.availableSlots.isEmpty) {
      Get.snackbar(
        'Availability Check Required',
        'Please check manager availability before creating a meeting',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isCreatingMeeting.value = true;
      
      // Format the date and time for the API
      final dateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedTime.value.hour,
        selectedTime.value.minute,
      );
      
      final request = CreateMeetingRequestEmployee(
        title: titleController.text,
        description: descriptionController.text,
        proposedDates: [dateTime.toIso8601String()],
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
        // Clear form
        titleController.clear();
        descriptionController.clear();
        locationController.clear();
        clientNameController.clear();
        clientEmailController.clear();
        clientPhoneController.clear();
        
        // Reset availability
        managerAvailability.value = null;
        
        Get.snackbar(
          'Success',
          'Meeting request created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
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
        'Failed to create meeting: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingMeeting.value = false;
    }
  }

  void navigateToProfile() {
    Get.toNamed("/employee-profile");
  }
}