import 'package:flutter_app/bootstrap/app_helper.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/pages/landing_page.dart';
import 'package:flutter_app/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RouteProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    nylo.addRouter(appRouter());

    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    String initialRoute = AppHelper.instance.appConfig!.appStatus != null
        ? '/home'
        : '/no-connection';

    if (initialRoute == '/no-connection') {
      nylo.setInitialRoute(LandingPage.path);
      return;
    }

    String? redirectPath =
        await NyStorage.read(StorageKey.redirectPathAfterAuth);
    if ((await Auth.loggedIn()) == false) {
      redirectPath = null;
      await NyStorage.delete(StorageKey.redirectPathAfterAuth);
    }
    if (redirectPath != null) {
      nylo.setInitialRoute(redirectPath);
    } else {
      nylo.setInitialRoute(LandingPage.path);
    }
  }
}
