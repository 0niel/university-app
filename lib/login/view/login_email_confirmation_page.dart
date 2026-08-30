import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';

part 'login_email_confirmation_form.dart';
part 'login_email_confirmation_status.dart';

class LoginEmailConfirmationPage extends StatelessWidget {
  const LoginEmailConfirmationPage({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return BlocProvider(
      create: (innerContext) => LoginWithEmailLinkBloc(
        userRepository: innerContext.read(),
      ),
      child: Scaffold(
        backgroundColor: colors.canvas,
        body: AuthPageLayout(
          title: l10n.authCheckEmailTitle,
          subtitle: l10n.authCheckEmailSubtitle(email),
          showBack: true,
          onBack: () => Navigator.of(context).maybePop(),
          compact: true,
          child: _LoginEmailConfirmationForm(email: email),
        ),
      ),
    );
  }
}
