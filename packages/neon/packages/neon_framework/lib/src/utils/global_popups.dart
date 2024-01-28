import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/blocs/first_launch.dart';
import 'package:neon_framework/src/blocs/next_push.dart';
import 'package:neon_framework/src/pages/settings.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/dialog.dart';

/// Singleton class managing global popups.
@internal
class GlobalPopups {
  /// Returns the current instance.
  ///
  /// Instantiates a new one if not yet present.
  factory GlobalPopups() => instance ??= GlobalPopups._();

  /// Returns the current instance.
  ///
  /// Instantiates a new one with a [mock]ed value if not yet present.
  @visibleForTesting
  factory GlobalPopups.mocked(GlobalPopups mock) => instance ??= mock;

  GlobalPopups._();

  /// The instance of this singleton.
  @visibleForTesting
  static GlobalPopups? instance;

  bool _registered = false;
  late BuildContext _context;
  final _subscriptions = <StreamSubscription<dynamic>>[];

  /// Disposes this instance and cancels all active subscriptions.
  ///
  /// The instance will be reset. Subsequent calls will instantiate a new one.
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
    _registered = false;
    instance = null;
  }

  /// Registers the global backups to the given [context].
  ///
  /// Subsequent calls will update the cached `context` but will not run the registration again.
  void register(BuildContext context) {
    _context = context;
    if (_registered) {
      return;
    }

    _registered = true;

    final globalOptions = NeonProvider.of<GlobalOptions>(context);
    final firstLaunchBloc = NeonProvider.of<FirstLaunchBloc>(context);
    final nextPushBloc = NeonProvider.of<NextPushBloc>(context);
    if (NeonPlatform.instance.canUsePushNotifications) {
      _subscriptions.addAll([
        firstLaunchBloc.onFirstLaunch.listen((_) {
          assert(context.mounted, 'Context should be mounted');
          if (!globalOptions.pushNotificationsEnabled.enabled) {
            return;
          }

          ScaffoldMessenger.of(_context).showSnackBar(
            SnackBar(
              content: Text(NeonLocalizations.of(_context).firstLaunchGoToSettingsToEnablePushNotifications),
              action: SnackBarAction(
                label: NeonLocalizations.of(_context).settings,
                onPressed: () {
                  const SettingsRoute(initialCategory: SettingsCategories.pushNotifications).go(_context);
                },
              ),
            ),
          );
        }),
        nextPushBloc.onNextPushSupported.listen((_) async {
          assert(context.mounted, 'Context should be mounted');
          if (!globalOptions.pushNotificationsEnabled.enabled) {
            return;
          }

          await showAdaptiveDialog<void>(
            context: _context,
            builder: (context) => const NeonUnifiedPushDialog(),
          );
        }),
      ]);
    }
  }
}
