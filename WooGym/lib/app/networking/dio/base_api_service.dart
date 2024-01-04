import 'package:flutter_app/app/networking/dio/interceptors/logging_interceptor.dart';
import 'package:flutter_app/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BaseApiService extends NyApiService {
  BaseApiService(super.context);

  /// Map decoders to modelDecoders
  @override
  final Map<Type, dynamic> decoders = modelDecoders;

  /// Default interceptors
  @override
  final interceptors = {
    if (getEnv('APP_DEBUG') == true) LoggingInterceptor: LoggingInterceptor()
  };
}
