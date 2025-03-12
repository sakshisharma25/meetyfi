class EmployeeProfileModel {
  final int id;
  final String email;
  final String name;
  final String role;
  final String department;
  final String? phone;
  final String? profilePicture;
  final bool isVerified;
  final String createdAt;
  final ManagerInfo manager;

  EmployeeProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.department,
    this.phone,
    this.profilePicture,
    required this.isVerified,
    required this.createdAt,
    required this.manager,
  });

  factory EmployeeProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      department: json['department'],
      phone: json['phone'],
      profilePicture: json['profile_picture'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      manager: ManagerInfo.fromJson(json['manager']),
    );
  }
}

class ManagerInfo {
  final int id;
  final String name;
  final String email;
  final String companyName;
  final String phone;
  final String profilePicture;

  ManagerInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.companyName,
    required this.phone,
    required this.profilePicture,
  });

  factory ManagerInfo.fromJson(Map<String, dynamic> json) {
    return ManagerInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      companyName: json['company_name'],
      phone: json['phone'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
    );
  }
}

class ProfileUpdateRequest {
  final String name;
  final String? phone;
  final String? profilePicture;

  ProfileUpdateRequest({
    required this.name,
    this.phone,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (profilePicture != null) data['profile_picture'] = profilePicture;
    return data;
  }
}