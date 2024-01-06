import '/app/events/logout_event.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:wp_json_api/models/responses/wp_user_delete_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import '/bootstrap/shared_pref/sp_auth.dart';
import 'controller.dart';

class ProfileController extends Controller {
  final WooSignalApp? wooSignalApp = AppHelper.instance.appConfig;

  _wpDeleteAccount() async {
    lockRelease('delete_account', perform: () async {
      String? userToken = await readAuthToken();

      WPUserDeleteResponse? wpUserDeleteResponse;
      try {
        wpUserDeleteResponse = await WPJsonAPI.instance
            .api((request) => request.wpUserDelete(userToken));
      } on Exception catch (e) {
        NyLogger.error(e.toString());
        showToastNotification(
          context!,
          title: trans("Oops!"),
          description: trans("Something went wrong"),
          style: ToastNotificationStyleType.DANGER,
        );
      }

      if (wpUserDeleteResponse != null) {
        showToastSuccess(description: trans("Account deleted"));
        await event<LogoutEvent>();
      }
    });
  }

  deleteAccount() {
    confirmAction(() async {
      await _wpDeleteAccount();
    }, title: "Delete Account".tr());
  }

  logout() {
    confirmAction(() async => await event<LogoutEvent>(), title: "Logout".tr());
  }

  void showTermsAndConditions() {
    openBrowserTab(url: wooSignalApp!.appTermsLink!);
  }

  void showPrivacyPolicy() {
    openBrowserTab(url: wooSignalApp!.appPrivacyLink!);
  }
}
