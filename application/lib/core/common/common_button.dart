import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final bool elevated;

  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 46.0,
    this.elevated = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: elevated ? BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppColors.blueColor).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ) : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.blueColor,
          foregroundColor: textColor ?? Colors.white,
          elevation: elevated ? 0 : 0, // No additional elevation since we use custom shadow
          padding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        textColor ?? Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18),
                      SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: GoogleFonts.sora(
                        color: textColor ?? Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // Factory constructor for a secondary/outline button style
  factory CommonButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    Color? borderColor,
    Color? textColor,
    bool isLoading = false,
    IconData? icon,
    double? width,
    double height = 46.0,
  }) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      textColor: textColor ?? AppColors.blueColor,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      elevated: false,
    );
  }

  // Factory constructor for a small button
  factory CommonButton.small({
    required String text,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    bool isLoading = false,
    IconData? icon,
    bool elevated = true,
  }) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      textColor: textColor,
      isLoading: isLoading,
      icon: icon,
      width: null, // Will size to content
      height: 38.0,
      elevated: elevated,
    );
  }
}