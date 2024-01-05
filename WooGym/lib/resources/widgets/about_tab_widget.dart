//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/app_helper.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_version_widget.dart';

class AboutTab extends StatefulWidget {
  AboutTab({super.key});

  static String state = "about_tab";

  @override
  AboutTabState createState() => AboutTabState();
}

class AboutTabState extends NyState<AboutTab> {
  AboutTabState() {
    stateName = AboutTab.state;
  }

  @override
  stateUpdated(dynamic data) async {}

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: ListTile.divideTiles(
          context: context,
          color: Colors.grey.shade100,
          tiles: [
            ListTile(
              title: Text("Location".tr()).fontWeightBold(),
              subtitle: Text("Find us on Google Maps".tr()),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: showLocationOnGoogleMaps,
            ),
            ListTile(
              title: Text("Website".tr()).fontWeightBold(),
              subtitle: Text("Check out our website".tr()),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: showWebsite,
            ),
            ListTile(
              title: Text("Contact us".tr()).fontWeightBold(),
              subtitle: Text("Got a question? Get in touch".tr()),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: showContactUsModal,
            ),
            AppVersionWidget().paddingOnly(left: 16, top: 16, bottom: 8),
          ]).toList(),
    );
  }

  AppHelper get _appHelper => AppHelper.instance;

  /// Show the location on Google Maps
  showLocationOnGoogleMaps() async {
    await launchUrl(Uri.parse("https://maps.app.goo.gl/Hb8M8rCpmW8gQXRq9"));
  }

  /// Show the website
  showWebsite() async {
    if (_appHelper.appConfig?.wpLoginBaseUrl == null) {
      NyLogger.debug("Your app base url is not set");
      return;
    }
    await launchUrl(Uri.parse(_appHelper.appConfig!.wpLoginBaseUrl!));
  }

  /// Show the contact us modal
  showContactUsModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              height: 150,
              padding: EdgeInsets.only(top: 16),
              child: ListView(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  children: ListTile.divideTiles(
                      context: context,
                      color: Colors.grey.shade300,
                      tiles: [
                        if (getEnv('GYM_CONTACT_NUMBER') != null)
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Call us".tr()),
                            onTap: () async => await _launchPhoneCall(
                                getEnv('GYM_CONTACT_NUMBER')),
                          ),
                        if (getEnv('GYM_EMAIL_ADDRESS') != null)
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Email us".tr()),
                            onTap: () async =>
                                await _launchEmail(getEnv('GYM_EMAIL_ADDRESS')),
                          ),
                      ]).toList()),
            ),
          );
        });
  }

  _launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  _launchEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }
}
