//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/bootstrap/shared_pref/sp_auth.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:wp_json_api/models/responses/wp_user_info_response.dart';
import 'package:wp_json_api/models/responses/wp_user_info_updated_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountProfileUpdatePage extends NyStatefulWidget {
  static String path = "/account-update";

  AccountProfileUpdatePage()
      : super(AccountProfileUpdatePage.path,
            child: _AccountProfileUpdatePageState());
}

class _AccountProfileUpdatePageState extends NyState<AccountProfileUpdatePage> {
  _AccountProfileUpdatePageState();

  // bool isLoading = true;
  final TextEditingController _tfFirstName = TextEditingController(),
      _tfLastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  _fetchUserDetails() async {
    WPUserInfoResponse wpUserInfoResponse =
        await WPJsonAPI.instance.api((request) async {
      return request.wpGetUserInfo((await readAuthToken()) ?? "0");
    });

    _tfFirstName.text = wpUserInfoResponse.data!.firstName!;
    _tfLastName.text = wpUserInfoResponse.data!.lastName!;
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            trans("Update Details"),
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: afterLoad(
            child: () => SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextEditingRow(
                                        heading: trans("First Name"),
                                        controller: _tfFirstName,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                    Flexible(
                                      child: TextEditingRow(
                                        heading: trans("Last Name"),
                                        controller: _tfLastName,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              AccentButton(
                                title: trans("Update Details"),
                                isLoading: isLoading(),
                                action: _updateDetails,
                              )
                            ],
                          ),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                )));
  }

  _updateDetails() async {
    String firstName = _tfFirstName.text;
    String lastName = _tfLastName.text;

    String? userToken = await readAuthToken();
    WPUserInfoUpdatedResponse? wpUserInfoUpdatedResponse;
    try {
      wpUserInfoUpdatedResponse = await WPJsonAPI.instance.api((request) =>
          request.wpUpdateUserInfo(userToken,
              firstName: firstName, lastName: lastName));
    } on Exception catch (_) {
      showToastNotification(context,
          title: trans("Invalid details"),
          description: trans("Please check your email and password"),
          style: ToastNotificationStyleType.DANGER);
    }

    if (wpUserInfoUpdatedResponse?.status == 200) return;

    showToastNotification(context,
        title: trans("Success"),
        description: trans("Account updated"),
        style: ToastNotificationStyleType.SUCCESS);
    Navigator.pop(context);
  }
}
