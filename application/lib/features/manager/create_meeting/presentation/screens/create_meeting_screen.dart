import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/controller/create_meeting_controller.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/widgets/client_info_section.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/widgets/date_time_picker.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/widgets/duration_selector.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/widgets/meeting_text_field.dart';

class CreateMeetingScreen extends StatelessWidget {
  final CreateMeetingController controller = Get.find<CreateMeetingController>();

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
                child: _buildForm(context),
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
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Create Meeting',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          // Empty container for symmetry
          Container(width: 36),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Meeting Details'),
                const SizedBox(height: 20),
                
                // Meeting Title
                MeetingTextField(
                  controller: controller.titleController,
                  label: 'Meeting Title',
                  hint: 'Enter meeting title',
                  validator: controller.validateTitle,
                ),
                const SizedBox(height: 16),
                
                // Meeting Description
                MeetingTextField(
                  controller: controller.descriptionController,
                  label: 'Description',
                  hint: 'Enter meeting description',
                  maxLines: 3,
                  validator: controller.validateDescription,
                ),
                const SizedBox(height: 16),
                
                // Meeting Location
                MeetingTextField(
                  controller: controller.locationController,
                  label: 'Location',
                  hint: 'Enter meeting location',
                  validator: controller.validateLocation,
                ),
                const SizedBox(height: 24),
                
                // Date and Time
                _buildSectionTitle('Date & Time'),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: DateTimePicker(
                        label: 'Date',
                        value: controller.formattedDate,
                        icon: Icons.calendar_today,
                        onTap: () => controller.selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DateTimePicker(
                        label: 'Time',
                        value: controller.formattedTime,
                        icon: Icons.access_time,
                        onTap: () => controller.selectTime(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Duration
                _buildSectionTitle('Duration'),
                const SizedBox(height: 16),
                
                DurationSelector(
                  selectedDuration: controller.selectedDuration,
                  durationOptions: controller.durationOptions,
                  onDurationSelected: controller.setDuration,
                ),
                const SizedBox(height: 24),
                
                // Client Information
                _buildSectionTitle('Client Information'),
                const SizedBox(height: 20),
                
                ClientInfoSection(
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
                  text: 'Create Meeting',
                  onPressed: controller.createMeeting,
                  isLoading: controller.isLoading.value,
                  width: double.infinity,
                )),
                const SizedBox(height: 20),
              ],
            ),
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