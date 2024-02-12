//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
import '/app/controllers/woosignal_api_loader_controller.dart';
import 'package:woosignal/models/response/order.dart';

class CustomerOrdersLoaderController
    extends WooSignalApiLoaderController<Order> {
  CustomerOrdersLoaderController();

  Future<void> loadOrders(
      {required bool Function(bool hasProducts) hasResults,
      required void Function() didFinish,
      required String userId}) async {
    await load(
        hasResults: hasResults,
        didFinish: didFinish,
        apiQuery: (api) => api.getOrders(
            customer: int.parse(userId), page: page, perPage: 50));
  }
}
