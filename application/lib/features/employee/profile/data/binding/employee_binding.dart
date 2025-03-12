import 'package:get/get.dart';
import 'package:Meetyfi/features/employee/profile/data/repo/employee_profile_repo.dart';
import 'package:Meetyfi/features/employee/profile/presentation/controller/employee_profile_controller.dart';

class EmployeeProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Register the repository
    Get.lazyPut<EmployeeProfileRepository>(() => EmployeeProfileRepository());
    
    // Register the controller with its dependency (repository)
    Get.lazyPut<EmployeeProfileController>(
      () => EmployeeProfileController(repository: Get.find()),
    );
  }
}