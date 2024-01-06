//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/controllers/login_controller.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/safearea_widget.dart';
import '/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AccountLandingPage extends NyStatefulWidget<LoginController> {
  static const String path = "/login";
  AccountLandingPage() : super(path, child: _AccountLandingPageState());
}

class _AccountLandingPageState extends NyState<AccountLandingPage> {
  @override
  Widget build(BuildContext context) {
    ColorStyles color = ThemeColor.get(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeAreaWidget(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StoreLogo(),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Email'.tr(),
                  ),
                  NyTextField(
                    cursorColor: color.primaryAccent,
                    controller: widget.controller.tfEmailController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color.primaryAccent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color.primaryAccent),
                      ),
                    ),
                    validationRules: "email",
                    dummyData: "",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Password'.tr(),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  NyTextField(
                    cursorColor: color.primaryAccent,
                    controller: widget.controller.tfPasswordController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color.primaryAccent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color.primaryAccent),
                      ),
                    ),
                    obscureText: true,
                    dummyData: "",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SecondaryButton(
                    action: widget.controller.loginUser,
                    title: 'Login'.tr(),
                    isLoading: isLocked('login'),
                  ),
                  TextButton(
                    onPressed: () {
                      String? forgotPasswordUrl = AppHelper
                          .instance.appConfig!.wpLoginForgotPasswordUrl;
                      if (forgotPasswordUrl != null) {
                        openBrowserTab(url: forgotPasswordUrl);
                      } else {
                        NyLogger.info(
                            "No URL found for \"forgot password\".\nAdd your forgot password URL here https://woosignal.com/dashboard/apps");
                      }
                    },
                    child: Text(
                      'Forgotten your password?'.tr(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
