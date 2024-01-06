import 'package:flutter/material.dart';
import '/bootstrap/app_helper.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller.dart';

class DashboardController extends Controller {
  final AppHelper _appHelper = AppHelper.instance;

  /// Show the location on Google Maps
  showLocationOnGoogleMaps() async {
    await launchUrl(Uri.parse(getEnv('GYM_LOCATION')));
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
        context: context!,
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
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text("Call us".tr()),
                          onTap: () async => await _launchPhoneCall(
                              getEnv('GYM_PHONE_NUMBER')),
                        ),
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
