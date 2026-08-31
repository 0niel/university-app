import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => LoginBloc(
        userRepository: innerContext.read(),
        allowedEmailDomains: innerContext
            .read<UniversityConfig>()
            .allowedEmailDomains,
      ),
      child: Scaffold(
        backgroundColor: context.ninja.canvas,
        body: AuthPageLayout(
          title: context.l10n.authEmailHeaderTitle,
          subtitle: context.l10n.authUniversityEmailHint(
            context.read<UniversityConfig>().emailDomainHint,
          ),
          showBack: true,
          onBack: () => Navigator.of(context).maybePop(),
          compact: true,
          child: const LoginWithEmailForm(),
        ),
      ),
    );
  }
}
