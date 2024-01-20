import 'package:flutter/material.dart';
import '/app/networking/dio/base_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| ApiService
| -------------------------------------------------------------------------
| Define your API endpoints
| Learn more https://nylo.dev/docs/5.20.0/networking
|--------------------------------------------------------------------------
*/

class ApiService extends BaseApiService {
  ApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<dynamic> fetchTestData() async {
    return await network(
      request: (request) => request.get("/endpoint-path"),
    );
  }
}
