class EmployeeLoginRequestModel {
  final String email;
  final String password;
  final String userRole = "employee"; // Fixed as employee

  EmployeeLoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'user_type': userRole,
    };
  }
}

class EmployeeLoginResponseModel {
  final String accessToken;
  final UserDataModel userData;

  EmployeeLoginResponseModel({
    required this.accessToken,
    required this.userData,
  });

  factory EmployeeLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployeeLoginResponseModel(
      accessToken: json['access_token'],
      userData: UserDataModel.fromJson(json['user_data']),
    );
  }
}

class UserDataModel {
  final int id;
  final String email;
  final String name;
  final String userType;
  final bool isVerified;
  final String? role;
  final String? department;
  final int? managerId;

  UserDataModel({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    required this.isVerified,
    this.role,
    this.department,
    this.managerId,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      userType: json['user_type'],
      isVerified: json['is_verified'],
      role: json['role'],
      department: json['department'],
      managerId: json['manager_id'],
    );
  }
}