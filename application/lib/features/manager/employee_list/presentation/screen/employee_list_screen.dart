import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/employee_list/presentation/controller/employee_list_controller.dart';
import 'package:Meetyfi/features/manager/employee_list/presentation/widgets/employee_card.dart';

class EmployeeListScreen extends StatelessWidget {
  final EmployeeController controller = Get.find<EmployeeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors
              .primaryGradient, // Assuming this is defined in AppColors
          shape: BoxShape.circle, // To keep the round shape of the FAB
        ),
        child: FloatingActionButton(
          onPressed: controller.showAddEmployeeDialog,
          backgroundColor: Colors
              .transparent, // Set to transparent as the gradient is applied by the Container
          elevation: 4,
          child: const Icon(Icons.person_add, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildEmployeeList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Center(
        child: Text(
          'Employees',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Obx(() {
        if (controller.isLoading.value && controller.employees.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.employees.isEmpty) {
          return _buildEmptyState();
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.loadMoreEmployees();
              return true;
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () => controller.fetchEmployees(refresh: true),
            color: AppColors.blueColor,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.employees.length +
                  (controller.isLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.employees.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.blueColor),
                      ),
                    ),
                  );
                }

                final employee = controller.employees[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: EmployeeCard(
                    employee: employee,
                    onTap: () => controller.navigateToEmployeeDetails(employee),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchEmployees(refresh: true),
      color: AppColors.blueColor,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: Get.height * 0.6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.group_add_outlined,
                        size: 72,
                        color: AppColors.blueColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Your team is empty',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pull down to refresh or add employees using the + button',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.blueColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
