//  WooGym
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/resources/pages/login_page.dart';
import '/resources/pages/register_page.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/safearea_widget.dart';
import '/resources/widgets/video_background_player_widget.dart';
import '/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import '/bootstrap/app_helper.dart';

class LandingPage extends NyStatefulWidget {
  static const path = '/landing';

  LandingPage({Key? key}) : super(path, key: key, child: _LandingPageState());
}

class _LandingPageState extends NyState<LandingPage> {
  WooSignalApp wooSignalApp = AppHelper.instance.appConfig!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            VideoBackgroundPlayerWidget(
              color: Colors.tealAccent,
              opacity: 0.7,
            ).faderBottom(5, color: Colors.teal),
            SafeAreaWidget(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StoreLogo(
                        color: Colors.white,
                      ).paddingOnly(bottom: 20),
                      Text(
                              "Welcome to {{name}}".tr(arguments: {
                                "name": wooSignalApp.appName ?? "WooGym"
                              }),
                              style: textTheme.headlineLarge!
                                  .copyWith(color: Colors.white))
                          .fontWeightBold()
                          .paddingOnly(bottom: 20),
                      Text("Let's get started!".tr(),
                              style: textTheme.headlineSmall!
                                  .copyWith(color: Colors.white))
                          .paddingOnly(bottom: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryButton(
                            action: () => routeTo(LoginPage.path),
                            title: 'Login'.tr().toUpperCase(),
                          ).flexible(),
                          PrimaryButton(
                            action: () => routeTo(RegisterPage.path),
                            title: 'Register'.tr().toUpperCase(),
                          ).flexible(),
                        ],
                      ).withGap(20)
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: Duration(seconds: 1)),
          ],
        ),
      ),
    );
  }
}
