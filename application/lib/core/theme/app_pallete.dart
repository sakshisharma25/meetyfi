import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

  static const Color primaryColor = Color.fromRGBO(0, 0, 0, 1);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A00E0),  // Adjust these colors as needed
      Color(0xFF8E2DE2),
    ],
    stops: [0.0, 10.0],
    tileMode: TileMode.clamp,
  );

  static const Color blueColor = const Color(0xFF6366F1);

  static const Color greenColor = Color.fromRGBO(51, 90, 90, 1);

  static const Color hintTextColor = Color.fromRGBO(0, 0, 0, 0.4);

  static Color iconColor = const Color.fromRGBO(0, 0, 0, 0.31); 

  static Color textColor = const Color.fromRGBO(0, 0, 0, 1);

  static Color whiteColor = const Color.fromRGBO(255, 255, 255, 1);

  static const Color redColor = Color.fromRGBO(227, 59, 37, 1);

  static const Color greyColor = Color.fromRGBO(0, 0, 0, 0.31);

  static const Color borderColor = Color.fromRGBO(0, 0, 0, 0.05);

  static const Color indicator = Color.fromRGBO(255, 239, 198, 1);

  static const Color inputBox = Color.fromRGBO(0, 0, 0, 0.05);


  
}

  