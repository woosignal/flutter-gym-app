import '/app/controllers/book_a_class_controller.dart';
import '/app/controllers/profile_controller.dart';
import '/app/controllers/dashboard_controller.dart';
import '/app/controllers/login_controller.dart';
import '/app/controllers/register_controller.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/networking/wp_api_service.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/controllers/account_order_detail_controller.dart';
import 'package:flutter_app/app/controllers/checkout_status_controller.dart';
import '/app/models/boxing_event.dart';
import 'package:flutter_app/app/networking/api_service.dart';

/*
|--------------------------------------------------------------------------
| Model Decoders
| -------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models. Learn more https://nylo.dev/docs/5.x/decoders#model-decoders
|--------------------------------------------------------------------------
*/

final Map<Type, dynamic> modelDecoders = {
  // ...
  User: (data) => User.fromJson(data),

  List<BoxingEvent>: (data) =>
      List.from(data).map((json) => BoxingEvent.fromJson(json)).toList(),

  BoxingEvent: (data) => BoxingEvent.fromJson(data),
};

/*
|--------------------------------------------------------------------------
| API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
| Learn more https://nylo.dev/docs/5.x/decoders#api-decoders
|--------------------------------------------------------------------------
*/

final Map<Type, NyApiService> apiDecoders = {
  ApiService: ApiService(),

  // ...

  WpApiService: WpApiService(),
};

/*
|--------------------------------------------------------------------------
| Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
| E.g. NyPage<MyController>
|
| Learn more https://nylo.dev/docs/5.x/controllers#using-controllers-with-ny-page
|--------------------------------------------------------------------------
*/
final Map<Type, BaseController Function()> controllers = {
  AccountOrderDetailController: () => AccountOrderDetailController(),
  CheckoutStatusController: () => CheckoutStatusController(),
  RegisterController: () => RegisterController(),
  LoginController: () => LoginController(),
  DashboardController: () => DashboardController(),
  ProfileController: () => ProfileController(),
  BookAClassController: () => BookAClassController(),
};
