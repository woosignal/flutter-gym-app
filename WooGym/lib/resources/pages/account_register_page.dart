//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/controllers/register_controller.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/safearea_widget.dart';
import '/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AccountRegistrationPage extends NyStatefulWidget<RegisterController> {
  static String path = "/account-register";
  AccountRegistrationPage()
      : super(path, child: _AccountRegistrationPageState());
}

class _AccountRegistrationPageState extends NyState<AccountRegistrationPage> {
  _AccountRegistrationPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeAreaWidget(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StoreLogo().paddingOnly(bottom: 10),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      TextEditingRow(
                        heading: trans("First Name"),
                        controller: widget.controller.tfFirstNameController,
                        shouldAutoFocus: true,
                        keyboardType: TextInputType.text,
                      ).flexible(),
                      TextEditingRow(
                        heading: trans("Last Name"),
                        controller: widget.controller.tfLastNameController,
                        shouldAutoFocus: false,
                        keyboardType: TextInputType.text,
                      ).flexible(),
                    ],
                  )),
              TextEditingRow(
                heading: trans("Email address"),
                controller: widget.controller.tfEmailAddressController,
                shouldAutoFocus: false,
                keyboardType: TextInputType.emailAddress,
              ),
              TextEditingRow(
                heading: trans("Password"),
                controller: widget.controller.tfPasswordController,
                shouldAutoFocus: true,
                obscureText: true,
              ),
              Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.white),
                    value: widget.controller.termsAndConditionsAccepted,
                    checkColor: ThemeColor.get(context).primaryContent,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.controller.termsAndConditionsAccepted = value!;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => BorderSide(
                          width: 1.0,
                          color: ThemeColor.get(context).primaryContent),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Accept terms and conditions".tr())
                          .onTap(widget.controller.showTermsAndConditions),
                      Text(
                        "I have read and agree to the terms and conditions"
                            .tr(),
                        maxLines: 2,
                      )
                    ],
                  )),
                ],
              ),
              Padding(
                child: SecondaryButton(
                  title: trans("Sign up"),
                  isLoading: isLocked('register_user'),
                  action: widget.controller.signUpTapped,
                ),
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                child: InkWell(
                  child: RichText(
                    text: TextSpan(
                      text:
                          '${trans("By tapping \"Register\" you agree to ")} ${AppHelper.instance.appConfig?.appName}\'s ',
                      children: <TextSpan>[
                        TextSpan(
                            text: trans("terms and conditions"),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '  ${trans("and")}  '),
                        TextSpan(
                            text: trans("privacy policy"),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                      style: TextStyle(
                          color: ThemeColor.get(context).primaryContent),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: widget.controller.viewTOSModal,
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
