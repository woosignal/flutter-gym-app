import 'package:flutter/material.dart';
import '/bootstrap/app_helper.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import '/config/storage_keys.dart';
import '/resources/pages/dashboard_page.dart';
import 'package:wp_json_api/exceptions/empty_username_exception.dart';
import 'package:wp_json_api/exceptions/existing_user_email_exception.dart';
import 'package:wp_json_api/exceptions/existing_user_login_exception.dart';
import 'package:wp_json_api/exceptions/invalid_nonce_exception.dart';
import 'package:wp_json_api/exceptions/user_already_exist_exception.dart';
import 'package:wp_json_api/exceptions/username_taken_exception.dart';
import 'package:wp_json_api/models/responses/wp_user_register_response.dart';
import 'package:wp_json_api/wp_json_api.dart';
import '/bootstrap/helpers.dart';
import 'controller.dart';

class RegisterController extends Controller {
  final WooSignalApp? wooSignalApp = AppHelper.instance.appConfig;

  final TextEditingController tfEmailAddressController =
          TextEditingController(),
      tfPasswordController = TextEditingController(),
      tfFirstNameController = TextEditingController(),
      tfLastNameController = TextEditingController();

  bool termsAndConditionsAccepted = false;

  @override
  construct(BuildContext context) {
    super.construct(context);

    termsAndConditionsAccepted = false;
  }

  signUpTapped() async {
    if (context == null) return;

    String email = tfEmailAddressController.text,
        password = tfPasswordController.text,
        firstName = tfFirstNameController.text,
        lastName = tfLastNameController.text;

    if (email.isNotEmpty) {
      email = email.trim();
    }

    validate(
        rules: {
          "terms and conditions": [
            termsAndConditionsAccepted,
            "is_true",
            "Invalid|Please read and accept the terms and conditions"
          ],
          "first name": [firstName, "not_empty|min:3"],
          "last name": [lastName, "not_empty|min:3"],
          "email": [email, "email"],
          "password": [password, "min:6"],
        },
        onSuccess: () async {
          WPUserRegisterResponse? wpUserRegisterResponse;
          try {
            wpUserRegisterResponse = await WPJsonAPI.instance.api(
              (request) => request.wcRegister(
                email: email.toLowerCase(),
                password: password,
                args: {
                  "first_name": firstName,
                  "last_name": lastName,
                }
              ),
            );

          } on UsernameTakenException catch (e) {
            showToastNotification(context!,
                title: trans("Oops!"),
                description: trans(e.message),
                style: ToastNotificationStyleType.DANGER);
          } on InvalidNonceException catch (_) {
            showToastNotification(context!,
                title: trans("Invalid details"),
                description:
                    trans("Something went wrong, please contact our store"),
                style: ToastNotificationStyleType.DANGER);
          } on ExistingUserLoginException catch (_) {
            showToastNotification(context!,
                title: trans("Oops!"),
                description: trans("A user already exists"),
                style: ToastNotificationStyleType.DANGER);
          } on ExistingUserEmailException catch (_) {
            showToastNotification(context!,
                title: trans("Oops!"),
                description: trans("That email is taken, try another"),
                style: ToastNotificationStyleType.DANGER);
          } on UserAlreadyExistException catch (_) {
            showToastNotification(context!,
                title: trans("Oops!"),
                description: trans("A user already exists"),
                style: ToastNotificationStyleType.DANGER);
          } on EmptyUsernameException catch (e) {
            showToastNotification(context!,
                title: trans("Oops!"),
                description: trans(e.message),
                style: ToastNotificationStyleType.DANGER);
          } on Exception catch (_) {
            showToastNotification(context!,
                title: trans("Oops!"),
                description: trans("Something went wrong"),
                style: ToastNotificationStyleType.DANGER);
          }

          if (wpUserRegisterResponse == null) {
            return;
          }

          if (wpUserRegisterResponse.status != 200) {
            return;
          }

          String redirectPath = DashboardPage.path;
          await NyStorage.store(StorageKey.redirectPathAfterAuth, redirectPath);

          routeTo(DashboardPage.path,
              navigationType: NavigationType.pushAndForgetAll);
        },
        lockRelease: 'register_user');
  }

  viewTOSModal() async {
    if (context == null) return;
    await showDialog(
      context: context!,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColor.get(context).background,
        title: Text(trans("Actions")),
        content: Text(trans("View Terms and Conditions or Privacy policy")),
        actions: <Widget>[
          MaterialButton(
            onPressed: () async {
              pop();
              showTermsAndConditions();
            },
            child: Text(trans("Terms and Conditions")),
          ),
          MaterialButton(
            onPressed: () {
              pop();
              showPrivacyPolicy();
            },
            child: Text(trans("Privacy Policy")),
          ),
          Divider(
            color: Colors.grey.shade50,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'.tr()),
          ),
        ],
      ),
    );
  }

  void showTermsAndConditions() {
    openBrowserTab(url: wooSignalApp!.appTermsLink!);
  }

  void showPrivacyPolicy() {
    openBrowserTab(url: wooSignalApp!.appPrivacyLink!);
  }
}
