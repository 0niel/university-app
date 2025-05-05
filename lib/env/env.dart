import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(requireEnvFile: false, environment: false)
abstract class Env {
  @EnviedField(varName: 'SENTRY_DSN')
  static const String sentryDsn = _Env.sentryDsn;
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _Env.supabaseAnonKey;
}
