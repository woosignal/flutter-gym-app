import '/app/controllers/book_a_class_controller.dart';
import '/app/controllers/profile_controller.dart';
import '/app/controllers/dashboard_controller.dart';
import '/app/controllers/login_controller.dart';
import '/app/controllers/register_controller.dart';
import '/app/models/user.dart';
import '/app/controllers/account_order_detail_controller.dart';
import '/app/controllers/checkout_status_controller.dart';
import '/app/networking/api_service.dart';

/*
|--------------------------------------------------------------------------
| Model Decoders
| -------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models. Learn more https://nylo.dev/docs/5.20.0/decoders#model-decoders
|--------------------------------------------------------------------------
*/

final Map<Type, dynamic> modelDecoders = {
  // ...
  User: (data) => User.fromJson(data),
};

/*
|--------------------------------------------------------------------------
| API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
| Learn more https://nylo.dev/docs/5.20.0/decoders#api-decoders
|--------------------------------------------------------------------------
*/

final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),
};

/*
|--------------------------------------------------------------------------
| Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
| E.g. NyPage<MyController>
|
| Learn more https://nylo.dev/docs/5.20.0/controllers#using-controllers-with-ny-page
|--------------------------------------------------------------------------
*/
final Map<Type, dynamic> controllers = {
  AccountOrderDetailController: () => AccountOrderDetailController(),
  CheckoutStatusController: () => CheckoutStatusController(),
  RegisterController: () => RegisterController(),
  LoginController:  LoginController(),
  DashboardController: () => DashboardController(),
  ProfileController: () => ProfileController(),
  BookAClassController: () => BookAClassController(),
};
