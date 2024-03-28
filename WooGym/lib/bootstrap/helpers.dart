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
import 'package:wp_json_api/models/wp_user.dart';
import '/app/models/billing_details.dart';
import '/app/models/cart.dart';
import '/app/models/cart_line_item.dart';
import '/app/models/checkout_session.dart';
import '/app/models/default_shipping.dart';
import '/app/models/payment_type.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/enums/symbol_position_enums.dart';
import '/bootstrap/extensions.dart';
import '/bootstrap/shared_pref/shared_key.dart';
import '/config/currency.dart';
import '/config/payment_gateways.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:status_alert/status_alert.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/meta_data.dart' as ws_meta;
import 'package:woosignal/models/response/tax_rate.dart';
import 'package:woosignal/woosignal.dart' as ws;
import 'package:wp_json_api/models/responses/wp_user_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart' as wp;
import '../resources/themes/styles/color_styles.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<WpUser?> getUser() async =>
    (await wp.WPJsonAPI.wpUser());

Future appWooSignal(Function(ws.WooSignal api) api) async {
  return await api(ws.WooSignal.instance);
}

/// helper to find correct color from the [context].
class ThemeColor {
  static ColorStyles get(BuildContext context, {String? themeId}) =>
      nyColorStyle<ColorStyles>(context, themeId: themeId);

  static Color fromHex(String hexColor) => nyHexColor(hexColor);
}

extension AppColor on BuildContext {
  ColorStyles get colorStyles => ThemeColor.get(this);
}

/// helper to set colors on TextStyle
extension ColorsHelper on TextStyle {
  TextStyle setColor(
      BuildContext context, Color Function(BaseColorStyles? color) newColor) {
    return copyWith(color: newColor(ThemeColor.get(context)));
  }
}

Future<List<PaymentType?>> getPaymentTypes() async {
  List<PaymentType?> paymentTypes = [];
  for (var appPaymentGateway in appPaymentGateways) {
    if (paymentTypes.firstWhere(
            (paymentType) => paymentType!.name != appPaymentGateway,
            orElse: () => null) ==
        null) {
      paymentTypes.add(paymentTypeList.firstWhereOrNull(
          (paymentTypeList) => paymentTypeList.name == appPaymentGateway));
    }
  }

  if (!appPaymentGateways.contains('Stripe') &&
      AppHelper.instance.appConfig!.stripeEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhereOrNull((element) => element.name == "Stripe"));
  }
  if (!appPaymentGateways.contains('PayPal') &&
      AppHelper.instance.appConfig!.paypalEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhereOrNull((element) => element.name == "PayPal"));
  }
  if (!appPaymentGateways.contains('CashOnDelivery') &&
      AppHelper.instance.appConfig!.codEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhereOrNull((element) => element.name == "CashOnDelivery"));
  }

  return paymentTypes.where((v) => v != null).toList();
}

PaymentType addPayment(
        {required int id,
        required String name,
        required String description,
        required String assetImage,
        required Function pay}) =>
    PaymentType(
      id: id,
      name: name,
      desc: description,
      assetImage: assetImage,
      pay: pay,
    );

showStatusAlert(context,
    {required String title,
    required String subtitle,
    IconData? icon,
    int? duration}) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: duration ?? 2),
    title: title,
    subtitle: subtitle,
    configuration: IconConfiguration(icon: icon ?? Icons.done, size: 50),
  );
}

String parseHtmlString(String? htmlString) {
  var document = parse(htmlString);
  return parse(document.body!.text).documentElement!.text;
}

String moneyFormatter(double amount) {
  MoneyFormatter fmf = MoneyFormatter(
    amount: amount,
    settings: MoneyFormatterSettings(
        symbol: AppHelper.instance.appConfig!.currencyMeta!.symbolNative,
        symbolAndNumberSeparator: ""),
  );
  if (appCurrencySymbolPosition == SymbolPositionType.left) {
    return fmf.output.symbolOnLeft;
  } else if (appCurrencySymbolPosition == SymbolPositionType.right) {
    return fmf.output.symbolOnRight;
  }
  return fmf.output.symbolOnLeft;
}

String formatDoubleCurrency({required double total}) {
  return moneyFormatter(total);
}

String formatStringCurrency({required String? total}) {
  double tmpVal = 0;
  if (total != null && total != "") {
    tmpVal = parseWcPrice(total);
  }
  return moneyFormatter(tmpVal);
}

String workoutSaleDiscount(
    {required String? salePrice, required String? priceBefore}) {
  double dSalePrice = parseWcPrice(salePrice);
  double dPriceBefore = parseWcPrice(priceBefore);
  return ((dPriceBefore - dSalePrice) * (100 / dPriceBefore))
      .toStringAsFixed(0);
}

openBrowserTab({required String url}) async {
  await FlutterWebBrowser.openWebPage(
    url: url,
    customTabsOptions: CustomTabsOptions(
      defaultColorSchemeParams:
          CustomTabsColorSchemeParams(toolbarColor: Colors.white70),
    ),
  );
}

bool isNumeric(String? str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

checkout(
    TaxRate? taxRate,
    Function(String total, BillingDetails? billingDetails, Cart cart)
        completeCheckout) async {
  String cartTotal = await CheckoutSession.getInstance
      .total(withFormat: false, taxRate: taxRate);
  BillingDetails? billingDetails = CheckoutSession.getInstance.billingDetails;
  Cart cart = Cart.getInstance;
  return await completeCheckout(cartTotal, billingDetails, cart);
}

double? strCal({required String sum}) {
  if (sum == "") {
    return 0;
  }
  Parser p = Parser();
  Expression exp = p.parse(sum);
  ContextModel cm = ContextModel();
  return exp.evaluate(EvaluationType.REAL, cm);
}

Future<double?> workoutShippingCostWC({required String? sum}) async {
  if (sum == null || sum == "") {
    return 0;
  }
  List<CartLineItem> cartLineItem = await Cart.getInstance.getCart();
  sum = sum.replaceAllMapped(defaultRegex(r'\[qty\]', strict: true), (replace) {
    return cartLineItem
        .map((f) => f.quantity)
        .toList()
        .reduce((i, d) => i + d)
        .toString();
  });

  String orderTotal = await Cart.getInstance.getSubtotal();

  sum = sum.replaceAllMapped(defaultRegex(r'\[fee(.*)]'), (replace) {
    if (replace.groupCount < 1) {
      return "()";
    }
    String newSum = replace.group(1)!;

    // PERCENT
    String percentVal = newSum.replaceAllMapped(
        defaultRegex(r'percent="([0-9\.]+)"'), (replacePercent) {
      if (replacePercent.groupCount >= 1) {
        String strPercentage =
            "( ($orderTotal * ${replacePercent.group(1)}) / 100 )";
        double? calPercentage = strCal(sum: strPercentage);

        // MIN
        String strRegexMinFee = r'min_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMinFee).hasMatch(newSum)) {
          String strMinFee =
              defaultRegex(strRegexMinFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMinFee = double.parse(strMinFee);

          if (calPercentage! < doubleMinFee) {
            return "($doubleMinFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMinFee), "");
        }

        // MAX
        String strRegexMaxFee = r'max_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMaxFee).hasMatch(newSum)) {
          String strMaxFee =
              defaultRegex(strRegexMaxFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMaxFee = double.parse(strMaxFee);

          if (calPercentage! > doubleMaxFee) {
            return "($doubleMaxFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMaxFee), "");
        }
        return "($calPercentage)";
      }
      return "";
    });

    percentVal = percentVal
        .replaceAll(
            defaultRegex(r'(min_fee=\"([0-9\.]+)\"|max_fee=\"([0-9\.]+)\")'),
            "")
        .trim();
    return percentVal;
  });

  return strCal(sum: sum);
}

Future<double?> workoutShippingClassCostWC(
    {required String? sum, List<CartLineItem>? cartLineItem}) async {
  if (sum == null || sum == "") {
    return 0;
  }
  sum = sum.replaceAllMapped(defaultRegex(r'\[qty\]', strict: true), (replace) {
    return cartLineItem!
        .map((f) => f.quantity)
        .toList()
        .reduce((i, d) => i + d)
        .toString();
  });

  String orderTotal = await Cart.getInstance.getSubtotal();

  sum = sum.replaceAllMapped(defaultRegex(r'\[fee(.*)]'), (replace) {
    if (replace.groupCount < 1) {
      return "()";
    }
    String newSum = replace.group(1)!;

    // PERCENT
    String percentVal = newSum.replaceAllMapped(
        defaultRegex(r'percent="([0-9\.]+)"'), (replacePercent) {
      if (replacePercent.groupCount >= 1) {
        String strPercentage =
            "( ($orderTotal * ${replacePercent.group(1)}) / 100 )";
        double? calPercentage = strCal(sum: strPercentage);

        // MIN
        String strRegexMinFee = r'min_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMinFee).hasMatch(newSum)) {
          String strMinFee =
              defaultRegex(strRegexMinFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMinFee = double.parse(strMinFee);

          if (calPercentage! < doubleMinFee) {
            return "($doubleMinFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMinFee), "");
        }

        // MAX
        String strRegexMaxFee = r'max_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMaxFee).hasMatch(newSum)) {
          String strMaxFee =
              defaultRegex(strRegexMaxFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMaxFee = double.parse(strMaxFee);

          if (calPercentage! > doubleMaxFee) {
            return "($doubleMaxFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMaxFee), "");
        }
        return "($calPercentage)";
      }
      return "";
    });

    percentVal = percentVal
        .replaceAll(
            defaultRegex(r'(min_fee=\"([0-9\.]+)\"|max_fee=\"([0-9\.]+)\")'),
            "")
        .trim();
    return percentVal;
  });

  return strCal(sum: sum);
}

RegExp defaultRegex(
  String pattern, {
  bool? strict,
}) {
  return RegExp(
    pattern,
    caseSensitive: strict ?? false,
    multiLine: false,
  );
}

navigatorPush(BuildContext context,
    {required String routeName,
    Object? arguments,
    bool forgetAll = false,
    int? forgetLast}) {
  if (forgetAll) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }
  if (forgetLast != null) {
    int count = 0;
    Navigator.of(context).popUntil((route) {
      return count++ == forgetLast;
    });
  }
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

DateTime parseDateTime(String strDate) => DateTime.parse(strDate);

double parseWcPrice(String? price) => (double.tryParse(price ?? "0") ?? 0);

Future<List<DefaultShipping>> getDefaultShipping() async {
  String data =
      await rootBundle.loadString('public/assets/json/default_shipping.json');
  dynamic dataJson = json.decode(data);
  List<DefaultShipping> shipping = [];

  dataJson.forEach((key, value) {
    DefaultShipping defaultShipping =
        DefaultShipping(code: key, country: value['country'], states: []);
    if (value['states'] != null) {
      value['states'].forEach((key1, value2) {
        defaultShipping.states
            .add(DefaultShippingState(code: key1, name: value2));
      });
    }
    shipping.add(defaultShipping);
  });
  return shipping;
}

Future<DefaultShipping?> findCountryMetaForShipping(String countryCode) async {
  List<DefaultShipping> defaultShipping = await getDefaultShipping();
  List<DefaultShipping> shippingByCountryCode =
      defaultShipping.where((element) => element.code == countryCode).toList();
  if (shippingByCountryCode.isNotEmpty) {
    return shippingByCountryCode.first;
  }
  return null;
}

DefaultShippingState? findDefaultShippingStateByCode(
    DefaultShipping defaultShipping, String code) {
  List<DefaultShippingState> defaultShippingStates =
      defaultShipping.states.where((state) => state.code == code).toList();
  if (defaultShippingStates.isEmpty) {
    return null;
  }
  DefaultShippingState defaultShippingState = defaultShippingStates.first;
  return DefaultShippingState(
      code: defaultShippingState.code, name: defaultShippingState.name);
}

bool hasKeyInMeta(WPUserInfoResponse wpUserInfoResponse, String key) {
  return (wpUserInfoResponse.data!.metaData ?? [])
      .where((meta) => meta.key == key)
      .toList()
      .isNotEmpty;
}

String fetchValueInMeta(WPUserInfoResponse wpUserInfoResponse, String key) {
  String value = "";
  List<dynamic>? metaDataValue = (wpUserInfoResponse.data!.metaData ?? [])
      .where((meta) => meta.key == key)
      .first
      .value;
  if (metaDataValue != null && metaDataValue.isNotEmpty) {
    return metaDataValue.first ?? "";
  }
  return value;
}

String truncateString(String data, int length) {
  return (data.length >= length) ? '${data.substring(0, length)}...' : data;
}

Future<List<dynamic>> getWishlistProducts() async {
  List<dynamic> favouriteProducts = [];
  String? currentProductsJSON =
      await (NyStorage.read(SharedKey.wishlistProducts));
  if (currentProductsJSON != null) {
    favouriteProducts = (jsonDecode(currentProductsJSON)).toList();
  }
  return favouriteProducts;
}

Future<BillingDetails> billingDetailsFromWpUserInfoResponse(
    wpUserInfoResponse) async {
  List<String> metaDataAddress = [
    'billing_first_name',
    'billing_last_name',
    'billing_company',
    'billing_address_1',
    'billing_address_2',
    'billing_city',
    'billing_postcode',
    'billing_country',
    'billing_state',
    'billing_phone',
    'billing_email',
    'shipping_first_name',
    'shipping_last_name',
    'shipping_company',
    'shipping_address_1',
    'shipping_address_2',
    'shipping_city',
    'shipping_postcode',
    'shipping_country',
    'shipping_state',
    'shipping_phone',
  ];

  Map<String, String> metaData = {};

  for (var dataKey in metaDataAddress) {
    if (hasKeyInMeta(wpUserInfoResponse, dataKey)) {
      String value = fetchValueInMeta(wpUserInfoResponse, dataKey);
      metaData.addAll({dataKey: value});
    }
  }

  BillingDetails billingDetails = BillingDetails();
  await billingDetails.fromWpMeta(metaData);
  return billingDetails;
}

/// Check if the [Product] is new.
bool isProductNew(Product? product) {
  if (product?.dateCreatedGMT == null) false;
  try {
    DateTime dateTime = DateTime.parse(product!.dateCreatedGMT!);
    return dateTime.isBetween(
            DateTime.now().subtract(Duration(days: 2)), DateTime.now()) ??
        false;
  } on Exception catch (e) {
    NyLogger.error(e.toString());
  }
  return false;
}

Future<WPUserInfoResponse> wpFetchUserDetails() async {
  return await wp.WPJsonAPI.instance.api((request) async => await request.wpGetUserInfo());
}

String? getInstructorFromProduct(Product product) {
  ws_meta.MetaData? metaData = product.metaData
      .firstWhereOrNull((element) => element.key == 'instructor');
  if (metaData == null) return "";
  return metaData.value;
}

String? getParticipantsFromProduct(Product product) {
  ws_meta.MetaData? metaData = product.metaData
      .firstWhereOrNull((element) => element.key == 'max_participants');
  if (metaData == null) return "";
  return metaData.value;
}

bool isPastClass(DateTime calendarDate) {
  DateTime now = DateTime.now();
  DateTime lastMidnight = DateTime(now.year, now.month, now.day);
  return calendarDate.isAfter(lastMidnight);
}

List<DateTime> getDatesNoClasses(Product product) {
  ws_meta.MetaData? metaData = product.metaData
      .firstWhereOrNull((element) => element.key == 'dates_no_classes');
  if (metaData == null) return [];

  List<String> noClasses = (metaData.value ?? "").split("|");
  if (noClasses.isEmpty) return [];

  return noClasses
      .where((element) => element != "")
      .map((e) => DateTime.parse(e))
      .toList();
}

bool isRecurringFromProduct(Product product) {
  ws_meta.MetaData? metaData =
      product.metaData.firstWhereOrNull((element) => element.key == 'weekly');
  if (metaData == null) return false;
  return metaData.value == "1";
}

DateTime? getClassTimeFromProduct(Product product) {
  ws_meta.MetaData? metaData = product.metaData
      .firstWhereOrNull((element) => element.key == 'class_time');
  if (metaData == null) return DateTime.now();
  try {
    if (metaData.value == null) {
       return null;
    }
    return DateTime.parse(metaData.value!);
  } on Exception catch (e) {
    NyLogger.debug(e.toString());
    return null;
  }
}

extension AppProduct on Product {
  bool get isRecurring => isRecurringFromProduct(this);
  DateTime? get classTime => getClassTimeFromProduct(this);
  String? get instructor => getInstructorFromProduct(this);
  String? get participants => getParticipantsFromProduct(this);
  String? get gym => getGymFromOrder(this);
  List<DateTime> get datesNoClasses => getDatesNoClasses(this);
  bool get isNew => isProductNew(this);
}

extension AppString on String? {
  String toMoney() => formatStringCurrency(total: this);
}

String? getGymFromOrder(Product product) {
  ws_meta.MetaData? metaData =
      product.metaData.firstWhereOrNull((element) => element.key == 'gym');
  if (metaData == null) return "";
  return metaData.value;
}

String formatToTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);

String formatToDay(DateTime dateTime) => DateFormat('EEEE').format(dateTime);

String formatToDateTime(DateTime dateTime) =>
    DateFormat('yyyy-MM-dd').format(dateTime);

String formatToTimeFromProduct(Product product) {
  DateTime? dateTime = getClassTimeFromProduct(product);
  if (dateTime == null) {
    return "";
  }
  return formatToTime(dateTime);
}

Future<bool> isClassBookable(
    {required Product product, required DateTime day}) async {
  String dayTime = formatToDateTime(day);
  List<Order> orders = await appWooSignal(
      (api) => api.getOrders(product: product.id, search: dayTime));
  int totalParticipants = orders.length;

  String? maxParticipants = getParticipantsFromProduct(product);
  if (maxParticipants == null) return false;

  List<DateTime> datesNotAvailable = getDatesNoClasses(product);
  for (var dateCheck in datesNotAvailable) {
    if (dateCheck.isSameDate(day)) {
      return false;
    }
  }
  return (totalParticipants < int.parse(maxParticipants));
}

bool checkIfProductIsAvailableOnDate(Product product, DateTime day) {
  List<DateTime> datesNotAvailable = getDatesNoClasses(product);
  for (var dateCheck in datesNotAvailable) {
    if (dateCheck.isSameDate(day)) {
      return false;
    }
  }
  return true;
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension AppOrder on Order {
  DateTime? get classTime => OrderHelper.getClassTimeFromOrder(this);
  String? get instructor => OrderHelper.getInstructorFromOrder(this);
  String? get gym => OrderHelper.getGymFromOrder(this);
  String get formattedDate => OrderHelper.formatToNiceDate(this);
  String get formattedTime => OrderHelper.formatToTimeFromOrder(this);
}

class OrderHelper {
  static DateTime? getClassTimeFromOrder(Order order) {
    ws_meta.MetaData? metaData = order.metaData
        ?.firstWhereOrNull((element) => element.key == 'class_time');
    if (metaData == null) return DateTime.now();
    try {
      return DateTime.parse(metaData.value ?? "");
    } on Exception catch (e) {
      NyLogger.debug('Error ${metaData.value} | ${e.toString()}');
      return null;
    }
  }

  static String? getInstructorFromOrder(Order order) {
    ws_meta.MetaData? metaData = order.metaData
        ?.firstWhereOrNull((element) => element.key == 'instructor');
    if (metaData == null) return "";
    return metaData.value;
  }

  static String? getGymFromOrder(Order order) {
    ws_meta.MetaData? metaData =
        order.metaData?.firstWhereOrNull((element) => element.key == 'gym');
    if (metaData == null) return "";
    return metaData.value;
  }

  static String addOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  static String formatToNiceDate(Order order) {
    DateTime? dateTime = getClassTimeFromOrder(order);
    if (dateTime == null) {
      return "";
    }
    return dateTime.toShortDate();
  }

  static String formatToTimeFromOrder(Order order) {
    DateTime? dateTime = getClassTimeFromOrder(order);
    if (dateTime == null) {
      return "";
    }
    return formatToTime(dateTime);
  }
}
