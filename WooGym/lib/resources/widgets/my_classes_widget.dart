//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/events/add_to_calendar_event.dart';
import '/bootstrap/extensions.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/order.dart';
import '/bootstrap/helpers.dart';
import '/bootstrap/shared_pref/sp_auth.dart';

class MyClasses extends StatefulWidget {
  MyClasses({super.key, required this.orders});

  final List<Order> orders;

  static String state = "my_classes";

  @override
  createState() => _MyClassesState();
}

class _MyClassesState extends NyState<MyClasses> {
  _MyClassesState() {
    stateName = MyClasses.state;
  }

  @override
  stateUpdated(dynamic data) async {}

  @override
  Widget build(BuildContext context) {
    return NyListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        child: (context, order) {
          order as Order;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ]),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: (OrderHelper.getClassTimeFromOrder(order)
                                    .isAfter(DateTime.now()))
                                ? Colors.teal.shade500
                                : Colors.grey,
                            gradient: (OrderHelper.getClassTimeFromOrder(order)
                                    .isAfter(DateTime.now()))
                                ? LinearGradient(
                                    colors: [
                                      Colors.teal.shade400,
                                      Colors.teal.shade600,
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp)
                                : null,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: 125,
                          child: Column(
                            children: [
                              Text(
                                order.classTime.toTimeString().toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                              Text(
                                order.classTime.toShortDate().capitalize(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${order.lineItems?.first.name} ${"with".tr()} ${OrderHelper.getInstructorFromOrder(order)}",
                                        overflow: TextOverflow.ellipsis)
                                    .bodyLarge(context)
                                    .fontWeightBold()
                                    .setMaxLines(2),
                                Text(
                                  OrderHelper.getGymFromOrder(order) ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      children: [
                        if (!order.classTime.isInPast())
                          IconButton(
                            icon: Icon(Icons.calendar_month),
                            onPressed: () async {
                              await event<AddToCalendarEvent>(
                                  data: {"order": order});
                            },
                            padding: EdgeInsets.zero,
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        data: () async {
          String? userId = await readUserId();
          if (userId != null) {
            return widget.orders;
          }
          return [];
        },
        empty: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 100,
                color: Colors.grey.shade300,
              ),
              Text("No classes found".tr())
                  .titleLarge(context)
                  .setColor(context, (color) => Colors.black87)
                  .paddingOnly(top: 16),
            ],
          ),
        ).paddingOnly(top: 50));
  }
}
