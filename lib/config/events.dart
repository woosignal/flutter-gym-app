import '/app/events/logout_event.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Events
|--------------------------------------------------------------------------
| Add your "app/events" here.
| Events can be fired using: event<MyEvent>();
|
| Learn more: https://nylo.dev/docs/6.x/events
|-------------------------------------------------------------------------- */

final Map<Type, NyEvent> events = {
  LogoutEvent: LogoutEvent(),
};
