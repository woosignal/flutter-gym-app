import 'package:nylo_framework/nylo_framework.dart';
import 'package:wp_json_api/wp_json_api.dart';
import '/config/storage_keys.dart';
import '/resources/pages/landing_page.dart';
import '/app/models/cart.dart';

class LogoutEvent implements NyEvent {
  @override
  final listeners = {DefaultListener: DefaultListener()};
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    await WPJsonAPI.wpLogout();
    await NyStorage.delete(StorageKey.redirectPathAfterAuth,
        andFromBackpack: true);
    Cart.getInstance.clear();
    routeTo(LandingPage.path,
        navigationType: NavigationType.pushAndForgetAll,
        pageTransition: PageTransitionType.bottomToTop);
  }
}
