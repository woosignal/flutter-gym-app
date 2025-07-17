//  WooGym
//
//  Created by Anthony Gordon.
//  2025, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/controllers/profile_controller.dart';
import '/bootstrap/helpers.dart';
import '/resources/pages/account_detail_orders_page.dart';
import '/resources/pages/account_profile_update_page.dart';
import '/resources/themes/styles/color_styles.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:wp_json_api/models/responses/wp_user_info_response.dart';

class ProfilePage extends NyStatefulWidget<ProfileController> {
  static RouteView path = ("/profile", (_) => ProfilePage());

  ProfilePage() : super(child: () => _ProfilePageState());
}

class _ProfilePageState extends NyPage<ProfilePage> {
  WPUserInfoResponse? wpUserInfoResponse;

  @override
  get init => () async {
    wpUserInfoResponse = await wpFetchUserDetails();
  };

  @override
  Widget view(BuildContext context) {
    ColorStyles color = ThemeColor.get(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile".tr()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: ListTile.divideTiles(
              context: context,
              color: Colors.grey.shade200,
              tiles: [
                Icon(
                  Icons.person,
                  size: 100,
                  color: color.primaryAccent,
                ),
                ListTile(
                  title: Text("Account Details".tr()).fontWeightBold(),
                  subtitle: Text("View your account details".tr()),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => routeTo(AccountProfileUpdatePage.path),
                ),
                ListTile(
                  title: Text("Account Orders".tr()).fontWeightBold(),
                  subtitle: Text("View your orders".tr()),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => routeTo(AccountDetailOrdersPage.path),
                ),
                ListTile(
                  title: Text("Terms and conditions".tr()).fontWeightBold(),
                  subtitle: Text("View terms and conditions".tr()),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: widget.controller.showTermsAndConditions,
                ),
                ListTile(
                  title: Text("Privacy policy".tr()).fontWeightBold(),
                  subtitle: Text("View privacy policy".tr()),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: widget.controller.showPrivacyPolicy,
                ),
                ListTile(
                  title: Text("Logout".tr()).fontWeightBold(),
                  subtitle: Text("Logout from your account".tr()),
                  onTap: widget.controller.logout,
                ),
                ListTile(
                  title: Text("Delete Account".tr()).fontWeightBold(),
                  subtitle: Text("Delete your account".tr()),
                  onTap: widget.controller.deleteAccount,
                ),
              ]).toList(),
        ),
      ),
    );
  }
}
