import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/employee/auth/join/presentation/controller/joining_controller.dart';

class EmployeeJoinScreen extends StatelessWidget {
  final EmployeeJoinController controller = Get.find<EmployeeJoinController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                children: [
                  SizedBox(height: 16),
                  _buildBackButton(),
                  SizedBox(height: isSmallScreen ? size.height * 0.03 : size.height * 0.05),
                  _buildHeader(),
                  SizedBox(height: isSmallScreen ? size.height * 0.04 : size.height * 0.06),
                  _buildJoinForm(context),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        iconSize: 22,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join Your Team',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Set up your account to get started',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildJoinForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final spacing = isSmallScreen ? 16.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVerificationTokenField(),
        SizedBox(height: spacing),
        _buildPasswordField(),
        SizedBox(height: spacing),
        _buildConfirmPasswordField(),
        SizedBox(height: spacing * 1.5),
        _buildVerifyButton(),
        SizedBox(height: spacing),
        _buildLoginLink(),
      ],
    );
  }

  Widget _buildVerificationTokenField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Key',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: controller.verificationToken.value,
          onChanged: controller.setVerificationToken,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your verification key';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your verification key',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            errorStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.black),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Obx(() => TextFormField(
          onChanged: controller.setPassword,
          obscureText: controller.obscurePassword.value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please create a password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Create a password',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            errorStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.black),
          textInputAction: TextInputAction.next,
        )),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Obx(() => TextFormField(
          onChanged: controller.setConfirmPassword,
          obscureText: controller.obscureConfirmPassword.value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            } else if (value != controller.password.value) {
              return 'Passwords do not match';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscureConfirmPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            errorStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.black),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            if (_formKey.currentState!.validate()) {
              controller.verifyAccount();
            }
          },
        )),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return Obx(() => CommonButton(
      text: 'Verify Account',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          controller.verifyAccount();
        }
      },
      isLoading: controller.isLoading.value,
    ));
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () => Get.offAllNamed('/employee-login'),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
            children: [
              TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Login',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}