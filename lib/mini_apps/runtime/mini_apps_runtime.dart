import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:stac_bridge/stac_bridge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class MiniAppsRuntime {
  static Future<void> ensureInitialized({
    UniversityConfig? config,
  }) {
    final deployment = config ?? .current;
    return StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: '${Env.supabaseUrl}/functions/v1/miniapp-proxy',
        organizationId: deployment.organizationId,
        onAccessTokenRequested: () async =>
            Supabase.instance.client.auth.currentSession?.accessToken,
      ),
    );
  }
}
