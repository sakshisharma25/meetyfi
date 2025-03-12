import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/profile/data/model/manager_profile_model.dart';
import 'package:Meetyfi/features/manager/profile/presentation/controller/manager_profile_controller.dart';
import 'package:Meetyfi/features/manager/profile/presentation/widgets/profile_field.dart';

class ManagerProfileScreen extends StatelessWidget {
  final ManagerProfileController controller =
      Get.find<ManagerProfileController>();

  ManagerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildProfileContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Centered title
        Center(
          child: Text(
            'My Profile',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Edit icon positioned at the right
        Positioned(
          right: 0,
          child: Obx(() => IconButton(
                icon: Icon(
                    controller.isEditMode.value ? Icons.check : Icons.edit,
                    color: Colors.white),
                onPressed: () {
                  if (controller.isEditMode.value) {
                    controller.updateProfile();
                  } else {
                    controller.toggleEditMode();
                    // Show alert about editable fields
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Only name and phone number fields are editable',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: Colors.black,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              )),
        ),
      ],
    ),
  );
}

  Widget _buildProfileContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Obx(() {
        if (controller.isLoading.value && controller.profile.value == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Failed to load profile',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.loadProfile(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Profile Avatar
              _buildProfileAvatar(profile),

              // Profile Status Chip
              _buildStatusChip(profile),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Information Section
                    _buildSection(
                      title: 'Company Information',
                      icon: Icons.business,
                      children: [
                        ProfileField(
                          label: 'Company Name',
                          value: profile.companyName,
                          isEditable: controller.isEditMode.value,
                          isEditAllowed: false, // Not editable
                          icon: Icons.apartment,
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          label: 'Company Size',
                          value: '${profile.companySize} employees',
                          isEditable: controller.isEditMode.value,
                          isEditAllowed: false, // Not editable
                          icon: Icons.people,
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          label: 'Email',
                          value: profile.email,
                          isEditable: controller.isEditMode.value,
                          isEditAllowed: false, // Not editable
                          icon: Icons.email,
                        ),
                      ],
                    ),

                    // Personal Information Section
                    _buildSection(
                      title: 'Personal Information',
                      icon: Icons.person,
                      children: [
                        ProfileField(
                          label: 'Full Name',
                          value: profile.name, // Set value for non-edit mode
                          controller: controller.nameController,
                          isEditable: controller.isEditMode.value,
                          isEditAllowed: true, // Editable
                          icon: Icons.badge,
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          label: 'Phone Number',
                          value: profile.phone, // Set value for non-edit mode
                          controller: controller.phoneController,
                          isEditable: controller.isEditMode.value,
                          isEditAllowed: true, // Editable
                          keyboardType: TextInputType.phone,
                          icon: Icons.phone,
                        ),
                      ],
                    ),

                    // Account Information Section
                    _buildSection(
                      title: 'Account Information',
                      icon: Icons.account_circle,
                      children: [
                        ProfileField(
                          label: 'Account Created',
                          value: _formatDate(profile.createdAt),
                          isEditable: controller.isEditMode.value,
                          isEditAllowed: false, // Not editable
                          icon: Icons.calendar_today,
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          label: 'Account Status',
                          value: _getAccountStatus(profile),
                          isEditable: controller.isEditMode.value,
                          isEditAllowed: false, // Not editable
                          icon: Icons.verified_user,
                          valueColor: _getStatusColor(profile),
                        ),
                      ],
                    ),

                    // Update Button (only show in edit mode)
                    Obx(() => controller.isEditMode.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 20),
                            child: CommonButton(
                              text: 'Save Changes',
                              onPressed: () {
                                controller.updateProfile();
                                controller
                                    .toggleEditMode(); // Exit edit mode after saving
                              },
                              isLoading: controller.isUpdating.value,
                              width: double.infinity,
                            ),
                          )
                        : const SizedBox()),

                    // Logout Button
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextButton.icon(
                          onPressed: () => _showLogoutConfirmation(),
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileAvatar(ManagerProfileModel profile) {
    final initials = profile.companyName.isNotEmpty
        ? profile.companyName[0].toUpperCase()
        : 'M';

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
        child: Text(
          initials,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ManagerProfileModel profile) {
    return Chip(
      label: Text(
        _getAccountStatus(profile),
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      backgroundColor: _getStatusColor(profile),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  Widget _buildSection(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getAccountStatus(ManagerProfileModel profile) {
    if (!profile.isVerified) {
      return 'Email not verified';
    } else if (!profile.isApproved) {
      return 'Pending approval';
    } else {
      return 'Active';
    }
  }

  Color _getStatusColor(ManagerProfileModel profile) {
    if (!profile.isVerified) {
      return Colors.orange;
    } else if (!profile.isApproved) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout from your account?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}
