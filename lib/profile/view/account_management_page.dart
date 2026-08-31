import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:user_repository/user_repository.dart';

class AccountManagementPage extends StatelessWidget {
  const AccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final user = context.select<AppBloc, User>((bloc) => bloc.state.user);
    final email = user.email;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            NinjaAppBar.inner(
              title: l10n.settingsManageAccount,
              backSemanticLabel: l10n.back,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 32,
                ),
                children: [
                  SettingsSection(
                    label: l10n.profileAccount,
                    children: [
                      SettingsRow(
                        title: l10n.accountEmailLabel,
                        lineIcon: AppLineIcon.at,
                        value: email ?? l10n.accountGuest,
                        showChevron: false,
                      ),
                      if (email != null)
                        SettingsRow(
                          title: l10n.accountChangePassword,
                          lineIcon: AppLineIcon.lock,
                          value: l10n.accountChangePasswordSub,
                          valueColor: colors.brandInk,
                          onTap: () =>
                              unawaited(_resetPassword(context, email)),
                        ),
                    ],
                  ),
                  SettingsSection(
                    label: l10n.settingsManageAccount,
                    children: [
                      SettingsRow(
                        title: l10n.profileSignOut,
                        lineIcon: AppLineIcon.logout,
                        danger: true,
                        showChevron: false,
                        onTap: () => context.read<AppBloc>().add(
                          const AppLogoutRequested(),
                        ),
                      ),
                      SettingsRow(
                        title: l10n.accountDelete,
                        lineIcon: AppLineIcon.trash,
                        danger: true,
                        showChevron: false,
                        onTap: () => unawaited(_confirmDelete(context)),
                      ),
                    ],
                  ),
                ],
              ).animatePageEntrance(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context, String email) async {
    final l10n = context.l10n;
    final repository = context.read<UserRepository>();
    try {
      await repository.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        showNinjaToast(context, message: l10n.accountResetSent);
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Password reset failed',
        error: error,
        stackTrace: stackTrace,
        name: 'AccountManagementPage',
      );
      if (context.mounted) {
        showNinjaToast(
          context,
          message: l10n.accountResetError,
          showCheck: false,
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final isConfirmed = await showNinjaConfirmDialog(
      context,
      title: l10n.accountDeleteConfirmTitle,
      message: l10n.accountDeleteConfirmBody,
      confirmLabel: l10n.accountDeleteAction,
      cancelLabel: l10n.cancel,
      destructive: true,
    );

    if (!context.mounted || !isConfirmed) return;
    await _deleteAccount(context, context.read());
  }

  Future<void> _deleteAccount(
    BuildContext context,
    UserRepository repository,
  ) async {
    try {
      await repository.deleteAccount();
    } on Exception catch (error, stackTrace) {
      log(
        'Account deletion failed',
        error: error,
        stackTrace: stackTrace,
        name: 'AccountManagementPage',
      );
      if (context.mounted) {
        showNinjaToast(
          context,
          message: context.l10n.accountDeleteError,
          showCheck: false,
        );
      }
    }
  }
}
