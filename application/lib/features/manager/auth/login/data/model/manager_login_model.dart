import 'package:Meetyfi/core/utils/enums.dart';

class LoginRequestModel {
  final String email;
  final String password;
  final UserType userType;

  LoginRequestModel({
    required this.email,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'user_type': userType.value,
    };
  }
}

class UserDataModel {
  final int id;
  final String email;
  final String name;
  final String userType;
  final bool isVerified;
  final String companyName;
  final int companySize;
  final String? role;
  final String? department;
  final int? managerId;

  UserDataModel({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    required this.isVerified,
    required this.companyName,
    required this.companySize,
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
      companyName: json['company_name'],
      companySize: json['company_size'],
      role: json['role'],
      department: json['department'],
      managerId: json['manager_id'],
    );
  }
}

class LoginResponseModel {
  final String accessToken;
  final UserDataModel userData;

  LoginResponseModel({
    required this.accessToken,
    required this.userData,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'],
      userData: UserDataModel.fromJson(json['user_data']),
    );
  }
}