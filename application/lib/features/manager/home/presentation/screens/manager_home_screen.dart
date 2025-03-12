import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Meetyfi/core/assets/image_assets.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/home/presentation/controller/manager_home_controller.dart';
import 'package:Meetyfi/features/manager/home/presentation/widgets/calender_view.dart';
import 'package:Meetyfi/features/manager/home/presentation/widgets/empty_state.dart';
import 'package:Meetyfi/features/manager/home/presentation/widgets/manager_meeting_card.dart';

class ManagerHomeScreen extends StatelessWidget {
  final ManagerHomeController controller = Get.find<ManagerHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          _buildMeetingsSection(),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors
              .primaryGradient, // Assuming this is defined in AppColors
          shape: BoxShape.circle, // To keep the round shape of the FAB
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to create meeting screen
            Get.toNamed('/manager-create-meeting');
          },
          backgroundColor: Colors
              .transparent, // Set to transparent as the gradient is applied by the Container
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 2, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    ImageAssets.logo,
                    height: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Availability',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Obx(() => Switch(
                                value: controller.isAvailable.value,
                                onChanged: (_) =>
                                    controller.toggleAvailability(),
                                activeColor: Colors.black,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.calendar_today,
                          color: AppColors.primaryColor),
                      onPressed: () {
                        Get.to(
                          () => CalendarView(
                            selectedDate: controller.selectedDate.value,
                            onDateSelected: controller.updateSelectedDate,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingsSection() {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Obx(() => Text(
                      controller
                          .getFormattedDate(controller.selectedDate.value),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Spacer(),
                Obx(() {
                  final meetingsCount = controller
                      .meetingsForSelectedDate(controller.selectedDate.value)
                      .length;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$meetingsCount meetings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (controller.hasError.value) {
                return EmptyState(
                  message: 'Something went wrong\nTap to retry',
                  icon: Icons.error_outline,
                  onRefresh: controller.fetchMeetingsForToday,
                );
              }

              final meetingsForDate = controller
                  .meetingsForSelectedDate(controller.selectedDate.value);

              if (meetingsForDate.isEmpty) {
                return EmptyState(
                  message:
                      'No meetings scheduled for\n${controller.getFormattedDate(controller.selectedDate.value)}',
                  icon: Icons.event_available,
                  onRefresh: controller.fetchMeetingsForToday,
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchMeetingsForToday,
                color: AppColors.primaryColor,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      top: 4, bottom: 80), // Add bottom padding for FAB
                  itemCount: meetingsForDate.length,
                  itemBuilder: (context, index) {
                    return ManagerMeetingCard(
                      meeting: meetingsForDate[index],
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
