class MeetingRequestModel {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final int duration;
  final String location;
  final String status;
  final String rejectionReason;
  final String createdByType;
  final DateTime createdAt;
  final ClientInfo clientInfo;
  final List<Employee> employees;

  MeetingRequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.location,
    required this.status,
    required this.rejectionReason,
    required this.createdByType,
    required this.createdAt,
    required this.clientInfo,
    required this.employees,
  });

  factory MeetingRequestModel.fromJson(Map<String, dynamic> json) {
    return MeetingRequestModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Meeting',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      duration: json['duration'] ?? 0,
      location: json['location'] ?? 'Virtual Meeting',
      status: json['status'] ?? 'pending',
      rejectionReason: json['rejection_reason'] ?? '',
      createdByType: json['created_by_type'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      clientInfo: ClientInfo.fromJson(json['client_info'] ?? {}),
      employees: (json['employees'] as List?)
          ?.map((e) => Employee.fromJson(e))
          .toList() ?? [],
    );
  }

  String get timeSlot {
    final endTime = date.add(Duration(minutes: duration));
    return '${_formatTime(date)} - ${_formatTime(endTime)}';
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${time.minute.toString().padLeft(2, '0')} $period';
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

  factory ClientInfo.fromJson(Map<String, dynamic> json) {
    return ClientInfo(
      name: json['name'] ?? 'Client',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class Employee {
  final int id;
  final String name;
  final String email;
  final String role;
  final String department;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      department: json['department'] ?? '',
    );
  }
}