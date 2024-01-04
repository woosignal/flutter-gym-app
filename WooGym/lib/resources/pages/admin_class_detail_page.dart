import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/widgets/safearea_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/product.dart';

class AdminClassDetailPage extends NyStatefulWidget {
  static const path = '/admin-class-detail';

  AdminClassDetailPage({Key? key})
      : super(path, key: key, child: _AdminClassDetailPageState());
}

class _AdminClassDetailPageState extends NyState<AdminClassDetailPage> {
  List<Order> _orders = [];
  Product? _product;
  String? _day;


  @override
  boot() async {
    _product = widget.data(key: 'product');
    _day = widget.data(key: 'day');
    _orders = await appWooSignal(
        (api) => api.getOrders(product: _product?.id, search: _day));
  }

  @override
  Widget build(BuildContext context) {
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
