import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BaseApiService extends NyApiService {
  BaseApiService(super.context) : super(decoders: modelDecoders);

}
