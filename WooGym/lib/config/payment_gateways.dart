import 'package:flutter_app/app/models/payment_type.dart';
import 'package:flutter_app/app/providers/payments/cash_on_delivery.dart';
import 'package:flutter_app/app/providers/payments/stripe_pay.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| PAYMENT GATEWAYS
|
| Configure which payment gateways you want to use.
| Docs here: https://woosignal.com/docs/app/label-storemax
|--------------------------------------------------------------------------
*/

const appPaymentGateways = [];
// Available: "Stripe", "CashOnDelivery", "PayPal", "RazorPay"
// e.g. app_payment_gateways = ["Stripe", "CashOnDelivery"]; will only use Stripe and Cash on Delivery.

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

  // e.g. add more here

  // addPayment(
  //   id: 6,
  //   name: "MyNewPaymentMethod",
  //   description: "Debit or Credit Card",
  //   assetImage: "add icon image to public/assets/images/myimage.png",
  //   pay: "myCustomPaymentFunction",
  // ),
];
