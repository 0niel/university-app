import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/debug/debug_panel.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void _toast(String message) {
  final context = appRouter.routerDelegate.navigatorKey.currentContext;
  if (context != null && context.mounted) {
    showNinjaToast(context, showCheck: false, message: message);
  }
}

void registerDebugActions() {
  DebugRegistry.instance
    ..registerAction(
      const DebugAction(
        label: 'Полная очистка кэша',
        subtitle: 'Hydrated, prefs, secure storage, картинки, сессия',
        icon: AppLineIcon.trash,
        isDestructive: true,
        onTap: _confirmFullWipe,
      ),
    )
    ..registerAction(
      DebugAction(
        label: 'Очистить кэш изображений',
        subtitle: 'Память + диск (network/extended image)',
        icon: AppLineIcon.image,
        onTap: (_) {
          unawaited(_clearImageCachesAndNotify());
        },
      ),
    )
    ..registerAction(
      DebugAction(
        label: 'Выйти из аккаунта',
        icon: AppLineIcon.logout,
        onTap: (context) {
          context.read<AppBloc>().add(const AppLogoutRequested());
          showNinjaToast(
            context,
            showCheck: false,
            message: 'Выполняется выход',
          );
        },
      ),
    )
    ..registerAction(
      DebugAction(
        label: 'Открыть экран входа',
        icon: AppLineIcon.user,
        onTap: (_) => appRouter.go('/auth'),
      ),
    )
    ..registerAction(
      DebugAction(
        label: 'Скопировать access token',
        icon: AppLineIcon.key,
        onTap: (context) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session == null) {
            showNinjaToast(
              context,
              showCheck: false,
              message: 'Нет активной сессии',
            );
            return;
          }
          unawaited(
            Clipboard.setData(ClipboardData(text: session.accessToken)),
          );
          showNinjaToast(context, message: 'Access token скопирован');
        },
      ),
    )
    ..registerAction(
      DebugAction(
        label: 'Сбросить онбординг',
        icon: AppLineIcon.refresh,
        onTap: (context) {
          context.read<HomeCubit>().resetOnboarding();
          appRouter.go('/onboarding');
        },
      ),
    )
    ..registerAction(
      const DebugAction(
        label: 'Информация о приложении',
        subtitle: 'Окружение и текущая сессия',
        icon: AppLineIcon.info,
        onTap: _showInfoDialog,
      ),
    );
}

void _confirmFullWipe(BuildContext context) {
  unawaited(_confirmFullWipeAsync(context));
}

Future<void> _confirmFullWipeAsync(BuildContext context) async {
  final confirmed = await showNinjaConfirmDialog(
    context,
    title: 'Полная очистка кэша?',
    message:
        'Будут удалены: hydrated-хранилище, SharedPreferences, '
        'secure storage, кэш изображений, и выполнен выход из аккаунта. '
        'Приложение вернётся на экран входа.',
    confirmLabel: 'Очистить',
    cancelLabel: 'Отмена',
    destructive: true,
  );
  if (confirmed) await _fullWipeAndRouteToLogin();
}

Future<void> _clearImageCachesAndNotify() async {
  await _clearImageCaches();
  _toast('Кэш изображений очищен');
}

Future<void> _fullWipeAndRouteToLogin() async {
  final cleared = await _fullWipe();
  _toast('Очищено: ${cleared.join(', ')}');
  appRouter.go('/auth');
}

Future<List<String>> _fullWipe() async {
  final cleared = <String>[];

  await _guard(
    'сессия',
    () => Supabase.instance.client.auth.signOut(),
    cleared,
  );
  await _guard('hydrated', () => HydratedBloc.storage.clear(), cleared);
  await _guard('prefs', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }, cleared);
  await _guard(
    'secure storage',
    () => const FlutterSecureStorage().deleteAll(),
    cleared,
  );
  await _guard('изображения', _clearImageCaches, cleared);

  return cleared;
}

Future<void> _clearImageCaches() async {
  PaintingBinding.instance.imageCache
    ..clear()
    ..clearLiveImages();
  clearMemoryImageCache();
  await clearDiskCachedImages();
  await DefaultCacheManager().emptyCache();
}

Future<void> _guard(
  String label,
  Future<void> Function() action,
  List<String> cleared,
) async {
  try {
    await action();
    cleared.add(label);
  } on Exception catch (e, st) {
    log(
      'Wipe step failed: $label',
      error: e,
      stackTrace: st,
      name: 'debug_actions',
    );
  }
}

void _showInfoDialog(BuildContext context) {
  final auth = Supabase.instance.client.auth;
  final user = auth.currentUser;
  final lines = [
    'Supabase URL: ${Env.supabaseUrl}',
    'Organization: ${UniversityConfig.current.organizationId}',
    'User ID: ${user?.id ?? '—'}',
    'Email: ${user?.email ?? '—'}',
    'Anonymous: ${user?.isAnonymous ?? false}',
    'Session: ${auth.currentSession != null ? 'активна' : 'нет'}',
  ];
  final text = lines.join('\n');

  unawaited(
    showNinjaDialog(
      context,
      builder: (dialogContext) => NinjaDialog(
        title: 'Информация',
        confirmLabel: 'Копировать',
        onConfirm: () {
          unawaited(Clipboard.setData(ClipboardData(text: text)));
          Navigator.of(dialogContext).pop();
          _toast('Скопировано');
        },
        cancelLabel: 'Закрыть',
        onCancel: () => Navigator.of(dialogContext).pop(),
        child: SelectableText(
          text,
          style: AppText.captionSmall.copyWith(
            color: dialogContext.ninja.muted,
            height: 1.5,
            fontFamily: 'monospace',
          ),
        ),
      ),
    ),
  );
}
