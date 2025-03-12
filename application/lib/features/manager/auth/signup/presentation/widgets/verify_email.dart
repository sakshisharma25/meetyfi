import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/common/common_button.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/auth/signup/presentation/controller/signup_controller.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final SignupController controller = Get.find();
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> textControllers = 
      List.generate(6, (index) => TextEditingController());
  
  final _formKey = GlobalKey<FormState>();
  bool _canResend = true;
  int _resendCountdown = 30;
  
  @override
  void initState() {
    super.initState();
    // Auto-focus the first field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodes[0]);
    });
  }
  
  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 30;
    });
    
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        
        if (_resendCountdown > 0) {
          _startResendTimer();
        } else {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }

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
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: isSmallScreen ? 20 : 40),
                            _buildIcon(),
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            _buildTitle(),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            _buildInstructions(),
                            SizedBox(height: isSmallScreen ? 24 : 32),
                            _buildOtpInputs(context),
                            SizedBox(height: isSmallScreen ? 24 : 32),
                            _buildVerifyButton(),
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            _buildResendButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.email_outlined,
        size: 60,
        color: AppColors.backgroundColor,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Verify Email',
      style: GoogleFonts.sora(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.backgroundColor,
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: [
        Text(
          'Please enter the 6-digit code sent to',
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(
            fontSize: 16,
            color: AppColors.backgroundColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          controller.email.value,
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputs(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final boxSize = size.width < 360 ? 40.0 : 45.0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (index) => Container(
          width: boxSize,
          height: boxSize + 5,
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: TextFormField(
            controller: textControllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorStyle: TextStyle(height: 0), // Hide error text
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              return null;
            },
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                focusNodes[index + 1].requestFocus();
              }
              
              // Check if all fields are filled
              if (textControllers.every((controller) => controller.text.isNotEmpty)) {
                String otp = textControllers.map((controller) => controller.text).join();
                controller.setOtp(otp);
                // Hide keyboard when all digits are entered
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(() => CommonButton(
      text: 'Verify',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          String otp = textControllers.map((controller) => controller.text).join();
          controller.setOtp(otp);
          controller.verifyEmail();
        } else {
          Get.snackbar(
            'Incomplete OTP',
            'Please enter all 6 digits of the verification code',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
          );
        }
      },
      isLoading: controller.isLoading.value,
    ));
  }

  Widget _buildResendButton() {
    return TextButton(
      onPressed: _canResend 
          ? () {
              // Implement resend OTP functionality
              _startResendTimer();
              Get.snackbar(
                'OTP Resent',
                'A new OTP has been sent to your email',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
              );
            }
          : null,
      child: Text(
        _canResend 
            ? 'Didn\'t receive the code? Resend' 
            : 'Resend code in $_resendCountdown seconds',
        style: GoogleFonts.sora(
          color: _canResend 
              ? AppColors.backgroundColor 
              : AppColors.backgroundColor.withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}