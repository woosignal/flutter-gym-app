//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:convert';

import 'package:collection/collection.dart' show IterableExtension;
import '/app/models/cart_line_item.dart';
import '/app/models/checkout_session.dart';
import '/app/models/shipping_type.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import '/bootstrap/shared_pref/shared_key.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/shipping_method.dart';
import 'package:woosignal/models/response/tax_rate.dart';

class Cart {
  Cart._privateConstructor();
  static final Cart getInstance = Cart._privateConstructor();

  Future<List<CartLineItem>> getCart() async {
    List<CartLineItem> cartLineItems = [];
    String? currentCartArrJSON = await (NyStorage.read(SharedKey.cart));

    if (currentCartArrJSON != null) {
      cartLineItems = (jsonDecode(currentCartArrJSON) as List<dynamic>)
          .map((i) => CartLineItem.fromJson(i))
          .toList();
    }

    return cartLineItems;
  }

  Future addToCart({required CartLineItem cartLineItem}) async {
    List<CartLineItem> cartLineItems = await getCart();

    if (cartLineItem.variationId != null &&
        cartLineItems.firstWhereOrNull((i) =>
                (i.productId == cartLineItem.productId &&
                    i.variationId == cartLineItem.variationId &&
                    i.variationOptions == cartLineItem.variationOptions)) !=
            null) {
      cartLineItems.removeWhere((item) =>
          item.productId == cartLineItem.productId &&
          item.variationId == cartLineItem.variationId &&
          item.variationOptions == cartLineItem.variationOptions);
    }

    if (cartLineItem.variationId == null &&
        cartLineItems.firstWhereOrNull(
                (i) => i.productId == cartLineItem.productId) !=
            null) {
      cartLineItems
          .removeWhere((item) => item.productId == cartLineItem.productId);
    }

    cartLineItems.add(cartLineItem);

    await saveCartToPref(cartLineItems: cartLineItems);
  }

  Future<String> getTotal({bool withFormat = false}) async {
    List<CartLineItem> cartLineItems = await getCart();
    double total = 0;
    for (var cartItem in cartLineItems) {
      total += (parseWcPrice(cartItem.total) * cartItem.quantity);
    }

    CheckoutSession checkoutSession = CheckoutSession.getInstance;
    if (checkoutSession.coupon != null) {
      String discountAmount = await Cart.getInstance.couponDiscountAmount();
      total = total - double.parse(discountAmount);
    }

    if (withFormat == true) {
      return formatDoubleCurrency(total: total);
    }
    return total.toStringAsFixed(2);
  }

  Future<String> getSubtotal({bool withFormat = false}) async {
    List<CartLineItem> cartLineItems = await getCart();
    double subtotal = 0;
    for (var cartItem in cartLineItems) {
      subtotal += (parseWcPrice(cartItem.subtotal) * cartItem.quantity);
    }
    if (withFormat == true) {
      return formatDoubleCurrency(total: subtotal);
    }
    return subtotal.toStringAsFixed(2);
  }

  updateQuantity(
      {required CartLineItem cartLineItem,
      required int incrementQuantity}) async {
    List<CartLineItem> cartLineItems = await getCart();
    List<CartLineItem> tmpCartItem = [];
    for (var cartItem in cartLineItems) {
      if (cartItem.variationId == cartLineItem.variationId &&
          cartItem.productId == cartLineItem.productId) {
        if ((cartItem.quantity + incrementQuantity) > 0) {
          cartItem.quantity += incrementQuantity;
        }
      }
      tmpCartItem.add(cartItem);
    }
    await saveCartToPref(cartLineItems: tmpCartItem);
  }

  Future<String> cartShortDesc() async {
    List<CartLineItem> cartLineItems = await getCart();
    return cartLineItems
        .map((cartItem) =>
            "${cartItem.quantity.toString()} x | ${cartItem.name}")
        .toList()
        .join(",");
  }

  removeCartItemForIndex({required int index}) async {
    List<CartLineItem> cartLineItems = await getCart();
    cartLineItems.removeAt(index);
    await saveCartToPref(cartLineItems: cartLineItems);
  }

  clear() async => NyStorage.delete(SharedKey.cart);

  saveCartToPref({required List<CartLineItem> cartLineItems}) async {
    String json = jsonEncode(cartLineItems.map((i) => i.toJson()).toList());
    await NyStorage.store(SharedKey.cart, json);
  }

  Future<String> taxAmount(TaxRate? taxRate) async {
    double subtotal = 0;
    double shippingTotal = 0;

    List<CartLineItem> cartItems = await Cart.getInstance.getCart();

    if (cartItems.every((c) => c.taxStatus == 'none')) {
      return "0";
    }
    List<CartLineItem> taxableCartLines =
        cartItems.where((c) => c.taxStatus == 'taxable').toList();
    double cartSubtotal = 0;

    if (AppHelper.instance.appConfig!.productPricesIncludeTax == 1 &&
        taxableCartLines.isNotEmpty) {
      cartSubtotal = taxableCartLines
          .map<double>((m) => parseWcPrice(m.subtotal) * m.quantity)
          .reduce((a, b) => a + b);
      if (CheckoutSession.getInstance.coupon != null) {
        String discountAmount = await Cart.getInstance.couponDiscountAmount();
        cartSubtotal = cartSubtotal - double.parse(discountAmount);
      }
    }

    subtotal = cartSubtotal;

    ShippingType? shippingType = CheckoutSession.getInstance.shippingType;

    if (shippingType != null) {
      switch (shippingType.methodId) {
        case "flat_rate":
          FlatRate flatRate = (shippingType.object as FlatRate);
          if (flatRate.taxable != null && flatRate.taxable!) {
            shippingTotal +=
                parseWcPrice(shippingType.cost == "" ? "0" : shippingType.cost);
          }
          break;
        case "local_pickup":
          LocalPickup localPickup = (shippingType.object as LocalPickup);
          if (localPickup.taxable != null && localPickup.taxable!) {
            shippingTotal += parseWcPrice(
                (localPickup.cost == null || localPickup.cost == ""
                    ? "0"
                    : localPickup.cost));
          }
          break;
        default:
          break;
      }
    }

    double total = 0;
    if (subtotal != 0) {
      total += ((parseWcPrice(taxRate!.rate) * subtotal) / 100);
    }
    if (shippingTotal != 0) {
      total += ((parseWcPrice(taxRate!.rate) * shippingTotal) / 100);
    }
    return (total).toStringAsFixed(2);
  }

  Future<String> couponDiscountAmount() async {
    CheckoutSession checkoutSession = CheckoutSession.getInstance;

    if (checkoutSession.coupon == null) {
      return "0";
    }

    List<CartLineItem> cartLineItems = await getCart();
    List<CartLineItem> eligibleCartLineItems = [];
    double subtotal = 0;
    for (var cartItem in cartLineItems) {
      bool canContinue = true;

      if (checkoutSession.coupon!.excludedProductCategories!.isNotEmpty) {
        for (var excludedProductCategory
            in checkoutSession.coupon!.excludedProductCategories!) {
          if (cartItem.categories!
              .map((category) => category.id)
              .contains(excludedProductCategory)) {
            canContinue = false;
            break;
          }
        }
      }

      if (checkoutSession.coupon!.productCategories!.isNotEmpty) {
        for (var productCategories
            in checkoutSession.coupon!.productCategories!) {
          if (cartItem.categories!
                  .map((category) => category.id)
                  .contains(productCategories) ==
              false) {
            canContinue = false;
            break;
          }
        }
      }

      if (canContinue == false) {
        continue;
      }

      if (checkoutSession.coupon!.excludeSaleItems == true &&
          cartItem.onSale == true) {
        continue;
      }

      if (checkoutSession.coupon!.excludedProductIds!.isNotEmpty &&
          checkoutSession.coupon!.excludedProductIds!
              .contains(cartItem.productId)) {
        continue;
      }

      if (checkoutSession.coupon!.productIds!.isNotEmpty &&
          !checkoutSession.coupon!.productIds!.contains(cartItem.productId)) {
        continue;
      }
      subtotal += (parseWcPrice(cartItem.subtotal) * cartItem.quantity);
      eligibleCartLineItems.add(cartItem);
    }

    String? discountType = checkoutSession.coupon!.discountType;
    String? amount = checkoutSession.coupon!.amount;

    // Percentage
    if (discountType == 'percent') {
      return ((subtotal * double.parse(amount!)) / 100).toStringAsFixed(2);
    }

    // Fixed cart
    if (discountType == 'fixed_cart') {
      return (double.parse(amount!)).toStringAsFixed(2);
    }

    // Fixed product
    if (discountType == 'fixed_product') {
      return (eligibleCartLineItems.length * double.parse(amount!))
          .toStringAsFixed(2);
    }
    return "0";
  }
}
