import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/bloc/password_reset_bloc.dart';

class PasswordResetFeedback extends StatelessWidget {
  const PasswordResetFeedback({required this.error, super.key});

  final PasswordResetError error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBanner(
      key: ValueKey(error),
      tone: error == .rateLimited ? AppBannerTone.warn : AppBannerTone.danger,
      message: switch (error) {
        .sendFailed => l10n.authPasswordResetFailed,
        .verificationFailed => l10n.authPasswordResetVerifyFailed,
        .invalidCode => l10n.authInvalidCode,
        .rateLimited => l10n.authPasswordResetRateLimited,
        .weakPassword => l10n.authPasswordResetWeakPassword,
        .samePassword => l10n.authPasswordResetSamePassword,
        .sessionExpired => l10n.authPasswordResetSessionExpired,
        .updateFailed => l10n.authPasswordResetUpdateFailed,
      },
    );
  }
}
