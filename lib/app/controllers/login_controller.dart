import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:wp_json_api/models/responses/wp_user_info_response.dart';
import 'package:wp_json_api/models/responses/wp_user_login_response.dart';
import 'package:wp_json_api/wp_json_api.dart' as wp;
import 'package:wp_json_api/models/responses/wp_user_info_response.dart' as wp;

import '/config/keys.dart';
import '/resources/pages/admin_dashboard_page.dart';
import '/resources/pages/dashboard_page.dart';
import '/app/models/user.dart';
import 'controller.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:wp_json_api/exceptions/incorrect_password_exception.dart';
import 'package:wp_json_api/exceptions/invalid_email_exception.dart';
import 'package:wp_json_api/exceptions/invalid_nonce_exception.dart';
import 'package:wp_json_api/exceptions/invalid_username_exception.dart';

class LoginController extends Controller {
  final TextEditingController tfEmailController = TextEditingController(),
      tfPasswordController = TextEditingController();

  loginUser() async {
    String email = tfEmailController.text, password = tfPasswordController.text;

    validate(
        rules: {
          "email": [email, "email"],
          "password": [password, "not_empty"]
        },
        onSuccess: () async {
          WPUserLoginResponse? wpUserLoginResponse;
          try {
            wpUserLoginResponse = await wp.WPJsonAPI.instance.api(
                (request) => request.wpLogin(email: email, password: password));
          } on InvalidNonceException catch (_) {
            showToastNotification(context!,
                title: trans("Invalid details"),
                description:
                    trans("Something went wrong, please contact our store"),
                style: ToastNotificationStyleType.danger);
          } on InvalidEmailException catch (_) {
            showToastNotification(context!,
                title: trans("Invalid details"),
                description: trans("That email does not match our records"),
                style: ToastNotificationStyleType.danger);
          } on InvalidUsernameException catch (_) {
            showToastNotification(context!,
                title: trans("Invalid details"),
                description: trans("That username does not match our records"),
                style: ToastNotificationStyleType.danger);
          } on IncorrectPasswordException catch (_) {
            showToastNotification(context!,
                title: trans("Invalid details"),
                description: trans("That password does not match our records"),
                style: ToastNotificationStyleType.danger);
          } on Exception catch (_) {
            showToastNotification(context!,
                title: trans("Oops!"),
                description: trans("Invalid login credentials"),
                style: ToastNotificationStyleType.danger,
                icon: Icons.account_circle);
          }

          if (wpUserLoginResponse == null) {
            return;
          }

          if (wpUserLoginResponse.status != 200) {
            return;
          }

          String? token = wpUserLoginResponse.data!.userToken;
          String userId = wpUserLoginResponse.data!.userId.toString();
          User user = User.fromUserAuthResponse(token: token, userId: userId);

          WPUserInfoResponse wpUserInfoResponse = await wp.WPJsonAPI.instance
              .api((request) => request.wpGetUserInfo());
          wp.MetaData? meta = (wpUserInfoResponse.data?.metaData ?? [])
              .firstWhereOrNull((element) => element.key == 'app_admin');

          await Auth.authenticate(data: user.toJson());

          if (meta == null) {
            await NyStorage.save(Keys.userType, 'USER');
            routeTo(DashboardPage.path);
            return;
          }

          if (meta.value?.first == "1") {
            await NyStorage.save(Keys.userType, 'admin');
            routeTo(AdminDashboardPage.path,
                navigationType: NavigationType.pushAndForgetAll);
          } else {
            await NyStorage.save(Keys.userType, 'user');
            routeTo(DashboardPage.path,
                navigationType: NavigationType.pushAndForgetAll);
          }
        },
        lockRelease: "login");
  }
}
