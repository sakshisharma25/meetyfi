import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';

class DurationSelector extends StatelessWidget {
  final RxInt selectedDuration;
  final List<int> durationOptions;
  final Function(int) onDurationSelected;

  const DurationSelector({
    Key? key,
    required this.selectedDuration,
    required this.durationOptions,
    required this.onDurationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
      spacing: 10,
      runSpacing: 10,
      children: durationOptions.map((duration) {
        final isSelected = duration == selectedDuration.value;
        return GestureDetector(
          onTap: () => onDurationSelected(duration),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              duration == 60
                  ? '1 hour'
                  : duration > 60
                      ? '${duration ~/ 60} hours'
                      : '$duration min',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}