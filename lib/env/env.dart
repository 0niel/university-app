import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'MAPKIT_API_KEY')
  static const String mapkitApiKey = _Env.mapkitApiKey;
}
