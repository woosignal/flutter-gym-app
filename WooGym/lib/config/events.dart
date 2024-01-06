import '/app/events/add_to_calendar_event.dart';
import '/app/events/add_to_cart_event.dart';
import '/app/events/login_event.dart';
import '/app/events/logout_event.dart';
import '/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| Events
| Add your "app/events" here.
| Events can be fired using: event<MyEvent>();
|
| Learn more: https://nylo.dev/docs/5.x/events
|--------------------------------------------------------------------------
*/

final Map<Type, NyEvent> events = {
  LoginEvent: LoginEvent(),
  LogoutEvent: LogoutEvent(),
  AuthUserEvent: AuthUserEvent(),
  SyncAuthToBackpackEvent: SyncAuthToBackpackEvent<User>(),
  AddToCartEvent: AddToCartEvent(),
  AddToCalendarEvent: AddToCalendarEvent(),
};
