//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:wp_json_api/wp_json_api.dart';
import '/app/controllers/customer_orders_loader_controller.dart';
import '/bootstrap/helpers.dart';
import '/resources/pages/account_order_detail_page.dart';
import '/resources/widgets/safearea_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AccountDetailOrdersPage extends NyStatefulWidget {
  static const String path = "/account-orders";
  AccountDetailOrdersPage()
      : super(path, child: _AccountDetailOrdersPageState());
}

class _AccountDetailOrdersPageState extends NyState<AccountDetailOrdersPage> {
  final CustomerOrdersLoaderController _customerOrdersLoaderController =
      CustomerOrdersLoaderController();

  @override
  boot() async {
    await fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders".tr()),
      ),
      body: SafeAreaWidget(
        child: afterLoad(
          child: () => NyPullToRefresh(
            child: (context, order) {
              return Card(
                child: ListTile(
                  contentPadding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 8,
                    right: 6,
                  ),
                  title: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFFCFCFC),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "${order.lineItems?.first.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              formatStringCurrency(total: order.total),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "${order.lineItems!.length} ${trans("items")}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Text(
                          "${DateTime.parse(order.dateCreated!).toDateString()}\n${DateTime.parse(order.dateCreated!).toTimeString()}",
                          textAlign: TextAlign.right,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () =>
                      routeTo(AccountOrderDetailPage.path, data: order.id),
                ),
              );
            },
            data: (iteration) async {
              return _customerOrdersLoaderController.getResults();
            },
            empty: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.black54,
                    size: 40,
                  ),
                  Text(
                    trans("No orders found"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  fetchOrders() async {
    String? userId = await WPJsonAPI.wpUserId();
    if (userId == null) return;

    await _customerOrdersLoaderController.loadOrders(
        hasResults: (result) {
          if (result == false) {
            return false;
          }
          return true;
        },
        didFinish: () {},
        userId: userId);
  }
}
