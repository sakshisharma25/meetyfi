import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/meeting_request/presentation/controller/meeting_request_controller.dart';
import 'package:Meetyfi/features/manager/meeting_request/presentation/widgets/empty_state.dart';
import 'package:Meetyfi/features/manager/meeting_request/presentation/widgets/meeting_request_card.dart';

class ManagerMeetingRequestsScreen extends StatelessWidget {
  final MeetingRequestController controller =
      Get.find<MeetingRequestController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header in gradient section
              _buildHeader(context),

              // Tab bar with custom indicator
              _buildTabBar(),

              // White container with rounded corners
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 20), // Overlap to hide any gap
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        _buildPendingTab(),
                        _buildRejectedTab(),
                        _buildCancelledTab(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Center(
        child: Text(
          'Meeting Requests',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 46, // Increased height for better touch target
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: controller.tabController,
        // Use BoxDecoration for a pill-shaped indicator without underline
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
        ),
        // Add proper padding
        indicatorPadding: const EdgeInsets.all(4),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        // No divider line
        dividerColor: Colors.transparent,
        // Smoother animation
        // Colors
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        // Typography
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        // Make indicator full-width within each tab
        indicatorSize: TabBarIndicatorSize.tab,
        // Add splash effect for better feedback
        splashBorderRadius: BorderRadius.circular(30),
        // Make overlap to prevent jittering
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered))
              return Colors.white.withOpacity(0.1);
            if (states.contains(MaterialState.pressed))
              return Colors.white.withOpacity(0.2);
            return null;
          },
        ),
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Rejected'),
          Tab(text: 'Cancelled'),
        ],
      ),
    ),
  );
}

  Widget _buildPendingTab() {
    return Obx(() {
      if (controller.isPendingLoading.value &&
          controller.pendingMeetings.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.pendingMeetings.isEmpty) {
        return EmptyStateRequest(
          title: 'No Pending Requests',
          message: 'You don\'t have any pending meeting requests at the moment',
          icon: Icons.pending_actions,
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !controller.isPendingLoadingMore.value) {
            controller.fetchPendingMeetings();
            return true;
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => controller.fetchPendingMeetings(refresh: true),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.pendingMeetings.length +
                (controller.isPendingLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.pendingMeetings.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  ),
                );
              }

              final meeting = controller.pendingMeetings[index];
              return MeetingRequestCard(
                meeting: meeting,
                onAccept: () => controller.acceptMeeting(meeting.id),
                onReject: () => controller.showRejectDialog(meeting.id),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildRejectedTab() {
    return Obx(() {
      if (controller.isRejectedLoading.value &&
          controller.rejectedMeetings.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.rejectedMeetings.isEmpty) {
        return EmptyStateRequest(
          title: 'No Rejected Meetings',
          message: 'You don\'t have any rejected meeting requests',
          icon: Icons.cancel_outlined,
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !controller.isRejectedLoadingMore.value) {
            controller.fetchRejectedMeetings();
            return true;
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => controller.fetchRejectedMeetings(refresh: true),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.rejectedMeetings.length +
                (controller.isRejectedLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.rejectedMeetings.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  ),
                );
              }

              final meeting = controller.rejectedMeetings[index];
              return MeetingRequestCard(
                meeting: meeting,
                showActions: false,
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildCancelledTab() {
    return Obx(() {
      if (controller.isCancelledLoading.value &&
          controller.cancelledMeetings.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.cancelledMeetings.isEmpty) {
        return EmptyStateRequest(
          title: 'No Cancelled Meetings',
          message: 'You don\'t have any cancelled meeting requests',
          icon: Icons.event_busy,
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !controller.isCancelledLoadingMore.value) {
            controller.fetchCancelledMeetings();
            return true;
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => controller.fetchCancelledMeetings(refresh: true),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.cancelledMeetings.length +
                (controller.isCancelledLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.cancelledMeetings.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  ),
                );
              }

              final meeting = controller.cancelledMeetings[index];
              return MeetingRequestCard(
                meeting: meeting,
                showActions: false,
              );
            },
          ),
        ),
      );
    });
  }
}
