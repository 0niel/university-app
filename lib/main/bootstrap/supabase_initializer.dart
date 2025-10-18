import 'package:rtu_mirea_app/env/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

class SupabaseInitializer implements AsyncLifecycle {
  @override
  Future<void> init() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  }

  @override
  Future<void> dispose() async {
    await Supabase.instance.client.auth.signOut();
    await Supabase.instance.dispose();
  }
}
