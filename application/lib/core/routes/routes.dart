import 'package:get/get.dart';
import 'package:Meetyfi/core/routes/route_name.dart';
import 'package:Meetyfi/features/employee/auth/join/presentation/screen/employee_join_screen.dart';
import 'package:Meetyfi/features/employee/auth/login/presentation/screen/employee_login_screen.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/screens/employee_dashboard_screen.dart';
import 'package:Meetyfi/features/employee/profile/data/binding/employee_binding.dart';
import 'package:Meetyfi/features/employee/profile/presentation/screen/employee_profile_screen.dart';
import 'package:Meetyfi/features/manager/auth/login/presentation/screens/manager_login_screen.dart';
import 'package:Meetyfi/features/manager/auth/signup/presentation/screens/signup_screen.dart';
import 'package:Meetyfi/features/manager/auth/signup/presentation/widgets/verify_email.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/screens/create_meeting_screen.dart';
import 'package:Meetyfi/features/manager/dashboard/presentation/screens/manager_dashboard_screen.dart';
import 'package:Meetyfi/features/manager/employee_detailed/presentation/screens/employee_detailed_screen.dart';
import 'package:Meetyfi/features/selection_screen/presentation/screen/selection_screen.dart';
import 'package:Meetyfi/features/splash/presentation/screen/splash_screen.dart';

class AppRoutes {
  static const Transition transition = Transition.native;

  static appRoutes() => [
        GetPage(
          name: RouteName.splash,
          page: () => SplashScreen(),
        ),

        GetPage(
          name: RouteName.selectionscreen,
          page: () => SelectionScreen(),
        ),

        GetPage(
          name: RouteName.managerJoin,
          page: () => SignupScreen(),
        ),

        GetPage(
          name: RouteName.employeeJoin,
          page: () => EmployeeJoinScreen(),
        ),

        GetPage(
          name: RouteName.managerLogin,
          page: () => LoginScreen(),
        ),

        GetPage(
          name: RouteName.employeeLogin,
          page: () => EmployeeLoginScreen(),
        ),

        GetPage(
          name: RouteName.employeeDashboard,
          page: () => EmployeeDashboardScreen(),
        ),

        GetPage(
          name: RouteName.managerDashboard,
          page: () => ManagerDashboardScreen(),
        ),

        GetPage(
          name: RouteName.verifyEmail,
          page: () => VerifyEmailScreen(),
        ),

        GetPage(
          name: RouteName.employeeDetails,
          page: () => EmployeeDetailScreen(),
        ),

        GetPage(
          name: RouteName.createMeetingManager,
          page: () => CreateMeetingScreen(),
        ),

        GetPage(
          name: RouteName.employeeProfile,
          page: () => EmployeeProfileScreen(),
          binding: EmployeeProfileBinding(),
        ),


      ];
}
