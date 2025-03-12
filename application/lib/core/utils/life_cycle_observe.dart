// lib/core/services/app_lifecycle_observer.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLifecycleObserver extends GetxService with WidgetsBindingObserver {
  final Rx<AppLifecycleState> appState = AppLifecycleState.resumed.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appState.value = state;
    super.didChangeAppLifecycleState(state);
  }
}