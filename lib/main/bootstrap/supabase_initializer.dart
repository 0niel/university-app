import 'dart:async';

import 'package:deep_link_client/deep_link_client.dart';
import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/common/utils/logger.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

class SupabaseInitializer implements AsyncLifecycle {
  SupabaseInitializer();

  static const authOptions = FlutterAuthClientOptions(
    detectSessionInUri: false,
  );

  StreamSubscription<Uri>? _linkSubscription;

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
      authOptions: authOptions,
    );
    final links = DeepLinkClient();
    _linkSubscription = links.deepLinkStream.listen(
      (uri) => unawaited(_handleCallback(uri)),
      onError: _reportCallbackError,
    );
    try {
      final initialLink = await links.getInitialLink();
      if (initialLink != null) await _handleCallback(initialLink);
    } on Object catch (error, stackTrace) {
      _reportCallbackError(error, stackTrace);
    }
  }

  Future<void> _handleCallback(Uri uri) async {
    try {
      final result = await SupabaseAuthCallbackHandler.forClient(
        Supabase.instance.client.auth,
      ).handle(uri);
      if (result == SupabaseAuthCallbackResult.guestPreserved) {
        logger.w('Authentication callback skipped to preserve guest session.');
      }
    } on Object catch (error, stackTrace) {
      _reportCallbackError(error, stackTrace);
    }
  }

  void _reportCallbackError(Object error, StackTrace stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: StateError(
          'Authentication callback failed (${error.runtimeType}).',
        ),
        stack: stackTrace,
        library: 'authentication',
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await _linkSubscription?.cancel();
    await Supabase.instance.dispose();
  }
}
