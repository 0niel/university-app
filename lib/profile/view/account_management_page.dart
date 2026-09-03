import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/guest_upgrade_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:user_repository/user_repository.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  var _busy = false;
  var _resetSent = false;
  String? _error;

  bool _current(String userId) =>
      mounted && context.read<AppBloc>().state.user.id == userId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final user = context.select<AppBloc, User>((bloc) => bloc.state.user);
    final email = user.isGuest || (user.email?.trim().isEmpty ?? true)
        ? null
        : user.email!.trim();

    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => previous.user.id != current.user.id,
      listener: (context, state) => setState(() {
        _busy = false;
        _resetSent = false;
        _error = null;
      }),
      child: Scaffold(
        backgroundColor: colors.canvas,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              AppInnerHeader(
                title: l10n.settingsManageAccount,
                backSemanticsLabel: l10n.back,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    bottom: ninjaBottomInset(context) + AppSpacing.lg,
                  ),
                  children: [
                    if (_error case final message?)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screen,
                        ),
                        child: AppErrorState.compact(title: message),
                      ),
                    SettingsSection(
                      label: l10n.profileAccount,
                      children: [
                        SettingsRow(
                          title: l10n.accountEmailLabel,
                          lineIcon: AppLineIcon.at,
                          subtitle: email ?? l10n.accountGuest,
                          showChevron: false,
                        ),
                        if (user.isGuest)
                          SettingsRow(
                            title: l10n.authGuestUpgradeTitle,
                            subtitle: l10n.authGuestUpgradeSubtitle,
                            lineIcon: AppLineIcon.at,
                            enabled: !_busy,
                            onTap: () =>
                                unawaited(showGuestUpgradeSheet(context)),
                          ),
                        if (email != null)
                          SettingsRow(
                            title: l10n.accountChangePassword,
                            lineIcon: AppLineIcon.lock,
                            subtitle: _resetSent
                                ? l10n.accountResetSent
                                : l10n.accountChangePasswordSub,
                            valueColor: colors.accent,
                            enabled: !_busy,
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
                          enabled: !_busy,
                          showChevron: false,
                          onTap: () => unawaited(_confirmSignOut()),
                        ),
                        SettingsRow(
                          title: l10n.accountDelete,
                          lineIcon: AppLineIcon.trash,
                          danger: true,
                          enabled: !_busy && user.id.isNotEmpty,
                          showChevron: false,
                          onTap: () => unawaited(_confirmDelete(context)),
                        ),
                      ],
                    ),
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.all(AppSpacing.screen),
                        child: Center(child: NinjaSpinner(size: 24)),
                      ),
                  ],
                ).animatePageEntrance(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context, String email) async {
    if (_busy) return;
    final userId = context.read<AppBloc>().state.user.id;
    final l10n = context.l10n;
    final repository = context.read<UserRepository>();
    setState(() {
      _busy = true;
      _error = null;
      _resetSent = false;
    });
    try {
      await repository.sendPasswordResetEmail(email: email);
      if (_current(userId)) {
        setState(() => _resetSent = true);
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Password reset failed',
        error: error,
        stackTrace: stackTrace,
        name: 'AccountManagementPage',
      );
      if (_current(userId)) setState(() => _error = l10n.accountResetError);
    } finally {
      if (_current(userId)) setState(() => _busy = false);
    }
  }

  Future<void> _confirmSignOut() async {
    if (_busy) return;
    final app = context.read<AppBloc>();
    final userId = app.state.user.id;
    final l10n = context.l10n;
    setState(() => _busy = true);
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: l10n.profileSignOutConfirm,
      message: app.state.user.isGuest ? l10n.authGuestExitWarning : null,
      confirmLabel: l10n.profileSignOut,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!mounted || !_current(userId)) return;
    setState(() => _busy = false);
    if (confirmed && !app.isClosed) app.add(const AppLogoutRequested());
  }

  Future<void> _confirmDelete(BuildContext context) async {
    if (_busy) return;
    final userId = context.read<AppBloc>().state.user.id;
    final repository = context.read<UserRepository>();
    if (userId.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final l10n = context.l10n;
    final isConfirmed = await showNinjaConfirmDialog(
      context,
      title: l10n.accountDeleteConfirmTitle,
      message: l10n.accountDeleteConfirmBody,
      confirmLabel: l10n.accountDeleteAction,
      cancelLabel: l10n.cancel,
      destructive: true,
    );

    if (!mounted || !_current(userId)) return;
    if (!isConfirmed) {
      setState(() => _busy = false);
      return;
    }
    await _deleteAccount(repository, userId, l10n.accountDeleteError);
  }

  Future<void> _deleteAccount(
    UserRepository repository,
    String userId,
    String errorMessage,
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
      if (_current(userId)) {
        setState(() => _error = errorMessage);
      }
    } finally {
      if (_current(userId)) setState(() => _busy = false);
    }
  }
}
