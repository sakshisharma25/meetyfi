import 'package:get/get.dart';
import 'package:Meetyfi/core/utils/secure_storage.dart';
import 'package:Meetyfi/features/employee/auth/join/presentation/controller/joining_controller.dart';
import 'package:Meetyfi/features/employee/auth/login/presentation/controller/employee_login_controller.dart';
import 'package:Meetyfi/features/employee/dashboard/data/repo/employee_dashboard_repo.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/controller/employee_dashboard_controller.dart';
import 'package:Meetyfi/features/manager/auth/login/presentation/controller/manager_login_controller.dart';
import 'package:Meetyfi/features/manager/create_meeting/data/repo/create_meeting_repo.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/controller/create_meeting_controller.dart';
import 'package:Meetyfi/features/manager/employee_detailed/presentation/controller/employee_detailed_controller.dart';
import 'package:Meetyfi/features/manager/employee_list/presentation/controller/employee_list_controller.dart';
import 'package:Meetyfi/features/manager/home/presentation/controller/manager_home_controller.dart';
import 'package:Meetyfi/features/manager/meeting_request/presentation/controller/meeting_request_controller.dart';
import 'package:Meetyfi/features/manager/profile/data/repo/manager_profile_repo.dart';
import 'package:Meetyfi/features/manager/profile/presentation/controller/manager_profile_controller.dart';
import 'package:Meetyfi/features/splash/presentation/controller/splash_controller.dart';
import 'package:Meetyfi/features/manager/auth/signup/presentation/controller/signup_controller.dart';
// Import other controllers as needed

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put(SecureStorageService(), permanent: true);
    
    // Auth controllers
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<EmployeeJoinController>(() => EmployeeJoinController(), fenix: true);
    Get.lazyPut<EmployeeLoginController>(() => EmployeeLoginController(), fenix: true);
    Get.lazyPut<EmployeeController>(() => EmployeeController(), fenix: true);
    Get.lazyPut<EmployeeDetailController>(() => EmployeeDetailController(), fenix: true);
    Get.lazyPut(() => EmployeeDetailController());
    Get.lazyPut<ManagerHomeController>(() => ManagerHomeController());
    Get.lazyPut<MeetingRequestController>(() => MeetingRequestController());
    
    Get.lazyPut<ManagerProfileRepository>(() => ManagerProfileRepository());
    Get.lazyPut<ManagerProfileController>(() => ManagerProfileController(repository: Get.find<ManagerProfileRepository>()));


    Get.put(CreateMeetingRepository());
    Get.put(CreateMeetingController(repository: Get.find<CreateMeetingRepository>()));
    Get.put(EmployeeDashboardRepository());
    Get.put(EmployeeDashboardController(
      repository: Get.find<EmployeeDashboardRepository>(),
      ));
    
    
    // Other controllers
    // Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    // Add other controllers as needed
  }
}