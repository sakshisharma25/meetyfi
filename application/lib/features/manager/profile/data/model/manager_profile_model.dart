class ManagerProfileModel {
  final int id;
  final String email;
  final String name;
  final String companyName;
  final int companySize;
  final bool isVerified;
  final bool isApproved;
  final String phone;
  final String profilePicture;
  final DateTime createdAt;

  ManagerProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.companyName,
    required this.companySize,
    required this.isVerified,
    required this.isApproved,
    required this.phone,
    required this.profilePicture,
    required this.createdAt,
  });

  factory ManagerProfileModel.fromJson(Map<String, dynamic> json) {
    return ManagerProfileModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      companyName: json['company_name'] ?? '',
      companySize: json['company_size'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isApproved: json['is_approved'] ?? false,
      phone: json['phone'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'company_name': companyName,
      'company_size': companySize,
      'is_verified': isVerified,
      'is_approved': isApproved,
      'phone': phone,
      'profile_picture': profilePicture,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ProfileUpdateRequest {
  final String name;
  final String phone;
  final String? profilePicture;

  ProfileUpdateRequest({
    required this.name,
    required this.phone,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      if (profilePicture != null) 'profile_picture': profilePicture,
    };
  }
}