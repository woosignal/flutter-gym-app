//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter_app/app/controllers/woosignal_api_loader_controller.dart';
import 'package:woosignal/models/response/product_review.dart';
import 'package:woosignal/models/response/product.dart';

class ProductReviewsLoaderController
    extends WooSignalApiLoaderController<ProductReview> {
  ProductReviewsLoaderController();

  Future<void> loadProductReviews({
    required Product? product,
    required bool Function(bool hasProducts) hasResults,
    required void Function() didFinish,
  }) async {
    await load(
        hasResults: hasResults,
        didFinish: didFinish,
        apiQuery: (api) => api.getProductReviews(
              product: [product!.id!],
              perPage: 50,
              page: page,
              status: "approved",
            ));
  }
}
