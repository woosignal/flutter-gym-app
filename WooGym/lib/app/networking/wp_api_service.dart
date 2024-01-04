import 'package:flutter/material.dart';
import '/app/networking/dio/base_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class WpApiService extends BaseApiService {
  WpApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<dynamic> getBoxingClasses() async {
    return await network(
      request: (request) => request.get("/wp-json/wp/v2/boxing-class"),
    );
  }
}
