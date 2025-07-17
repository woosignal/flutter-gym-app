import 'package:nylo_framework/nylo_framework.dart';

/* Keys
|--------------------------------------------------------------------------
| Storage keys are used to read and write to local storage.
| E.g. static StorageKey coins = "SK_COINS";
| String coins = await Keys.coins.read();
|
| Learn more: https://nylo.dev/docs/6.x/storage#storage-keys
|-------------------------------------------------------------------------- */

class Keys {
  // Define the keys you want to be synced on boot
  static syncedOnBoot() => () async {
        return [
          authUser,
          cart,
          customerBillingDetails,
          customerShippingDetails,
          wishlistProducts,
          userType
        ];
      };

  // static StorageKey auth = getEnv('SK_USER', defaultValue: 'SK_USER');
  //
  // static StorageKey bearerToken = 'SK_BEARER_TOKEN';

  static const StorageKey authUser = "DEFAULT_SP_USER";
  static const StorageKey cart = "CART_SESSION";
  static const StorageKey customerBillingDetails = "CS_BILLING_DETAILS";
  static const StorageKey customerShippingDetails = "CS_SHIPPING_DETAILS";
  static const StorageKey wishlistProducts = "CS_WISHLIST_PRODUCTS";
  static const StorageKey userType = "USER_TYPE";

}
