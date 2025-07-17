import 'package:flutter_app/config/keys.dart';

import '/resources/pages/not_found_page.dart';
import '/resources/pages/account_detail_orders_page.dart';
import '/resources/pages/admin_class_detail_page.dart';
import '/resources/pages/admin_dashboard_page.dart';
import '/resources/pages/book_a_class_page.dart';
import '/resources/pages/dashboard_page.dart';
import '/resources/pages/profile_page.dart';
import '/resources/pages/landing_page.dart';
import '/resources/pages/login_page.dart';
import '/resources/pages/account_order_detail_page.dart';
import '/resources/pages/account_profile_update_page.dart';
import '/resources/pages/register_page.dart';
import '/resources/pages/account_shipping_details_page.dart';
import '/resources/pages/checkout_confirmation_page.dart';
import '/resources/pages/checkout_details_page.dart';
import '/resources/pages/checkout_payment_type_page.dart';
import '/resources/pages/checkout_shipping_type_page.dart';
import '/resources/pages/checkout_status_page.dart';
import '/resources/pages/coupon_page.dart';
import '/resources/pages/customer_countries_page.dart';
import '/resources/pages/no_connection_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
|
| * [Tip] Add authentication 🔑
| Run the below in the terminal to add authentication to your project.
| "dart run scaffold_ui:main auth"
|
| Learn more https://nylo.dev/docs/6.x/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
  // User section
  router.add(LandingPage.path).initialRoute();

  router.add(ProfilePage.path);

  router.add(DashboardPage.path).authenticatedRoute(when: () {
    return Backpack.instance.read(Keys.userType) == "user";
  });

  router.add(BookAClassPage.path);

  router.add(AdminDashboardPage.path).authenticatedRoute(when: () {
    return Backpack.instance.read(Keys.userType) == "admin";
  });

  router.add(AdminClassDetailPage.path);

  // Checkout Section
  router.add(CheckoutConfirmationPage.path);

  router.add(
      AccountOrderDetailPage.path);

  router.add(CheckoutStatusPage.path);

  router.add(CheckoutDetailsPage.path,
      transition: PageTransitionType.bottomToTop);

  router.add(
      CheckoutPaymentTypePage.path,
      transition: PageTransitionType.bottomToTop);

  router.add(CheckoutShippingTypePage.path,
      transition: PageTransitionType.bottomToTop);

  router.add(CouponPage.path,
      transition: PageTransitionType.bottomToTop);

  router.add(
      CustomerCountriesPage.path,
      transition: PageTransitionType.bottomToTop);

  router.add(NoConnectionPage.path);

  // Account Section

  router.add(LoginPage.path);

  router.add(
      RegisterPage.path);

  router.add(
      AccountProfileUpdatePage.path);

  router.add(
      AccountShippingDetailsPage.path);

  router.add(
      AccountDetailOrdersPage.path);

      router.add(NotFoundPage.path).unknownRoute();
    });
