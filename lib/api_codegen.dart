// Openapi Generator last run: : 2024-11-05T07:32:21.317356
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  useNextGen: true,
  alwaysRun: true,
  additionalProperties: DioProperties(
    pubName: 'flowmotion_api',
  ),
  inputSpecFile: "",
  inputSpec: InputSpec(
      path:
        'schema/flowmotion_api.yaml'),
  generatorName: Generator.dio,
  runSourceGenOnOutput: true,
  outputDirectory: 'packages/flowmotion_api',
)
class FlowmotionAPI {}