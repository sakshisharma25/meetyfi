import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Meetyfi/core/assets/image_assets.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/splash/presentation/controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late SplashController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = SplashController();
    _controller.startSplashTimer(); // Start the timer for splash

    // Initialize animation controller for the logo animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define the scaling animation from 0 to 1
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start the logo animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColors.backgroundColor
            ),
          ),
          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(),
                ),
                // Logo with Scale Animation
                ScaleTransition(
                  scale: _animation,
                  child: Hero(
                    tag: "splash_logo",
                    child: Image.asset(
                      ImageAssets.appLogo,
                      width: 210.w,
                      height: 162.w,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
