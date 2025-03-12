class EmployeeJoinRequestModel {
  final String verificationToken;
  final String password;

  EmployeeJoinRequestModel({
    required this.verificationToken,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'verification_token': verificationToken,
      'password': password,
    };
  }
}

class EmployeeJoinResponseModel {
  final bool success;
  final String message;

  EmployeeJoinResponseModel({
    required this.success,
    required this.message,
  });

  factory EmployeeJoinResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployeeJoinResponseModel(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Account verified successfully',
    );
  }
}