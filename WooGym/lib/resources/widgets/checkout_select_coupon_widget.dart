//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/models/checkout_session.dart';
import 'package:nylo_framework/nylo_framework.dart';

class CheckoutSelectCouponWidget extends StatelessWidget {
  const CheckoutSelectCouponWidget(
      {super.key,
      required this.context,
      required this.checkoutSession,
      required this.resetState});

  final CheckoutSession checkoutSession;
  final BuildContext context;
  final Function resetState;

  @override
  Widget build(BuildContext context) {
    bool hasCoupon = checkoutSession.coupon != null;
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: _actionCoupon,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasCoupon == true)
              IconButton(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  onPressed: _clearCoupon,
                  icon: Icon(
                    Icons.close,
                    size: 19,
                  )),
            Text(
              hasCoupon
                  ? "${"Coupon Applied".tr()}: ${checkoutSession.coupon!.code!}"
                  : trans('Apply Coupon'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  _clearCoupon() {
    CheckoutSession.getInstance.coupon = null;
    resetState();
  }

  _actionCoupon() {
    if (checkoutSession.billingDetails!.billingAddress == null) {
      showToastNotification(
        context,
        title: trans("Oops"),
        description:
            trans("Please select add your billing/shipping address to proceed"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.local_shipping,
      );

      return;
    }
    if (checkoutSession.billingDetails?.billingAddress?.hasMissingFields() ??
        true) {
      showToastNotification(
        context,
        title: trans("Oops"),
        description: trans("Your billing/shipping details are incomplete"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.local_shipping,
      );
      return;
    }
    Navigator.pushNamed(context, "/checkout-coupons")
        .then((value) => resetState());
  }
}
