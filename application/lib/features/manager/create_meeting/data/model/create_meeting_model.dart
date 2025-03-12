class CreateMeetingRequest {
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final int duration;
  final String location;
  final ClientInfo clientInfo;

  CreateMeetingRequest({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.duration,
    required this.location,
    required this.clientInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time,
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

class CreateMeetingResponse {
  final int id;
  final String message;
  final bool success;

  CreateMeetingResponse({
    required this.id,
    required this.message,
    required this.success,
  });

  factory CreateMeetingResponse.fromJson(Map<String, dynamic> json) {
    return CreateMeetingResponse(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}