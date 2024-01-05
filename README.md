<p align="center">
  <img width="200" height="125" src="https://woosignal.com/images/woosignal_logo_stripe_blue.png" alt="WooSignal logo">
</p>

# WooCommerce App: WooGym

### WooGym

[Official WooSignal WooCommerce App](https://woosignal.com)

![alt text](https://woosignal.com/images/woosignal-woogym-flutter-update-social-banner.png "WooCommerce app - WooGym")

### See it in action

| Landing Screen  |  Dashboard Screen |
| ------------ | ------------ |
| <img src="https://woosignal.com/images/woogym-demo-landing.gif" alt="WooGym Demo - Landing" height="425" />  |  <img src="https://woosignal.com/images/woogym-demo.gif" alt="WooGym Demo - Dashboard" height="425" />  |

### About WooGym

WooGym is an App Template for Gym classes, customers will be able to book and manage all their classes in the app.

This app template supports WordPress sites using WooCommerce.

You can also upload the app to the IOS app store and Google play store using Flutter.

### Requirements

- [WooGym](https://woosignal.com/plugins/wordpress/wp-woo-gym) WordPress plugin - You can download from [WooSignal](https://woosignal.com/plugins/wordpress/wp-woo-gym)
- [WP JSON API](https://woosignal.com/plugins/wordpress/wp-json-api) WordPress plugin - You can download from [WooSignal](https://woosignal.com/plugins/wordpress/wp-json-api)
- WooCommerce Store 3.5+
- Android Studio/VSCode (for running the app)
- Flutter installed

### Getting Started

1. Download/Clone this repository
2. Sign up for free on [WooSignal](https://woosignal.com) and link your WooCommerce store
3. Add your app key into the **.env** file and hit play (with Android Studio) to build the app 🥳

Full documentation this available [here](https://woosignal.com/docs/app/woogym)

### Creating classes

Once you have installed the WooGym [plugin](https://woosignal.com/plugins/wordpress/wp-woogym), follow the below steps to create classes:

* Create a new Product of type 'Gym Class'.
  * Set a price in the general tab
  * Instructor
  * Max participants
  * If it's a weekly class
  * Gym location
  * Duration for the class
  * Set an image

![alt text](https://woosignal.com/images/woo-gym-product-data.png "Creating Gym Classes in WooGym")

### Customizing the look

You can manage the app information in the WooSignal dashboard.

In the .env file if also contains variables you can override to customize the look.

```
APP_HERO_VIDEO="https://assets.mixkit.co/videos/preview/mixkit-man-exercising-with-a-kettlebell-4506-large.mp4"
# The hero video on the landing page

GYM_LOCATION="https://maps.app.goo.gl/Hb8M8rCpmW8gQXRq9"
# The location of your gym

GYM_PHONE_NUMBER="+1 123 456 7890"
# The phone number of your gym

GYM_EMAIL_ADDRESS="john.doe@mail.com"
# The email address of your gym
```

## Features Integrated

- Customers can book gym classes
- Secret admin dashboard (if the logged in user has admin privileges in WP)
- Accept payments through Stripe
- Localized for en, es, pt, it, hi, fr, zh, tr, nl, de, th, id
- App Store & Google Play Store Ready
- Simple configuration
- Change app name, logo, customize default language, currency + more
- Orders show as normal in WooCommerce

## Security Vulnerabilities
If you discover a security vulnerability within WooSignal, please send an e-mail support@woosignal.com

## Uploading to the app stores

- [IOS - Deployment](https://flutter.dev/docs/deployment/ios)
- [Android - Deployment](https://flutter.dev/docs/deployment/android)

## Licence
WooGym is open-sourced software licensed under the bsd 2 license.
