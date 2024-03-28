import 'package:flutter_app/resources/pages/dashboard_page.dart';
import 'package:flutter_app/resources/pages/no_connection_page.dart';
import 'package:wp_json_api/wp_json_api.dart';

import '/bootstrap/app_helper.dart';
import '/config/storage_keys.dart';
import '/resources/pages/landing_page.dart';
import '/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RouteProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    nylo.addRouter(appRouter());

    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    if (AppHelper.instance.appConfig!.appStatus == null) {
      nylo.setInitialRoute(NoConnectionPage.path);
      return;
    }

    String? redirectPath =
    await NyStorage.read(StorageKey.redirectPathAfterAuth);

    if (redirectPath != null) {
      nylo.setInitialRoute(redirectPath);
      return;
    }

    if (await Auth.loggedIn(key: WPJsonAPI.storageKey())) {
      nylo.setInitialRoute(DashboardPage.path);
      return;
    }

    nylo.setInitialRoute(LandingPage.path);
  }
}
