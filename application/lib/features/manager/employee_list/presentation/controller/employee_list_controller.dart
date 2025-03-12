import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/features/manager/employee_list/data/model/employee_list_model.dart';
import 'package:Meetyfi/features/manager/employee_list/data/repo/employee_list_repo.dart';
import 'package:Meetyfi/features/manager/employee_list/presentation/widgets/add_employee.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository _repository = EmployeeRepository();

  final RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  // Form controllers for adding new employee
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    departmentController.dispose();
    super.onClose();
  }

  Future<void> fetchEmployees({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      employees.clear();
    }

    try {
      isLoading.value = true;

      final result = await _repository.getEmployees(
        page: currentPage.value,
        limit: limit,
      );

      if (result['success']) {
        final response = result['data'] as EmployeeListResponse;
        employees.addAll(response.employees);

        // Calculate total pages
        totalPages.value = (response.total / limit).ceil();
      } else {
        _showSnackbar('Error', result['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreEmployees() async {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      currentPage.value++;
      await fetchEmployees();
    }
  }

  Future<void> createEmployee() async {
    if (!_validateInputs()) return;

    try {
      isCreating.value = true;

      final request = CreateEmployeeRequest(
        name: nameController.text,
        email: emailController.text,
        role: roleController.text,
        department: departmentController.text,
      );

      final result = await _repository.createEmployee(request);

      if (result['success']) {
        _showSnackbar('Success', 'Employee added successfully');
        _clearForm();
        Get.back(); // Close the dialog
        fetchEmployees(refresh: true); // Refresh the list
      } else {
        _showSnackbar('Error', result['message']);
      }
    } finally {
      isCreating.value = false;
    }
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty) {
      _showSnackbar('Error', 'Please enter employee name');
      return false;
    }
    if (emailController.text.isEmpty) {
      _showSnackbar('Error', 'Please enter employee email');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      _showSnackbar('Error', 'Please enter a valid email');
      return false;
    }
    if (roleController.text.isEmpty) {
      _showSnackbar('Error', 'Please enter employee role');
      return false;
    }
    if (departmentController.text.isEmpty) {
      _showSnackbar('Error', 'Please enter employee department');
      return false;
    }
    return true;
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    roleController.clear();
    departmentController.clear();
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

  void showAddEmployeeDialog() {
    Get.dialog(
      AddEmployeeDialog(controller: this),
      barrierDismissible: false,
    );
  }

  void navigateToEmployeeDetails(EmployeeModel employee) {
    if (employee.isVerified) {
      Get.toNamed('/employee-details', arguments: {'employeeId': employee.id});
    } else {
      Get.snackbar(
        'Not Verified',
        'This employee has not verified their account yet.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}
