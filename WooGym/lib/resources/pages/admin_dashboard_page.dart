//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/bootstrap/helpers.dart';
import '/resources/pages/profile_page.dart';
import '/resources/widgets/user_class_list_widget.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:woosignal/models/response/product.dart';

class AdminDashboardPage extends NyStatefulWidget {
  static const path = '/admin-dashboard';

  AdminDashboardPage({Key? key})
      : super(path, key: key, child: _AdminDashboardPageState());
}

class _AdminDashboardPageState extends NyState<AdminDashboardPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Product> allClasses = [];
  final today = DateTime.now();

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
  }

  @override
  boot() async {
    allClasses = await appWooSignal((api) =>
        api.getProducts(type: "gym_class", status: "publish", perPage: 100));

    if (_selectedDay != null) {
      _selectedEvents = _getEventsForDay(_selectedDay!);
    }
  }

  Map<String, List<Product>> listEvents = {};

  List<Product> _getEventsForDay(DateTime day) {
    String dateCalendar = DateFormat('EEEE').format(day);
    listEvents[dateCalendar] = allClasses.where((classEvent) {
      if (isRecurringFromProduct(classEvent) &&
          DateFormat('EEEE').format(day) ==
              formatToDay(getClassTimeFromProduct(classEvent))) {
        return true;
      }

      if (DateFormat('EEEE').format(day) !=
          formatToDay(getClassTimeFromProduct(classEvent))) {
        return false;
      }

      return true;
    }).toList();

    return listEvents[dateCalendar] ?? [];
  }

  List<Product> _selectedEvents = [];
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedEvents = [];
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              routeTo(ProfilePage.path);
            },
            icon: Icon(
              Icons.person,
              size: 30,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar<Product>(
              firstDay: DateTime(today.year, today.month, today.day - 7),
              lastDay: DateTime(today.year, today.month + 1, today.day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                formatButtonVisible: false,
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                ),
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 0.0),
            Expanded(
              child: afterLoad(child: () {
                if (_selectedEvents.isEmpty) {
                  return Center(
                    child: Text(
                      'NO CLASSES FOUND'.tr(),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.only(top: 16),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) => UserClassList(
                    adminViewer: true,
                    gymClass: _selectedEvents[index],
                    day: _selectedDay ?? DateTime.now(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
