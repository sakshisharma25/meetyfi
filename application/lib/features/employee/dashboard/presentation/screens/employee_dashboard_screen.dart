import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/controller/employee_dashboard_controller.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/widgets/availability_card.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/widgets/client_info_section.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/widgets/date_time_section.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/widgets/duration_selector.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/widgets/meeting_text_field.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/widgets/welcome_header.dart';

class EmployeeDashboardScreen extends GetView<EmployeeDashboardController> {
  const EmployeeDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make status bar transparent so it takes the gradient color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.light, // Light icons for dark background
    ));
    
    return Scaffold(
      // Set the background color to match the start of your gradient
      backgroundColor: AppColors.greyColor, // This should match the start color of your gradient
      body: SafeArea(
        child: Column(
          children: [
            // Welcome Header
            WelcomeHeader(
              employeeName: controller.employeeName,
              onProfileTap: controller.navigateToProfile,
            ),
            
            // Main Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Schedule a Meeting'),
              const SizedBox(height: 20),
              
              // Date and Time Section
              DateTimeSection(
                formattedDate: controller.formattedDate,
                formattedTime: controller.formattedTime,
                onDateTap: () => controller.selectDate(context),
                onTimeTap: () => controller.selectTime(context),
              ),
              const SizedBox(height: 20),
              
              // Check Availability Button
              Obx(() => CommonButton(
                text: 'Check Manager Availability',
                onPressed: controller.checkManagerAvailability,
                isLoading: controller.isCheckingAvailability.value,
                width: double.infinity,
              )),
              const SizedBox(height: 20),
              
              // Manager Availability Card
              Obx(() => controller.managerAvailability.value != null
                  ? AvailabilityCard(
                      availability: controller.managerAvailability.value!,
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 24),
              
              // Meeting Details
              _buildSectionTitle('Meeting Details'),
              const SizedBox(height: 20),
              
              // Meeting Title
              MeetingTextFieldE(
                controller: controller.titleController,
                label: 'Meeting Title',
                hint: 'Enter meeting title',
                validator: controller.validateTitle,
              ),
              const SizedBox(height: 16),
              
              // Meeting Description
              MeetingTextFieldE(
                controller: controller.descriptionController,
                label: 'Description',
                hint: 'Enter meeting description',
                maxLines: 3,
                validator: controller.validateDescription,
              ),
              const SizedBox(height: 16),
              
              // Meeting Location
              MeetingTextFieldE(
                controller: controller.locationController,
                label: 'Location',
                hint: 'Enter meeting location',
                validator: controller.validateLocation,
              ),
              const SizedBox(height: 24),
              
              // Duration
              _buildSectionTitle('Duration'),
              const SizedBox(height: 16),
              
              DurationSelectorE(
                selectedDuration: controller.selectedDuration,
                durationOptions: controller.durationOptions,
                onDurationSelected: controller.setDuration,
              ),
              const SizedBox(height: 24),
              
              // Client Information
              _buildSectionTitle('Client Information'),
              const SizedBox(height: 20),
              
              ClientInfoSectionE(
                nameController: controller.clientNameController,
                emailController: controller.clientEmailController,
                phoneController: controller.clientPhoneController,
                validateName: controller.validateClientName,
                validateEmail: controller.validateClientEmail,
                validatePhone: controller.validateClientPhone,
              ),
              const SizedBox(height: 40),
              
              // Create Button
              Obx(() => CommonButton(
                text: 'Create Meeting Request',
                onPressed: controller.createMeeting,
                isLoading: controller.isCreatingMeeting.value,
                width: double.infinity,
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }
}