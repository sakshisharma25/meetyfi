// lib/features/employee/dashboard/data/model/employee_dashboard_models.dart

class ManagerAvailability {
  final int managerId;
  final String managerName;
  final List<AvailabilitySlot> availableSlots;
  final String profilePicture;

  ManagerAvailability({
    required this.managerId,
    required this.managerName,
    required this.availableSlots,
    this.profilePicture = '',
  });

  factory ManagerAvailability.fromJson(Map<String, dynamic> json) {
    return ManagerAvailability(
      managerId: json['manager_id'] ?? 0,
      managerName: json['manager_name'] ?? '',
      availableSlots: (json['available_slots'] as List?)
          ?.map((slot) => AvailabilitySlot.fromJson(slot))
          .toList() ?? [],
      profilePicture: json['profile_picture'] ?? '',
    );
  }
}

class AvailabilitySlot {
  final String date;
  final String startTime;
  final String endTime;

  AvailabilitySlot({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}

class CreateMeetingRequestEmployee {
  final String title;
  final String description;
  final List<String> proposedDates;
  final int duration;
  final String location;
  final ClientInfo clientInfo;

  CreateMeetingRequestEmployee({
    required this.title,
    required this.description,
    required this.proposedDates,
    required this.duration,
    required this.location,
    required this.clientInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'proposed_dates': proposedDates,
      'duration': duration,
      'location': location,
      'client_info': clientInfo.toJson(),
    };
  }
}

class ClientInfo {
  final String name;
  final String email;
  final String phone;

  ClientInfo({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

class LocationUpdateRequest {
  final double latitude;
  final double longitude;
  final String address;

  LocationUpdateRequest({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

class CreateMeetingResponseEmployee {
  final bool success;
  final String message;
  final int? meetingId;

  CreateMeetingResponseEmployee({
    required this.success,
    required this.message,
    this.meetingId,
  });

  factory CreateMeetingResponseEmployee.fromJson(Map<String, dynamic> json) {
    return CreateMeetingResponseEmployee(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      meetingId: json['meeting_id'],
    );
  }
}