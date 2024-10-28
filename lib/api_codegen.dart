// Openapi Generator last run: : 2024-10-28T16:00:35.996871
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