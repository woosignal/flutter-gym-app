import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/order.dart';
import '/bootstrap/helpers.dart';

class AddToCalendarEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    Order order = event['order'] as Order;

    final Event eventCalendar = Event(
      title: "${order.lineItems?.first.name} with ${order.instructor}",
      description: 'Gym class at ${order.gym}',
      location: '${order.gym}',
      startDate: order.classTime,
      endDate: order.classTime.add(Duration(hours: 1)),
      iosParams: IOSParams(
        reminder: Duration(hours: 1),
      ),
    );

    Add2Calendar.addEvent2Cal(eventCalendar);
  }
}
