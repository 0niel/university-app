import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';

class SettingsPrivacySection extends StatelessWidget {
  const SettingsPrivacySection({
    required this.settings,
    required this.onChanged,
    super.key,
  });

  final UserSettings settings;
  final ValueChanged<UserSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pass = context.watch<PassSecurityCubit>().state;
    final nfcHce = context.watch<NfcHceCubit>().state;
    return SettingsSection(
      label: l10n.settingsPrivacy,
      children: [
        SettingsRow(
          title: l10n.settingsWhoSeesProfile,
          lineIcon: AppLineIcon.view,
          value: visibilityLabel(l10n, settings.profileVisibility),
          onTap: () => showProfileVisibilitySheet(
            context,
            current: settings.profileVisibility,
            onSelected: (value) =>
                onChanged(settings.copyWith(profileVisibility: value)),
          ),
        ),
        SettingsToggleRow(
          label: l10n.settingsAnonymousReactions,
          lineIcon: AppLineIcon.hide,
          value: settings.anonymousReactions,
          onChanged: (value) =>
              onChanged(settings.copyWith(anonymousReactions: value)),
        ),
        SettingsToggleRow(
          label: l10n.settingsBiometricsPass,
          lineIcon: AppLineIcon.fingerprint,
          sub: pass.available
              ? biometricLabel(l10n, pass.kind)
              : l10n.biometricUnavailable,
          value: pass.enabled,
          onChanged: pass.available
              ? (value) => unawaited(_toggleBiometric(context, enabled: value))
              : null,
        ),
        if (nfcHce.available)
          SettingsToggleRow(
            label: l10n.settingsNfcEmulation,
            lineIcon: AppLineIcon.contactless,
            sub: l10n.settingsNfcEmulationSub,
            value: nfcHce.enabled,
            onChanged: (value) =>
                context.read<NfcHceCubit>().setEnabled(enabled: value),
          ),
      ],
    );
  }

  Future<void> _toggleBiometric(
    BuildContext context, {
    required bool enabled,
  }) async {
    await context.read<PassSecurityCubit>().setEnabled(
      enabled: enabled,
      reason: context.l10n.passLockReason,
    );
  }
}
