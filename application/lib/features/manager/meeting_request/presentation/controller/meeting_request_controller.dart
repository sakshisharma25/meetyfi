import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/features/manager/meeting_request/data/model/meeting_request_model.dart';
import 'package:Meetyfi/features/manager/meeting_request/data/repo/meeting_request_repo.dart';

class MeetingRequestController extends GetxController with GetSingleTickerProviderStateMixin {
  final MeetingRequestRepository _repository = MeetingRequestRepository();
  
  late TabController tabController;
  
  final RxList<MeetingRequestModel> pendingMeetings = <MeetingRequestModel>[].obs;
  final RxList<MeetingRequestModel> rejectedMeetings = <MeetingRequestModel>[].obs;
  final RxList<MeetingRequestModel> cancelledMeetings = <MeetingRequestModel>[].obs;
  
  final RxBool isPendingLoading = false.obs;
  final RxBool isRejectedLoading = false.obs;
  final RxBool isCancelledLoading = false.obs;
  
  final RxBool isPendingLoadingMore = false.obs;
  final RxBool isRejectedLoadingMore = false.obs;
  final RxBool isCancelledLoadingMore = false.obs;
  
  final RxBool hasPendingError = false.obs;
  final RxBool hasRejectedError = false.obs;
  final RxBool hasCancelledError = false.obs;
  
  final RxInt pendingPage = 1.obs;
  final RxInt rejectedPage = 1.obs;
  final RxInt cancelledPage = 1.obs;
  
  final int limit = 10;
  
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchPendingMeetings(refresh: true);
    
    tabController.addListener(() {
      if (tabController.index == 0 && pendingMeetings.isEmpty) {
        fetchPendingMeetings(refresh: true);
      } else if (tabController.index == 1 && rejectedMeetings.isEmpty) {
        fetchRejectedMeetings(refresh: true);
      } else if (tabController.index == 2 && cancelledMeetings.isEmpty) {
        fetchCancelledMeetings(refresh: true);
      }
    });
  }
  
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
  
  Future<void> fetchPendingMeetings({bool refresh = false}) async {
    if (refresh) {
      pendingPage.value = 1;
      isPendingLoading.value = true;
      hasPendingError.value = false;
    } else {
      isPendingLoadingMore.value = true;
    }
    
    try {
      final meetings = await _repository.getMeetingRequests(
        status: 'pending',
        page: pendingPage.value,
        limit: limit,
      );
      
      if (refresh) {
        pendingMeetings.value = meetings;
      } else {
        pendingMeetings.addAll(meetings);
      }
      
      pendingPage.value++;
    } catch (e) {
      hasPendingError.value = true;
    } finally {
      isPendingLoading.value = false;
      isPendingLoadingMore.value = false;
    }
  }
  
  Future<void> fetchRejectedMeetings({bool refresh = false}) async {
    if (refresh) {
      rejectedPage.value = 1;
      isRejectedLoading.value = true;
      hasRejectedError.value = false;
    } else {
      isRejectedLoadingMore.value = true;
    }
    
    try {
      final meetings = await _repository.getMeetingRequests(
        status: 'rejected',
        page: rejectedPage.value,
        limit: limit,
      );
      
      if (refresh) {
        rejectedMeetings.value = meetings;
      } else {
        rejectedMeetings.addAll(meetings);
      }
      
      rejectedPage.value++;
    } catch (e) {
      hasRejectedError.value = true;
    } finally {
      isRejectedLoading.value = false;
      isRejectedLoadingMore.value = false;
    }
  }
  
  Future<void> fetchCancelledMeetings({bool refresh = false}) async {
    if (refresh) {
      cancelledPage.value = 1;
      isCancelledLoading.value = true;
      hasCancelledError.value = false;
    } else {
      isCancelledLoadingMore.value = true;
    }
    
    try {
      final meetings = await _repository.getMeetingRequests(
        status: 'cancelled',
        page: cancelledPage.value,
        limit: limit,
      );
      
      if (refresh) {
        cancelledMeetings.value = meetings;
      } else {
        cancelledMeetings.addAll(meetings);
      }
      
      cancelledPage.value++;
    } catch (e) {
      hasCancelledError.value = true;
    } finally {
      isCancelledLoading.value = false;
      isCancelledLoadingMore.value = false;
    }
  }
  
  Future<void> acceptMeeting(int meetingId) async {
    try {
      final success = await _repository.updateMeetingStatus(
        meetingId: meetingId,
        status: 'accepted',
      );
      
      if (success) {
        pendingMeetings.removeWhere((meeting) => meeting.id == meetingId);
        Get.snackbar(
          'Success',
          'Meeting accepted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to accept meeting',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> rejectMeeting(int meetingId, String reason) async {
    try {
      final success = await _repository.updateMeetingStatus(
        meetingId: meetingId,
        status: 'rejected',
        reason: reason,
      );
      
      if (success) {
        pendingMeetings.removeWhere((meeting) => meeting.id == meetingId);
        Get.snackbar(
          'Success',
          'Meeting rejected successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject meeting',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  void showRejectDialog(int meetingId) {
    final TextEditingController reasonController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text('Reject Meeting'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please provide a reason for rejection:'),
            SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: 'Reason for rejection',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Get.back();
                rejectMeeting(meetingId, reasonController.text.trim());
              } else {
                Get.snackbar(
                  'Error',
                  'Please provide a reason for rejection',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Reject'),
          ),
        ],
      ),
    );
  }
}