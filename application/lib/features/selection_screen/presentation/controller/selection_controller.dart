import 'package:get/get.dart';

class SelectionController extends GetxController {

  Future<void> signInwAsManager() async {
    Get.toNamed('/manager-login');
  }

  Future<void> signInwAsEmployee() async {
    Get.toNamed('/employee-login');
  }
}
