import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:woosignal/models/response/product.dart';

import 'controller.dart';

class BookAClassController extends Controller {

  Map<String, List<Product>> listEvents = {};

  Future<List<Product>> fetchGymClasses({int page = 1}) async {
    List<Product> classes = await appWooSignal((api) =>
        api.getProducts(type: "gym_class", status: "publish", perPage: 100, page: page));

    if (classes.isEmpty) {
      return [];
    }

    return classes;
  }
}
