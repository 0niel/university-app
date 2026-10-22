import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';

class ThemePreferencesSync extends StatefulWidget {
  const ThemePreferencesSync({
    required this.userId,
    required this.child,
    super.key,
  });

  final String userId;
  final Widget child;

  @override
  State<ThemePreferencesSync> createState() => _ThemePreferencesSyncState();
}

class _ThemePreferencesSyncState extends State<ThemePreferencesSync> {
  var _restoreRevision = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_restore());
  }

  @override
  void didUpdateWidget(ThemePreferencesSync oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) unawaited(_restore());
  }

  Future<void> _restore() async {
    final revision = ++_restoreRevision;
    final userId = widget.userId;
    final preferences = context.read<PreferencesRepository>();
    if (userId.isEmpty || preferences.currentUserId != userId) return;
    final theme = context.read<ThemeCubit>();
    final accentRevision = theme.accentRevision;
    final repository = context.read<GamificationRepository>();
    try {
      final settings = await repository.getSettings();
      if (!mounted ||
          revision != _restoreRevision ||
          preferences.currentUserId != userId ||
          theme.isClosed ||
          theme.accentRevision != accentRevision) {
        return;
      }
      final scheme = AppColorScheme.values.firstWhereOrNull(
        (candidate) => candidate.name == settings.accentColor,
      );
      if (scheme != null) theme.setColorScheme(scheme);
    } on Object catch (error, stackTrace) {
      if (mounted &&
          revision == _restoreRevision &&
          preferences.currentUserId == userId &&
          !theme.isClosed) {
        log(
          'Theme preferences sync failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
