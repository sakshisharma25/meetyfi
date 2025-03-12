// lib/features/employee/dashboard/presentation/widgets/duration_selector.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';

class DurationSelectorE extends StatelessWidget {
  final RxInt selectedDuration;
  final List<int> durationOptions;
  final Function(int) onDurationSelected;

  const DurationSelectorE({
    Key? key,
    required this.selectedDuration,
    required this.durationOptions,
    required this.onDurationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: durationOptions.length,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        itemBuilder: (context, index) {
          final duration = durationOptions[index];
          return Obx(() => GestureDetector(
                onTap: () => onDurationSelected(duration),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: selectedDuration.value == duration
                        ? AppColors.primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$duration',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedDuration.value == duration
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        'min',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: selectedDuration.value == duration
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}