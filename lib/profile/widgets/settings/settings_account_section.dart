import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/guest_upgrade_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';

class SettingsAccountSection extends StatelessWidget {
  const SettingsAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = context.watch<AppBloc>().state.user;
    return SettingsSection(
      label: l10n.profileAccount,
      children: [
        SettingsRow(
          title: l10n.accountEmailLabel,
          value: user.isGuest || (user.email?.isEmpty ?? true)
              ? l10n.accountGuest
              : user.email,
          showChevron: false,
        ),
        if (user.isGuest)
          SettingsRow(
            title: l10n.authGuestUpgradeTitle,
            subtitle: l10n.authGuestUpgradeSubtitle,
            lineIcon: AppLineIcon.at,
            onTap: () => unawaited(showGuestUpgradeSheet(context)),
          ),
        SettingsRow(
          title: l10n.settingsManageAccount,
          lineIcon: AppLineIcon.user,
          onTap: () => unawaited(context.push('/profile/account')),
        ),
        SettingsRow(
          title: l10n.profileSignOut,
          lineIcon: AppLineIcon.logout,
          danger: true,
          showChevron: false,
          onTap: () => _confirmSignOut(context),
        ),
      ],
    );
  }

  void _confirmSignOut(BuildContext context) {
    final l10n = context.l10n;
    final appBloc = context.read<AppBloc>();
    unawaited(
      showNinjaConfirmDialog(
        context,
        title: l10n.profileSignOutConfirm,
        message: appBloc.state.user.isGuest ? l10n.authGuestExitWarning : null,
        confirmLabel: l10n.profileSignOut,
        cancelLabel: l10n.cancel,
        destructive: true,
      ).then((confirmed) {
        if (confirmed) appBloc.add(const AppLogoutRequested());
      }),
    );
  }
}
