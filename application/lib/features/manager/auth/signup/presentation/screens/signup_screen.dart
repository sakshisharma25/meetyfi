// SignupScreen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/auth/signup/presentation/controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: size.height * 0.02),
                  _buildHeader(),
                  SizedBox(height: isSmallScreen ? 10 : 20),
                  _buildSignupForm(context),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.backgroundColor),
          onPressed: () => Get.toNamed("/manager-login"),
        ),
        Text(
          'Create Account',
          style: GoogleFonts.sora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final spacing = isSmallScreen ? 12.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          'Email',
          'Enter your email',
          controller.setEmail,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!GetUtils.isEmail(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: spacing),
        _buildPasswordField(
          'Password',
          'Enter your password',
          controller.setPassword,
          controller.obscurePassword,
          controller.togglePasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: spacing),
        _buildPasswordField(
          'Confirm Password',
          'Confirm your password',
          controller.setConfirmPassword,
          controller.obscureConfirmPassword,
          controller.toggleConfirmPasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            } else if (value != controller.password.value) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        SizedBox(height: spacing),
        _buildInputField(
          'Name',
          'Enter your name',
          controller.setName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        SizedBox(height: spacing),
        _buildInputField(
          'Company Name',
          'Enter company name',
          controller.setCompanyName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter company name';
            }
            return null;
          },
        ),
        SizedBox(height: spacing),
        _buildInputField(
          'Phone',
          'Enter phone number',
          controller.setPhone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
        ),
        SizedBox(height: spacing),
        _buildNumberField(
          'Company Size',
          controller.setCompanySize,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter company size';
            }
            return null;
          },
        ),
        SizedBox(height: size.height * 0.03),
        Obx(() => CommonButton(
              text: 'Sign Up',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.signup();
                }
              },
              isLoading: controller.isLoading.value,
            )),
        SizedBox(height: spacing),
        Center(
          child: TextButton(
            onPressed: () => Get.toNamed("/manager-login"),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.sora(
                  color: AppColors.backgroundColor,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Login',
                    style: GoogleFonts.sora(
                      color: AppColors.backgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.sora(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            errorStyle: TextStyle(color: Colors.white),
          ),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    Function(String) onChanged,
    RxBool obscureText,
    Function() toggleVisibility, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.sora(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Obx(() => TextFormField(
              onChanged: onChanged,
              obscureText: obscureText.value,
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: toggleVisibility,
                ),
                errorStyle: TextStyle(color: Colors.white),
              ),
              textInputAction: TextInputAction.next,
            )),
      ],
    );
  }

  Widget _buildNumberField(
    String label,
    Function(int) onChanged, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.sora(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) => onChanged(int.tryParse(value) ?? 0),
          validator: validator,
          decoration: InputDecoration(
            hintText: 'Enter number of employees',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            errorStyle: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
