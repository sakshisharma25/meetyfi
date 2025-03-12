import 'package:flutter/material.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRefresh;

  const EmptyState({
    Key? key,
    required this.message,
    this.icon = Icons.event_busy,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRefresh != null) ...[
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient:
                      AppColors.primaryGradient, // Apply the gradient here
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
