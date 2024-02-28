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
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      // User section
      router.route(LandingPage.path, (_) => LandingPage());

      router.route(ProfilePage.path, (_) => ProfilePage());

      router.route(DashboardPage.path, (_) => DashboardPage());

      router.route(BookAClassPage.path, (_) => BookAClassPage());

      router.route(AdminDashboardPage.path, (_) => AdminDashboardPage());

      router.route(AdminClassDetailPage.path, (_) => AdminClassDetailPage());

      // Checkout Section
      router.route(CheckoutConfirmationPage.path,
          (context) => CheckoutConfirmationPage());

      router.route(
          AccountOrderDetailPage.path, (context) => AccountOrderDetailPage(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route(CheckoutStatusPage.path, (context) => CheckoutStatusPage(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route(CheckoutDetailsPage.path, (context) => CheckoutDetailsPage(),
          transition: PageTransitionType.bottomToTop);

      router.route(
          CheckoutPaymentTypePage.path, (context) => CheckoutPaymentTypePage(),
          transition: PageTransitionType.bottomToTop);

      router.route(CheckoutShippingTypePage.path,
          (context) => CheckoutShippingTypePage(),
          transition: PageTransitionType.bottomToTop);

      router.route(CouponPage.path, (context) => CouponPage(),
          transition: PageTransitionType.bottomToTop);

      router.route(
          CustomerCountriesPage.path, (context) => CustomerCountriesPage(),
          transition: PageTransitionType.bottomToTop);

      router.route(NoConnectionPage.path, (context) => NoConnectionPage());

      // Account Section

      router.route(LoginPage.path, (_) => LoginPage());

      router.route(LoginPage.path, (_) => LoginPage());

      router.route(
          RegisterPage.path, (_) => RegisterPage());

      router.route(
          AccountProfileUpdatePage.path, (_) => AccountProfileUpdatePage());

      router.route(
          AccountShippingDetailsPage.path, (_) => AccountShippingDetailsPage());

      router.route(
          AccountDetailOrdersPage.path, (_) => AccountDetailOrdersPage());
    });
