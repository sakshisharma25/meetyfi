enum UserType {
  manager,
  employee
}

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.manager:
        return 'manager';
      case UserType.employee:
        return 'employee';
    }
  }
}