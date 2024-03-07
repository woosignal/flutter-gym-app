//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/controllers/checkout_status_controller.dart';
import '/app/models/cart.dart';
import '/app/models/checkout_session.dart';
import '/bootstrap/helpers.dart';
import '/resources/pages/dashboard_page.dart';
import '/resources/widgets/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/order.dart' as ws_order;
import '../widgets/woosignal_ui.dart';

class CheckoutStatusPage extends NyStatefulWidget<CheckoutStatusController> {
  static String path = "/checkout-status";

  CheckoutStatusPage({Key? key})
      : super(path, key: key, child: _CheckoutStatusState());
}

class _CheckoutStatusState extends NyState<CheckoutStatusPage> {
  ws_order.Order? _order;

  @override
  init() async {
    _order = widget.controller.data();
    await Cart.getInstance.clear();
    CheckoutSession.getInstance.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreLogo(height: 50),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          child: Text(
                            trans("Order Status"),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          padding: EdgeInsets.only(bottom: 15),
                        ),
                        Text(
                          trans("Thank You!"),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          trans("Your transaction details"),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${trans("Order Ref")}. #${_order?.id.toString()}",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12, width: 1.0),
                        ),
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.white
                                : null),
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                ],
              ),
              Align(
                child: Padding(
                  child: Text(
                    trans("Items"),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                  ),
                  padding: EdgeInsets.all(8),
                ),
                alignment: Alignment.center,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _order?.lineItems == null
                        ? 0
                        : _order?.lineItems?.length,
                    itemBuilder: (BuildContext context, int index) {
                      ws_order.LineItems lineItem = _order!.lineItems![index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Colors.white
                                  : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    lineItem.name!,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "x${lineItem.quantity.toString()}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatStringCurrency(
                                total: lineItem.total.toString(),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(8),
                      );
                    }),
              ),
              Align(
                child: LinkButton(
                    title: trans("Back to Home"),
                    action: () async {
                      routeTo(DashboardPage.path,
                          navigationType: NavigationType.pushAndForgetAll,
                          pageTransition: PageTransitionType.bottomToTop);
                    }),
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
