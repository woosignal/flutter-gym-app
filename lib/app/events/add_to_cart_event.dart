import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/product.dart';
import '/bootstrap/helpers.dart';
import '/app/models/cart.dart';
import '/app/models/cart_line_item.dart';
import '/app/models/checkout_session.dart';
import '/app/models/customer_address.dart';

class AddToCartEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    DateTime day = event['day'];
    Product gymClass = event['gym_class'];

    Cart.getInstance.clear();
    CartLineItem cartLineItem =
        CartLineItem.fromProduct(quantityAmount: 1, product: gymClass);

    DateTime dateTime = getClassTimeFromProduct(gymClass);
    String dateTimeStr = "${formatToDateTime(day)} ${formatToTime(dateTime)}";

    cartLineItem.appMetaData = [
      {
        "key": "instructor",
        "value": getInstructorFromProduct(gymClass),
      },
      {
        "key": "class_time",
        "value": dateTimeStr,
      },
      {
        "key": "gym",
        "value": getGymFromOrder(gymClass),
      },
    ];
    await Cart.getInstance.addToCart(
      cartLineItem: cartLineItem,
    );

    CheckoutSession.getInstance.initSession();
    CustomerAddress? sfCustomerAddress =
        await CheckoutSession.getInstance.getBillingAddress();

    if (sfCustomerAddress != null) {
      CheckoutSession.getInstance.billingDetails!.billingAddress =
          sfCustomerAddress;
      CheckoutSession.getInstance.billingDetails!.shippingAddress =
          sfCustomerAddress;
    }
    CheckoutSession.getInstance.eventDay = formatToDateTime(day);
    routeTo('/checkout');
  }
}
