import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/employee/profile/data/model/employee_profile_model.dart';
import 'package:Meetyfi/features/employee/profile/presentation/controller/employee_profile_controller.dart';
import 'package:Meetyfi/features/employee/profile/presentation/widgets/edit_profile_form.dart';
import 'package:Meetyfi/features/employee/profile/presentation/widgets/info_card.dart';
import 'package:Meetyfi/features/employee/profile/presentation/widgets/manager_card.dart';
import 'package:Meetyfi/features/employee/profile/presentation/widgets/profile_header.dart';

class EmployeeProfileScreen extends GetView<EmployeeProfileController> {
  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make status bar transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        final profile = controller.employeeProfile.value;
        if (profile == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load profile',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                CommonButton(
                  text: 'Try Again',
                  onPressed: controller.fetchEmployeeProfile,
                  width: 150,
                ),
              ],
            ),
          );
        }
        
        return _buildProfileContent(profile);
      }),
    );
  }

  Widget _buildProfileContent(EmployeeProfileModel profile) {
    return Column(
      children: [
        // Profile Header
        Obx(() => ProfileHeader(
              name: profile.name,
              email: profile.email,
              profilePicture: profile.profilePicture,
              isVerified: profile.isVerified,
              onEditTap: controller.toggleEditMode,
              isEditMode: controller.isEditMode.value,
            )),
        
        // Profile Content
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (controller.isEditMode.value) {
                  return EditProfileForm(
                    formKey: controller.formKey,
                    nameController: controller.nameController,
                    phoneController: controller.phoneController,
                    validateName: controller.validateName,
                    validatePhone: controller.validatePhone,
                    onSave: controller.updateProfile,
                    isUpdating: controller.isUpdating.value,
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information
                      _buildSectionTitle('Personal Information'),
                      const SizedBox(height: 16),
                      InfoCard(
                        title: 'Role',
                        value: profile.role,
                        icon: Icons.work,
                      ),
                      const SizedBox(height: 12),
                      InfoCard(
                        title: 'Department',
                        value: profile.department,
                        icon: Icons.business,
                      ),
                      const SizedBox(height: 12),
                      InfoCard(
                        title: 'Phone',
                        value: profile.phone ?? 'Not provided',
                        icon: Icons.phone,
                      ),
                      const SizedBox(height: 12),
                      InfoCard(
                        title: 'Joined',
                        value: controller.formatDate(profile.createdAt),
                        icon: Icons.calendar_today,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Manager Information
                      _buildSectionTitle('Manager Information'),
                      const SizedBox(height: 16),
                      ManagerCard(manager: profile.manager),
                      
                      const SizedBox(height: 32),
                      
                      // Logout Button
                      CommonButton(
                        text: 'Logout',
                        onPressed: controller.logout,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}