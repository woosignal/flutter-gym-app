//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/dashboard_controller.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/bootstrap/shared_pref/sp_auth.dart';
import 'package:flutter_app/resources/pages/profile_page.dart';
import 'package:flutter_app/resources/widgets/about_tab_widget.dart';
import 'package:flutter_app/resources/widgets/book_a_class_widget.dart';
import 'package:flutter_app/resources/widgets/my_classes_widget.dart';
import 'package:flutter_app/resources/widgets/ny_tabbed_layout_widget.dart';
import 'package:flutter_app/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:wp_json_api/models/responses/wp_user_info_response.dart';

class DashboardPage extends NyStatefulWidget<DashboardController> {
  static const path = '/dashboard';

  DashboardPage({Key? key})
      : super(path, key: key, child: _DashboardPageState());
}

class _DashboardPageState extends NyState<DashboardPage> {
  WPUserInfoResponse? _wpUserInfoResponse;
  List<Order> _ordersUpcoming = [], _ordersPast = [], _allOrders = [];

  @override
  boot() async {
    _wpUserInfoResponse = await wpFetchUserDetails();
    String? userId = await readUserId();
    if (userId != null) {
      _allOrders = await appWooSignal(
          (api) => api.getOrders(customer: int.parse(userId)));
    }
    // order by class time
    for (var order in _allOrders) {
      if (order.classTime.isAfter(DateTime.now())) {
        _ordersUpcoming.add(order);
      } else {
        _ordersPast.add(order);
      }
    }

    _ordersUpcoming.sort((a, b) => a.classTime.compareTo(b.classTime));
    _allOrders = [
      ..._ordersUpcoming,
      ..._ordersPast,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: StoreLogo(
          height: 40,
          width: 40,
        ).paddingOnly(left: 10),
        title: Text(
          "Welcome back".tr(),
          style: textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => routeTo(ProfilePage.path),
            icon: Icon(
              Icons.person,
              size: 30,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: afterLoad(
          child: () => ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: false,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: ThemeColor.get(context).primaryAccent,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((_wpUserInfoResponse?.data?.firstName ?? "")
                                .isNotEmpty)
                              Text("${_wpUserInfoResponse?.data?.firstName}",
                                      style: textTheme.headlineMedium)
                                  .paddingOnly(left: 10),
                            if ((_wpUserInfoResponse?.data?.firstName ?? "")
                                .isEmpty)
                              Text("My Account".tr(),
                                      style: textTheme.headlineMedium)
                                  .paddingOnly(left: 10),
                            Text(getEnv('APP_NAME') + " " + "member".tr(),
                                    style: textTheme.bodyLarge!
                                        .copyWith(color: Colors.grey.shade800))
                                .paddingOnly(left: 10),
                          ],
                        ).paddingOnly(left: 8)
                      ],
                    ).paddingOnly(bottom: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text("Upcoming Classes".tr(),
                                  style: textTheme.bodyLarge),
                              Text(_ordersUpcoming.length.toString(),
                                  style: textTheme.headlineMedium),
                            ],
                          ),
                        ).flexible(),
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text("Past Classes".tr(),
                                  style: textTheme.bodyLarge),
                              Text(_ordersPast.length.toString(),
                                  style: textTheme.headlineMedium),
                            ],
                          ),
                        ).flexible(),
                      ],
                    )
                        .withDivider(endIndent: 10, indent: 10)
                        .paddingSymmetric(vertical: 16),
                  ],
                ),
              ),
              BookAClass(),
              NyTabbedLayoutTwo(
                tabs: ["My Classes".tr(), "About".tr()],
                widgets: [
                  MyClasses(
                    orders: _allOrders,
                  ),
                  AboutTab()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
