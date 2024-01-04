//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter_app/app/models/cart.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/bootstrap/shared_pref/shared_key.dart';
import 'package:flutter_app/resources/pages/landing_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

Future<bool> authCheck() async => ((await getUser()) != null);

Future<String?> readAuthToken() async {
  User? user = (await getUser());
  if (user == null) {
    await NyStorage.delete(SharedKey.authUser);
    Cart.getInstance.clear();
    routeTo(LandingPage.path);
    return null;
  }
  return user.token;
}

Future<String?> readUserId() async {
  User? user = (await getUser());
  if (user == null) {
    await NyStorage.delete(SharedKey.authUser);
    Cart.getInstance.clear();
    routeTo(LandingPage.path);
    return null;
  }
  return user.userId;
}
