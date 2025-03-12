import 'package:flutter/material.dart';
import 'package:Meetyfi/features/manager/home/data/model/meeting_model_manager.dart';

class ManagerMeetingCard extends StatelessWidget {
  final ManagerMeetingModel meeting;

  const ManagerMeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Text(
                  meeting.clientInfo.name.isNotEmpty 
                      ? meeting.clientInfo.name[0].toUpperCase() 
                      : '?',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.clientInfo.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (meeting.clientInfo.email.isNotEmpty)
                      Text(
                        meeting.clientInfo.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            meeting.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (meeting.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              meeting.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _getLocationIcon(),
                  size: 20,
                  color: Color(0xFF666666),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    meeting.location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: Color(0xFF666666),
                ),
                const SizedBox(width: 8),
                Text(
                  meeting.timeSlot,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          if (meeting.employees.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildEmployeesList(),
          ],
        ],
      ),
    );
  }
  
  IconData _getLocationIcon() {
    final location = meeting.location.toLowerCase();
    if (location.contains('virtual') ||
        location.contains('online') ||
        location.contains('zoom') ||
        location.contains('meet')) {
      return Icons.videocam_outlined;
    } else {
      return Icons.location_city;
    }
  }
  
  Widget _buildEmployeesList() {
    final maxToShow = 3;
    final overflow = meeting.employees.length > maxToShow;
    final displayEmployees = overflow 
        ? meeting.employees.sublist(0, maxToShow) 
        : meeting.employees;
    
    return Row(
      children: [
        Text(
          'Attendees: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        ...displayEmployees.map((employee) => _buildEmployeeChip(employee)),
        if (overflow)
          Container(
            margin: EdgeInsets.only(left: 4),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${meeting.employees.length - maxToShow}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildEmployeeChip(Employee employee) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        employee.name,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}