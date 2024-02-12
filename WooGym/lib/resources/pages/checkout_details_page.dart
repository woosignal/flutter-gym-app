//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/models/billing_details.dart';
import '/app/models/checkout_session.dart';
import '/app/models/customer_address.dart';
import '/app/models/customer_country.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import '/bootstrap/shared_pref/sp_auth.dart';
import '/resources/widgets/app_loader_widget.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/customer_address_input.dart';
import '/resources/widgets/safearea_widget.dart';
import '/resources/widgets/switch_address_tab.dart';
import '/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:validated/validated.dart' as validate;
import 'package:wp_json_api/models/responses/wp_user_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart';
import '../../app/models/default_shipping.dart';

class CheckoutDetailsPage extends NyStatefulWidget {
  static String path = "/checkout-details";

  CheckoutDetailsPage() : super(path, child: _CheckoutDetailsPageState());
}

class _CheckoutDetailsPageState extends NyState<CheckoutDetailsPage> {
  _CheckoutDetailsPageState();

  bool? _hasDifferentShippingAddress = false,
      valRememberDetails = true,
      _wpLoginEnabled;
  int activeTabIndex = 0;

  // TEXT CONTROLLERS
  final TextEditingController
      // billing
      _txtBillingFirstName = TextEditingController(),
      _txtBillingLastName = TextEditingController(),
      _txtBillingAddressLine = TextEditingController(),
      _txtBillingCity = TextEditingController(),
      _txtBillingPostalCode = TextEditingController(),
      _txtBillingEmailAddress = TextEditingController(),
      _txtBillingPhoneNumber = TextEditingController(),
      // shipping
      _txtShippingFirstName = TextEditingController(),
      _txtShippingLastName = TextEditingController(),
      _txtShippingAddressLine = TextEditingController(),
      _txtShippingCity = TextEditingController(),
      _txtShippingPostalCode = TextEditingController(),
      _txtShippingEmailAddress = TextEditingController();

  CustomerCountry? _billingCountry, _shippingCountry;

  Widget? activeTab;

  Widget tabShippingDetails() => CustomerAddressInput(
        txtControllerFirstName: _txtShippingFirstName,
        txtControllerLastName: _txtShippingLastName,
        txtControllerAddressLine: _txtShippingAddressLine,
        txtControllerCity: _txtShippingCity,
        txtControllerPostalCode: _txtShippingPostalCode,
        txtControllerEmailAddress: _txtShippingEmailAddress,
        customerCountry: _shippingCountry,
        onTapCountry: () => _navigateToSelectCountry(type: "shipping"),
      );

  Widget tabBillingDetails() => CustomerAddressInput(
        txtControllerFirstName: _txtBillingFirstName,
        txtControllerLastName: _txtBillingLastName,
        txtControllerAddressLine: _txtBillingAddressLine,
        txtControllerCity: _txtBillingCity,
        txtControllerPostalCode: _txtBillingPostalCode,
        txtControllerEmailAddress: _txtBillingEmailAddress,
        txtControllerPhoneNumber: _txtBillingPhoneNumber,
        customerCountry: _billingCountry,
        onTapCountry: () => _navigateToSelectCountry(type: "billing"),
      );

  @override
  void init() async {
    super.init();

    _wpLoginEnabled = AppHelper.instance.appConfig?.wpLoginEnabled == 1;

    if (_wpLoginEnabled == true) {
      await awaitData(perform: () async {
        await _fetchUserDetails();
      });
      return;
    }

    if (CheckoutSession.getInstance.billingDetails!.billingAddress == null) {
      CheckoutSession.getInstance.billingDetails!.initSession();
      CheckoutSession.getInstance.billingDetails!.shippingAddress!
          .initAddress();
      CheckoutSession.getInstance.billingDetails!.billingAddress?.initAddress();
    }
    BillingDetails billingDetails = CheckoutSession.getInstance.billingDetails!;
    _setFieldsFromCustomerAddress(billingDetails.billingAddress,
        type: "billing");
    _setFieldsFromCustomerAddress(billingDetails.shippingAddress,
        type: "shipping");

    _hasDifferentShippingAddress =
        CheckoutSession.getInstance.shipToDifferentAddress;
    valRememberDetails = billingDetails.rememberDetails ?? true;
    if (valRememberDetails == true) {
      await _setCustomersDetailsFromRemember();
      return;
    }
    setState(() {});
  }

  _setCustomersDetailsFromRemember() async {
    CustomerAddress? sfCustomerBillingAddress =
        await CheckoutSession.getInstance.getBillingAddress();
    _setFieldsFromCustomerAddress(sfCustomerBillingAddress, type: "billing");

    CustomerAddress? sfCustomerShippingAddress =
        await CheckoutSession.getInstance.getShippingAddress();
    _setFieldsFromCustomerAddress(sfCustomerShippingAddress, type: "shipping");
    setState(() {});
  }

  _setFieldsFromCustomerAddress(CustomerAddress? customerAddress,
      {required String type}) {
    assert(type != "");
    if (customerAddress == null) {
      return;
    }
    _setFields(
      firstName: customerAddress.firstName,
      lastName: customerAddress.lastName,
      addressLine: customerAddress.addressLine,
      city: customerAddress.city,
      postalCode: customerAddress.postalCode,
      emailAddress: customerAddress.emailAddress,
      phoneNumber: customerAddress.phoneNumber,
      customerCountry: customerAddress.customerCountry,
      type: type,
    );
  }

  _setFields(
      {required String? firstName,
      required String? lastName,
      required String? addressLine,
      required String? city,
      required String? postalCode,
      required String? emailAddress,
      required String? phoneNumber,
      required CustomerCountry? customerCountry,
      String? type}) {
    if (type == "billing") {
      _txtBillingFirstName.text = firstName ?? "";
      _txtBillingLastName.text = lastName ?? "";
      _txtBillingAddressLine.text = addressLine ?? "";
      _txtBillingCity.text = city ?? "";
      _txtBillingPostalCode.text = postalCode ?? "";
      _txtBillingPhoneNumber.text = phoneNumber ?? "";
      _txtBillingEmailAddress.text = emailAddress ?? "";
      _billingCountry = customerCountry;
    } else if (type == "shipping") {
      _txtShippingFirstName.text = firstName ?? "";
      _txtShippingLastName.text = lastName ?? "";
      _txtShippingAddressLine.text = addressLine ?? "";
      _txtShippingCity.text = city ?? "";
      _txtShippingPostalCode.text = postalCode ?? "";
      _txtShippingEmailAddress.text = emailAddress ?? "";
      _shippingCountry = customerCountry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(trans("Billing Details")),
        centerTitle: false,
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              CheckoutSession.getInstance.coupon = null;
              Navigator.pop(context);
            },
          ),
          margin: EdgeInsets.only(left: 0),
        ),
      ),
      body: SafeAreaWidget(
        child: (isLoading() || isLocked('load_shipping_info'))
            ? AppLoaderWidget()
            : GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (_hasDifferentShippingAddress!)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        SwitchAddressTab(
                                            title: trans("Billing Details"),
                                            currentTabIndex: activeTabIndex,
                                            type: "billing",
                                            onTapAction: () => setState(() {
                                                  activeTabIndex = 0;
                                                  activeTab =
                                                      tabBillingDetails();
                                                })),
                                        // SwitchAddressTab(
                                        //     title: trans("Shipping Address"),
                                        //     currentTabIndex: activeTabIndex,
                                        //     type: "shipping",
                                        //     onTapAction: () => setState(() {
                                        //           activeTabIndex = 1;
                                        //           activeTab = tabShippingDetails();
                                        //         })),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                  ),
                                ],
                              ),
                              height: 60,
                            ),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: ThemeColor.get(context).background,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? wsBoxShadow()
                                      : null,
                                ),
                                padding:
                                    EdgeInsets.only(left: 8, right: 8, top: 8),
                                margin: EdgeInsets.only(top: 8),
                                child: (activeTab ?? tabBillingDetails())),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 160,
                      child: Column(
                        children: <Widget>[
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: <Widget>[
                          //     Text(
                          //       trans("Ship to a different address?"),
                          //       style: Theme.of(context).textTheme.bodyMedium,
                          //     ),
                          //     Checkbox(
                          //       value: _hasDifferentShippingAddress,
                          //       onChanged: _onChangeShipping,
                          //     )
                          //   ],
                          // ),
                          if (_wpLoginEnabled == true)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  trans("Remember my details"),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Checkbox(
                                  activeColor:
                                      ThemeColor.get(context).primaryAccent,
                                  value: valRememberDetails,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      valRememberDetails = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          AccentButton(
                            title: trans("USE DETAILS"),
                            action: _useDetailsTapped,
                            isLoading: isLocked('update_shipping'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  _useDetailsTapped() async {
    await lockRelease('update_shipping', perform: () async {
      CustomerAddress customerBillingAddress = _setCustomerAddress(
        firstName: _txtBillingFirstName.text,
        lastName: _txtBillingLastName.text,
        addressLine: _txtBillingAddressLine.text,
        city: _txtBillingCity.text,
        postalCode: _txtBillingPostalCode.text,
        phoneNumber: _txtBillingPhoneNumber.text,
        emailAddress: _txtBillingEmailAddress.text.trim(),
        customerCountry: _billingCountry,
      );

      CheckoutSession.getInstance.billingDetails!.shippingAddress =
          customerBillingAddress;
      CheckoutSession.getInstance.billingDetails!.billingAddress =
          customerBillingAddress;

      if (_hasDifferentShippingAddress == true) {
        CustomerAddress customerShippingAddress = _setCustomerAddress(
            firstName: _txtShippingFirstName.text,
            lastName: _txtShippingLastName.text,
            addressLine: _txtShippingAddressLine.text,
            city: _txtShippingCity.text,
            postalCode: _txtShippingPostalCode.text,
            emailAddress: _txtShippingEmailAddress.text.trim(),
            customerCountry: _shippingCountry);

        if (customerShippingAddress.hasMissingFields()) {
          showToastNotification(
            context,
            title: trans("Oops"),
            description: trans(
                "Invalid shipping address, please check your shipping details"),
            style: ToastNotificationStyleType.WARNING,
          );
          return;
        }

        CheckoutSession.getInstance.billingDetails!.shippingAddress =
            customerShippingAddress;
      }

      BillingDetails billingDetails =
          CheckoutSession.getInstance.billingDetails!;

      // Email validation
      String billingEmail = billingDetails.billingAddress!.emailAddress!;
      String shippingEmail = billingDetails.shippingAddress!.emailAddress!;
      // Billing email is required for Stripe
      if (billingEmail.isEmpty || !validate.isEmail(billingEmail)) {
        showToastNotification(
          context,
          title: trans("Oops"),
          description: trans("Please enter a valid billing email"),
          style: ToastNotificationStyleType.WARNING,
        );
        return;
      }

      if (shippingEmail.isNotEmpty && !validate.isEmail(shippingEmail)) {
        showToastNotification(
          context,
          title: trans("Oops"),
          description: trans("Please enter a valid shipping email"),
          style: ToastNotificationStyleType.WARNING,
        );
        return;
      }

      // Update WP shipping info for user
      if (_wpLoginEnabled == true) {
        String? userToken = await readAuthToken();

        try {
          await WPJsonAPI.instance.api(
            (request) => request.wpUpdateUserInfo(userToken, metaData: [
              ...?billingDetails.billingAddress?.toUserMetaDataItem('billing'),
              ...?billingDetails.shippingAddress
                  ?.toUserMetaDataItem('shipping'),
            ]),
          );
        } on Exception catch (e) {
          showToastNotification(context,
              title: trans("Oops!"),
              description: trans("Something went wrong"),
              style: ToastNotificationStyleType.DANGER);
          if (getEnv('APP_DEBUG', defaultValue: true) == true) {
            NyLogger.error(e.toString());
          }
        }
      }

      if (valRememberDetails == true) {
        await CheckoutSession.getInstance.saveBillingAddress();
        await CheckoutSession.getInstance.saveShippingAddress();
      } else {
        await CheckoutSession.getInstance.clearBillingAddress();
        await CheckoutSession.getInstance.clearShippingAddress();
      }

      CheckoutSession.getInstance.billingDetails!.rememberDetails =
          valRememberDetails;
      CheckoutSession.getInstance.shipToDifferentAddress =
          _hasDifferentShippingAddress;

      CheckoutSession.getInstance.shippingType = null;
      Navigator.pop(context);
    });
  }

  _onChangeShipping(bool? value) async {
    _hasDifferentShippingAddress = value;
    activeTabIndex = 1;
    activeTab = value == true ? tabShippingDetails() : tabBillingDetails();

    CustomerAddress? sfCustomerShippingAddress =
        await CheckoutSession.getInstance.getShippingAddress();
    if (sfCustomerShippingAddress == null) {
      _setFields(
          firstName: "",
          lastName: "",
          addressLine: "",
          city: "",
          postalCode: "",
          phoneNumber: "",
          emailAddress: "",
          customerCountry: CustomerCountry());
    }
    setState(() {});
  }

  CustomerAddress _setCustomerAddress(
      {required String firstName,
      required String lastName,
      required String addressLine,
      required String city,
      required String postalCode,
      required String emailAddress,
      String? phoneNumber,
      required CustomerCountry? customerCountry}) {
    CustomerAddress customerShippingAddress = CustomerAddress();
    customerShippingAddress.firstName = firstName;
    customerShippingAddress.lastName = lastName;
    customerShippingAddress.addressLine = addressLine;
    customerShippingAddress.city = city;
    customerShippingAddress.postalCode = postalCode;
    if (phoneNumber != null && phoneNumber != "") {
      customerShippingAddress.phoneNumber = phoneNumber;
    }
    customerShippingAddress.customerCountry = customerCountry;
    customerShippingAddress.emailAddress = emailAddress;
    return customerShippingAddress;
  }

  _navigateToSelectCountry({required String type}) {
    Navigator.pushNamed(context, "/customer-countries").then((value) {
      if (value == null) {
        return;
      }
      if (type == "billing") {
        _billingCountry = CustomerCountry.fromDefaultShipping(
            defaultShipping: value as DefaultShipping);
        activeTab = tabBillingDetails();
      } else if (type == "shipping") {
        _shippingCountry = CustomerCountry.fromDefaultShipping(
            defaultShipping: value as DefaultShipping);
        activeTab = tabShippingDetails();
      }
      setState(() {});
    });
  }

  _fetchUserDetails() async {
    await lockRelease('load_shipping_info', perform: () async {
      String? userToken = await readAuthToken();

      WPUserInfoResponse? wpUserInfoResponse;
      try {
        wpUserInfoResponse = await WPJsonAPI.instance
            .api((request) => request.wpGetUserInfo(userToken!));
      } on Exception catch (e) {
        print(e.toString());
        showToastNotification(
          context,
          title: trans("Oops!"),
          description: trans("Something went wrong"),
          style: ToastNotificationStyleType.DANGER,
        );
        Navigator.pop(context);
      }

      if (wpUserInfoResponse != null && wpUserInfoResponse.status == 200) {
        BillingDetails billingDetails =
            await billingDetailsFromWpUserInfoResponse(wpUserInfoResponse);

        _setFieldsFromCustomerAddress(billingDetails.shippingAddress,
            type: "shipping");
        _setFieldsFromCustomerAddress(billingDetails.billingAddress,
            type: "billing");

        setState(() {});
      }
    });
  }
}
