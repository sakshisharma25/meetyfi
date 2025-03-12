import 'package:get/get.dart';
import 'package:Meetyfi/features/manager/employee_detailed/data/model/employee_detailed_model.dart';
import 'package:Meetyfi/features/manager/employee_detailed/data/repo/employee_detailed_repo.dart';
import 'package:url_launcher/url_launcher.dart';


class EmployeeDetailController extends GetxController {
  final EmployeeDetailRepository _repository = EmployeeDetailRepository();
  
  final Rx<EmployeeDetailModel?> employee = Rx<EmployeeDetailModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    final int employeeId = Get.arguments['employeeId'];
    fetchEmployeeDetail(employeeId);
  }
  
  Future<void> fetchEmployeeDetail(int employeeId) async {
    isLoading.value = true;
    error.value = '';
    
    final result = await _repository.getEmployeeDetail(employeeId);
    
    if (result['success']) {
      employee.value = result['data'];
    } else {
      error.value = result['message'];
    }
    
    isLoading.value = false;
  }
  
  Future<void> openGoogleMaps() async {
    if (employee.value?.location == null) return;
    
    final lat = employee.value!.location!.latitude;
    final lng = employee.value!.location!.longitude;
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      error.value = 'Could not open Google Maps';
    }
  }
  
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}