//  WooGym
//
//  Created by Anthony Gordon.
//  2025, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/safearea_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/product.dart';

class AdminClassDetailPage extends NyStatefulWidget {
  static RouteView path = ("/admin-class-detail", (_) => AdminClassDetailPage());

  AdminClassDetailPage() : super(child: () => _AdminClassDetailPageState());
}

class _AdminClassDetailPageState extends NyPage<AdminClassDetailPage> {
  List<Order> _orders = [];
  
  Product? get _product {
    dynamic data = widget.data();
    return data['product'];
  }
  
  String? get _day {
    dynamic data = widget.data();
    return data['day'];
  }

  @override
  get init => () async {
    _orders = await appWooSignal(
        (api) => api.getOrders(product: _product?.id, search: _day));
  };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _product?.name ?? "",
          style: textTheme.headlineMedium,
        ),
      ),
      body: SafeAreaWidget(
        child: afterLoad(child: () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Participants".tr(),
                          style: textTheme.headlineMedium),
                      Text("${"Total Participants".tr()}: ${_orders.length}")
                          .paddingOnly(bottom: 10),
                    ],
                  ),
                  Icon(
                    Icons.person,
                    size: 40,
                    color: ThemeColor.get(context).primaryAccent,
                  ),
                ],
              ),
              Expanded(
                child: NyListView.separated(
                  child: (context, order) {
                    order as Order;
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.shade50,
                        ),
                        child: ListTile(
                          title: Text(
                            "${order.billing?.firstName} ${order.billing?.lastName}",
                          ).fontWeightBold(),
                          subtitle: Text(
                              "${order.billing?.phone} / ${order.billing?.email}"),
                          trailing: Icon(Icons.check),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  data: () async {
                    return _orders;
                  },
                  empty: Container(
                    child: Text(
                      "No Participants".tr(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
