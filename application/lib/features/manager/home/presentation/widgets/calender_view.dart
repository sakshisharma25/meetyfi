import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Meetyfi/core/theme/app_pallete.dart';
import 'package:Meetyfi/features/manager/home/presentation/controller/manager_home_controller.dart';
import 'package:Meetyfi/features/manager/home/presentation/widgets/empty_state.dart';
import 'package:Meetyfi/features/manager/home/presentation/widgets/manager_meeting_card.dart';

class CalendarView extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarView({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  late ManagerHomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ManagerHomeController>();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _selectedDate = widget.selectedDate;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the app bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(380), // Adjusted app bar height for proper space
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient, // Gradient background applied
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 60, bottom: 0),
            child: Column(
              children: [
                // Header with Back Button and Month Selector on the Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          'Calendar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left,
                              color: Colors.white, size: 20),
                          onPressed: _previousMonth,
                        ),
                        Text(
                          DateFormat('MMMM yy').format(_currentMonth),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right,
                              color: Colors.white, size: 20),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),// Days of the week (Sun, Mon, Tue, ...)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                        .map((day) => Text(
                              day,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                // Calendar grid (The days of the month)
                Container(
                  height: 240, // Give the calendar grid a fixed height
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _getDaysInMonth(),
                    itemBuilder: (context, index) {
                      final date = _getDateForIndex(index);
                      final isSelected = date.year == _selectedDate.year &&
                          date.month == _selectedDate.month &&
                          date.day == _selectedDate.day;
                      
                      // Check if the date is in the current month
                      final isCurrentMonth = date.month == _currentMonth.month;
                      
                      // Check if there are meetings on this date
                      final hasMeetings = controller.meetingsForSelectedDate(date).isNotEmpty;

                      return GestureDetector(
                        onTap: () {
                          if (isCurrentMonth) {
                            widget.onDateSelected(date);
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.white
                                : hasMeetings && isCurrentMonth
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : isCurrentMonth
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.3),
                                fontWeight: isSelected || hasMeetings
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bottom Half: Meetings List for the Selected Date
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Meetings on ${DateFormat('MMMM dd, yyyy').format(_selectedDate)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        }
                        
                        final meetings = controller.meetingsForSelectedDate(_selectedDate);
                        
                        if (meetings.isEmpty) {
                          return EmptyState(
                            message: 'No meetings scheduled for this day',
                            icon: Icons.event_busy,
                          );
                        }
                        
                        return ListView.builder(
                          itemCount: meetings.length,
                          itemBuilder: (context, index) {
                            return ManagerMeetingCard(meeting: meetings[index]);
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getDaysInMonth() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Adjust for Sunday start (0-6)
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    return daysInMonth + firstWeekday;
  }

  DateTime _getDateForIndex(int index) {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Adjust for Sunday start (0-6)
    final adjustedIndex = index - firstWeekday;
    return DateTime(_currentMonth.year, _currentMonth.month, adjustedIndex + 1);
  }
}