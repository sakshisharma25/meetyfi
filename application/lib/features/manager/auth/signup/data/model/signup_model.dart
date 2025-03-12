class SignupModel {
  final String email;
  final String password;
  final String name;
  final String companyName;
  final String phone;
  final int companySize;
  final String profilePicture;

  SignupModel({
    required this.email,
    required this.password,
    required this.name,
    required this.companyName,
    required this.phone,
    required this.companySize,
    this.profilePicture = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'company_name': companyName,
      'company_size': companySize,
      'phone': phone,
      'profile_picture': profilePicture,
    };
  }
}