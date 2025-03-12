import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController? controller;
  final bool isEditable;
  final bool isEditAllowed; // New property to check if editing is allowed
  final TextInputType keyboardType;
  final IconData? icon;
  final Color? valueColor;
  final int? maxLines;
  final Function()? onTap;
  final Widget? trailing;

  const ProfileField({
    Key? key,
    required this.label,
    this.value,
    this.controller,
    required this.isEditable,
    this.isEditAllowed = true, // Default to true
    this.keyboardType = TextInputType.text,
    this.icon,
    this.valueColor,
    this.maxLines = 1,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            // Show indicator if field is not editable but in edit mode
            if (isEditable && !isEditAllowed) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.lock_outline,
                size: 14,
                color: Colors.grey[500],
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        if (isEditable && isEditAllowed)
          _buildTextField()
        else
          _buildValueContainer(),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        hintText: 'Enter $label',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[400],
          fontSize: 15,
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey[500]) : null,
        suffixIcon: trailing,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildValueContainer() {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                value ?? controller?.text ?? 'Not provided', // Show controller text if value is null
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: value != null || controller?.text != null
                      ? (valueColor ?? Colors.black87) 
                      : Colors.grey[400],
                ),
                maxLines: maxLines,
                overflow: maxLines != null ? TextOverflow.ellipsis : null,
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null && trailing == null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}