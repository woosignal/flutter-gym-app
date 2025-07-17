import 'package:nylo_framework/nylo_framework.dart';

import '/config/keys.dart';
import '/app/models/cart.dart';

class LogoutEvent implements NyEvent {
  @override
  final listeners = {DefaultListener: DefaultListener()};
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    await Auth.logout();
    await NyStorage.delete(Keys.userType,
        andFromBackpack: true);
    Cart.getInstance.clear();
    routeToInitial(pageTransitionType: PageTransitionType.bottomToTop);
  }
}
