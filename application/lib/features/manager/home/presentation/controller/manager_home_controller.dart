import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Meetyfi/features/manager/home/data/model/meeting_model_manager.dart';
import 'package:Meetyfi/features/manager/home/data/repo/manager_home_repo.dart';

class ManagerHomeController extends GetxController {
  final MeetingRepository _repository = MeetingRepository();
  
  final RxBool isAvailable = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ManagerMeetingModel> meetings = <ManagerMeetingModel>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchMeetingsForToday();
  }

  Future<void> fetchMeetingsForToday() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    
    try {
      final todayMeetings = await _repository.getMeetingsForDate(selectedDate.value);
      meetings.value = todayMeetings;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAvailability() async {
    try {
      final newValue = !isAvailable.value;
      final success = await _repository.updateAvailability(newValue);
      if (success) {
        isAvailable.value = newValue;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update availability',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchMeetingsForToday();
  }

  List<ManagerMeetingModel> meetingsForSelectedDate(DateTime date) {
    final selectedDay = DateTime(date.year, date.month, date.day);
    return meetings.where((meeting) {
      final meetingDay = DateTime(meeting.date.year, meeting.date.month, meeting.date.day);
      return meetingDay.isAtSameMomentAs(selectedDay);
    }).toList();
  }

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today, ${DateFormat('d MMM').format(date)}';
    } else if (selectedDay == tomorrow) {
      return 'Tomorrow, ${DateFormat('d MMM').format(date)}';
    } else {
      return DateFormat('EEEE, d MMM').format(date);
    }
  }
}