//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:woosignal/models/response/order.dart';

import 'controller.dart';
import 'package:flutter/widgets.dart';

class AccountOrderDetailController extends Controller {
  int? orderId;
  Order? order;

  @override
  construct(BuildContext context) {
    super.construct(context);
    orderId = data();
  }

  /// Fetch order details
  fetchOrder() async {
    if (orderId == null) {
      return;
    }
    order = await (appWooSignal((api) => api.retrieveOrder(orderId!)));
  }
}
