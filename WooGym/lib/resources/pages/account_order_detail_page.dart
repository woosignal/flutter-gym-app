//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/account_order_detail_controller.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/widgets/safearea_widget.dart';
import 'package:flutter_app/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/order.dart';

class AccountOrderDetailPage
    extends NyStatefulWidget<AccountOrderDetailController> {
  static String path = "/account-order-detail";

  AccountOrderDetailPage({Key? key})
      : super(path, key: key, child: _AccountOrderDetailPageState());
}

class _AccountOrderDetailPageState extends NyState<AccountOrderDetailPage> {
  @override
  boot() async {
    await widget.controller.fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          margin: EdgeInsets.only(left: 0),
        ),
        title: afterNotNull(widget.controller.order,
            child: () => Text(
                "${trans("Order").capitalize()} #${widget.controller.orderId.toString()}"),
            loading: SizedBox.shrink()),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeAreaWidget(child: afterLoad(child: () {
        if (widget.controller.order == null) {
          return Container(
            child: Center(
              child: Text("No orders found".tr()),
            ),
          );
        }
        Order order = widget.controller.order!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "${trans("Date Ordered").capitalize()}: ${DateTime.parse(order.dateCreated!).toDateString()}",
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text("${trans("Ships to").capitalize()}:"),
                  ),
                  Flexible(
                    child: Text(
                      [
                        [order.shipping!.firstName, order.shipping!.lastName]
                            .where((t) => t != null)
                            .toList()
                            .join(" "),
                        order.shipping!.address1,
                        order.shipping!.address2,
                        order.shipping!.city,
                        order.shipping!.state,
                        order.shipping!.postcode,
                        order.shipping!.country,
                      ]
                          .where((t) => (t != "" && t != null))
                          .toList()
                          .join("\n"),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: (Theme.of(context).brightness == Brightness.light)
                    ? wsBoxShadow()
                    : null,
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.white
                    : Color(0xFF2C2C2C),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (cxt, i) {
                  LineItems lineItem = order.lineItems![i];
                  return Card(
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 6),
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Color(0xFFFCFCFC), width: 1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                lineItem.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              formatStringCurrency(total: lineItem.price)
                                  .capitalize(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                                  formatStringCurrency(
                                    total: lineItem.total,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "x${lineItem.quantity.toString()}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: (order.lineItems ?? []).length,
              ),
            ),
          ],
        );
      })),
    );
  }
}
