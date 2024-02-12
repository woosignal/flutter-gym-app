//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/controllers/book_a_class_controller.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/user_class_list_widget.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:woosignal/models/response/product.dart';

class BookAClassPage extends NyStatefulWidget<BookAClassController> {
  static const path = '/book-a-class';

  BookAClassPage({Key? key})
      : super(path, key: key, child: _BookAClassPageState());
}

class _BookAClassPageState extends NyState<BookAClassPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<String, List<Product>> listEvents = {};
  final today = DateTime.now();
  List<Product> allClasses = [];

  @override
  boot() async {
    allClasses = await widget.controller.fetchGymClasses();
  }

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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    }
    updateState("NyPullToRefreshBookAClass");
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = DateTime.now();
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
        automaticallyImplyLeading: true,
        title: Text(
          'BOOK A CLASS'.tr(),
          style: textTheme.headlineMedium,
        ),
      ),
      body: afterLoad(
        child: () {
          return Column(children: [
            TableCalendar<Product>(
              locale: NyLocalization.instance.locale.languageCode,
              firstDay: DateTime(today.year, today.month, today.day - 7),
              lastDay: DateTime(today.year, today.month + 1, today.day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  )),
              headerStyle: HeaderStyle(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade50,
                      width: 1,
                    ),
                  ),
                ),
                headerMargin: EdgeInsets.only(bottom: 10),
                titleCentered: true,
                titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
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
            Expanded(
              child: NyPullToRefresh(
                padding: EdgeInsets.only(top: 8),
                onRefresh: () async {
                  allClasses = await widget.controller.fetchGymClasses();
                  updateState("NyPullToRefreshBookAClass");
                },
                child: (context, data) {
                  return UserClassList(
                    gymClass: data,
                    day: _selectedDay,
                  );
                },
                data: (iteration) async {
                  if (iteration > 1) {
                    allClasses = await widget.controller
                        .fetchGymClasses(page: iteration);
                    if (allClasses.isEmpty) {
                      return [];
                    }
                  }
                  if (_getEventsForDay(_selectedDay).isEmpty) {
                    allClasses = await widget.controller
                        .fetchGymClasses(page: iteration);
                  }
                  return _getEventsForDay(_selectedDay);
                },
                empty: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.grey.shade700,
                      ).paddingOnly(bottom: 16),
                      Text(
                        'NO CLASSES FOUND'.tr(),
                      )
                          .bodyLarge(context)
                          .fontWeightBold()
                          .paddingOnly(bottom: 16),
                      SecondaryButton(
                        title: 'REFRESH'.tr(),
                        isLoading: isLocked('refreshing_data'),
                        action: () async {
                          await lockRelease('refreshing_data',
                              perform: () async {
                            await reboot();
                            updateState("NyPullToRefreshBookAClass");
                          });
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ),
                stateName: "NyPullToRefreshBookAClass",
              ),
            ),
          ]);
        },
      ),
    );
  }
}
