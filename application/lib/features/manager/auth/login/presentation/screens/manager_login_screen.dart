import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/auth/login/presentation/controller/manager_login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      body: Container(
        height: double.infinity,
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
                  SizedBox(height: isSmallScreen ? size.height * 0.03 : size.height * 0.06),
                  _buildLogo(),
                  SizedBox(height: isSmallScreen ? size.height * 0.03 : size.height * 0.05),
                  _buildWelcomeText(),
                  SizedBox(height: isSmallScreen ? size.height * 0.03 : size.height * 0.05),
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
        icon: Icon(Icons.arrow_back_ios, color: AppColors.backgroundColor),
        onPressed: () => Get.toNamed("/selection-screen"),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        iconSize: 22,
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/images/logo.png',
          height: 70,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: GoogleFonts.sora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.backgroundColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: GoogleFonts.sora(
            fontSize: 16,
            color: AppColors.backgroundColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
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
              return 'Please enter your password';
            }
            return null;
          },
        ),
        SizedBox(height: 4),
        _buildForgotPassword(),
        SizedBox(height: size.height * 0.03),
        _buildLoginButton(),
        SizedBox(height: spacing),
        _buildSignUpLink(),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText.value ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleVisibility,
            ),
            errorStyle: TextStyle(color: Colors.white),
          ),
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
        onPressed: () => Get.toNamed('/forgot-password'),
        style: TextButton.styleFrom(
          minimumSize: Size(0, 36),
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.sora(
            color: AppColors.backgroundColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
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

  Widget _buildSignUpLink() {
    return Center(
      child: TextButton(
        onPressed: () => Get.toNamed('/manager-join'),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.sora(
              color: AppColors.backgroundColor,
              fontSize: 16,
            ),
            children: [
              TextSpan(text: 'Don\'t have an account? '),
              TextSpan(
                text: 'Sign Up',
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
    );
  }
}