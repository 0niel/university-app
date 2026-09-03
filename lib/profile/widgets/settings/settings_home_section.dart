import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class SettingsHomeSection extends StatelessWidget {
  const SettingsHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final preferences = context.watch<UiPreferencesCubit>().state;
    final favoriteCount = context
        .watch<FavoriteServicesCubit>()
        .state
        .ids
        .length;
    return SettingsSection(
      label: l10n.settingsHomeAndWidgets,
      children: [
        SettingsRow(
          title: l10n.settingsAppTour,
          lineIcon: AppLineIcon.spark,
          onTap: () => unawaited(startAppTour(context)),
        ),
        SettingsRow(
          title: l10n.settingsHomeContent,
          lineIcon: AppLineIcon.grid,
          value: homeContentSummary(l10n, preferences),
          onTap: () => showHomeContentSheet(context),
        ),
        SettingsRow(
          title: l10n.settingsQuickServices,
          lineIcon: AppLineIcon.pin,
          value: l10n.settingsQuickServicesValue(favoriteCount),
          onTap: () => context.go('/services?configure=true'),
        ),
        SettingsRow(
          title: l10n.settingsScreenWidgets,
          lineIcon: AppLineIcon.services,
          onTap: () => showWidgetSheet(context),
        ),
      ],
    );
  }
}
