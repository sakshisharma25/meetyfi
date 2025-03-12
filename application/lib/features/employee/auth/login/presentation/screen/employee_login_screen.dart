import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/employee/auth/login/presentation/controller/employee_login_controller.dart';

class EmployeeLoginScreen extends StatelessWidget {
  final EmployeeLoginController controller = Get.find<EmployeeLoginController>();
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
                  _buildLoginForm(context),
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
        onPressed: () => Get.toNamed("/selection-screen"),
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
          'Employee Login',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Sign in to access your account',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final spacing = isSmallScreen ? 16.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmailField(),
        SizedBox(height: spacing),
        _buildPasswordField(),
        SizedBox(height: 12),
        _buildForgotPassword(),
        SizedBox(height: spacing * 1.5),
        _buildLoginButton(),
        SizedBox(height: spacing),
        _buildJoinLink(),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          onChanged: controller.setEmail,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!GetUtils.isEmail(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your email',
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
              return 'Please enter your password';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your password',
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
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            if (_formKey.currentState!.validate()) {
              controller.login();
            }
          },
        )),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.toNamed('/employee-forgot-password'),
        style: TextButton.styleFrom(
          minimumSize: Size(0, 36),
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => CommonButton(
      text: 'Login',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          controller.login();
        }
      },
      isLoading: controller.isLoading.value,
    ));
  }

  Widget _buildJoinLink() {
    return Center(
      child: TextButton(
        onPressed: () => Get.toNamed('/employee-join'),
        child: RichText(
          text: TextSpan(
            text: 'New employee? ',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
            children: [
              TextSpan(
                text: 'Verify your account',
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