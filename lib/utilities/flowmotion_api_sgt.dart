import 'package:flowmotion/utilities/sgt_serializer.dart';
import 'package:flowmotion_api/flowmotion_api.dart';

/// Extension on FlowmotionApi with SGT datetime serializer
extension FlowmotionApiSGT on FlowmotionApi {
  getCongestionApiSgt() {
    return CongestionApi(
        dio, (standardSerializers.toBuilder()..add(SGTDateTimeSerializer())).build());
  }
}
