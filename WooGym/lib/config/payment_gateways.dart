import '/app/providers/payments/cash_on_delivery.dart';
import '/app/providers/payments/paypal_pay.dart';

import '/app/models/payment_type.dart';
import '/app/providers/payments/stripe_pay.dart';
import '/bootstrap/helpers.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| PAYMENT GATEWAYS
|
| Configure which payment gateways you want to use.
| Docs here: https://woosignal.com/docs/app/woogym
|--------------------------------------------------------------------------
*/

const appPaymentGateways = [];
// Available: "Stripe", "PayPal", "CashOnDelivery"
// e.g. appPaymentGateways = ["Stripe"];

List<PaymentType> paymentTypeList = [
  addPayment(
    id: 1,
    name: "Stripe",
    description: trans("Debit or Credit Card"),
    assetImage: "dark_powered_by_stripe.png",
    pay: stripePay,
  ),

  addPayment(
    id: 2,
    name: "CashOnDelivery",
    description: trans("Cash on delivery"),
    assetImage: "cash_on_delivery.jpeg",
    pay: cashOnDeliveryPay,
  ),

  addPayment(
    id: 4,
    name: "PayPal",
    description: trans("Debit or Credit Card"),
    assetImage: "paypal_logo.png",
    pay: payPalPay,
  ),

  // e.g. add more here

  // addPayment(
  //   id: 6,
  //   name: "MyNewPaymentMethod",
  //   description: "Debit or Credit Card",
  //   assetImage: "add icon image to public/assets/images/myimage.png",
  //   pay: "myCustomPaymentFunction",
  // ),
];
