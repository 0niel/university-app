import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'MAPKIT_API_KEY')
  static const String mapkitApiKey = _Env.mapkitApiKey;
  @EnviedField(varName: 'STORYLY_ID')
  static const String storylyId = _Env.storylyId;
  @EnviedField(varName: 'SENTRY_DSN')
  static const String sentryDsn = _Env.sentryDsn;
}
