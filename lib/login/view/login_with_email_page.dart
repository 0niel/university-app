import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => LoginBloc(
        userRepository: innerContext.read(),
      ),
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: AuthPageLayout(
          title: context.l10n.authEmailHeaderTitle,
          titleAccent: context.l10n.authEmailHeaderTitleAccent,
          subtitle: context.l10n.authEmailHeaderSubtitle,
          step: 1,
          totalSteps: 2,
          onBack: () => Navigator.of(context).maybePop(),
          actions: const LoginWithEmailNextButton(),
          child: const LoginWithEmailForm(),
        ),
      ),
    );
  }
}
