import 'package:nylo_framework/nylo_framework.dart';

import '/bootstrap/shared_pref/shared_key.dart';
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
    await Auth.remove(key: SharedKey.authUser);
    await NyStorage.delete(SharedKey.authUser, andFromBackpack: true);
    await NyStorage.delete(StorageKey.redirectPathAfterAuth,
        andFromBackpack: true);
    Cart.getInstance.clear();
    routeTo(LandingPage.path,
        navigationType: NavigationType.pushAndForgetAll,
        pageTransition: PageTransitionType.bottomToTop);
  }
}
