import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BaseApiService extends NyApiService {
  BaseApiService(super.context);

  /// Map decoders to modelDecoders
  @override
  final Map<Type, dynamic> decoders = modelDecoders;

  /// Default interceptors
  // @override
  // final interceptors = {
  //
  // };
}
