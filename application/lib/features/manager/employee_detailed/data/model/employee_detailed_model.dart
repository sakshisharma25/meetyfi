class EmployeeDetailModel {
  final int id;
  final String email;
  final String name;
  final String role;
  final String department;
  final String? phone;
  final String? profilePicture;
  final bool isVerified;
  final String createdAt;
  final LocationModel? location;

  EmployeeDetailModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.department,
    this.phone,
    this.profilePicture,
    required this.isVerified,
    required this.createdAt,
    this.location,
  });

  factory EmployeeDetailModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      department: json['department'],
      phone: json['phone'],
      profilePicture: json['profile_picture'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
    );
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
      timestamp: json['timestamp'],
    );
  }
}