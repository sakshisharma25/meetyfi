import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/assets/image_assets.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/selection_screen/presentation/controller/selection_controller.dart';

class SelectionScreen extends StatelessWidget {
  final SelectionController controller = Get.put(SelectionController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    final availableHeight = screenHeight - padding.top - padding.bottom;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: availableHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: availableHeight * 0.15),
                        Image.asset(
                          ImageAssets.logo,
                          height: availableHeight * 0.20,
                          width: availableHeight * 0.32,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'by Eplisio',
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.backgroundColor,
                          ),
                        ),
                        SizedBox(height: availableHeight * 0.24),
                        Text(
                          'Choose how to continue',
                          style: GoogleFonts.sora(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.backgroundColor),
                        ),
                      ],
                    ),
                    SizedBox(height: availableHeight * 0.02),
                    Column(
                      children: [
                        _buildSignInButton(
                          onPressed: controller.signInwAsManager,
                          icon: ImageAssets.personIcon,
                          text: 'CONTINUE AS MANAGER',
                        ),
                        SizedBox(height: 16),
                        _buildSignInButton(
                          onPressed: controller.signInwAsEmployee,
                          icon: ImageAssets.employee,
                          text: 'CONTINUE AS EMPLOYEE',
                        ),
                        SizedBox(height: 20),
                        Text(
                          'By clicking "Continue", you agree to our\nTerms of Service and Privacy Policy',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            color: AppColors.backgroundColor,
                          ),
                        ),
                        SizedBox(height: availableHeight * 0.05),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton({
    required VoidCallback onPressed,
    required String icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 24),
            SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.sora(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}