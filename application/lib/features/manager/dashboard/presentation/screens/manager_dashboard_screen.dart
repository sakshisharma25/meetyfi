import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/dashboard/presentation/controller/manager_dashboard_controller.dart';
import 'package:Meetyfi/features/manager/employee_list/presentation/screen/employee_list_screen.dart';
import 'package:Meetyfi/features/manager/home/presentation/screens/manager_home_screen.dart';
import 'package:Meetyfi/features/manager/meeting_request/presentation/screen/meeting_request_screen.dart';
import 'package:Meetyfi/features/manager/profile/presentation/screens/manager_profile_screen.dart';

class ManagerDashboardScreen extends StatelessWidget {
  final ManagerDashboardController controller = Get.put(ManagerDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Obx(() => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            ManagerHomeScreen(),
            ManagerMeetingRequestsScreen(),
            EmployeeListScreen(),
            ManagerProfileScreen()
          ],
        )),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(
            top: BorderSide(
              // Average of 0xFF4A00E0 and 0xFF8E2DE2
              color: Color(0xFF6C16E1),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Obx(() => Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 0),
          child: BottomNavigationBar(
            elevation: 0,
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Color(0xFF4A00E0),
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 22),
                activeIcon: Icon(Icons.home, size: 22),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.document_scanner_outlined, size: 22),
                activeIcon: Icon(Icons.document_scanner, size: 22),
                label: 'Meetings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined, size: 22),
                activeIcon: Icon(Icons.notifications, size: 22),
                label: 'Employee',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 22),
                activeIcon: Icon(Icons.person, size: 22),
                label: 'Profile',
              ),
            ],
          ),
        )),
      ),
      );
  }
}