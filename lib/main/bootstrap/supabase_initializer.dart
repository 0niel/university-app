import 'package:rtu_mirea_app/env/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

class SupabaseInitializer implements AsyncLifecycle {
  const SupabaseInitializer();
  @override
  Future<void> init() async {
    if (!Env.hasSupabaseConfig) {
      throw StateError(
        'SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY must be provided with '
        'Dart defines.',
      );
    }
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
    );
  }

  @override
  Future<void> dispose() async {
    await Supabase.instance.client.auth.signOut();
    await Supabase.instance.dispose();
  }
}
