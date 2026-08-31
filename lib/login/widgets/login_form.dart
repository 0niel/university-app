import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';

part 'login_form_content.dart';
part 'login_form_continue_button.dart';
part 'login_form_subtitle.dart';
part 'login_form_title.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status.isLoggedIn) {
          Navigator.of(context).pop();
        }
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            showNinjaToast(
              context,
              message: context.l10n.authSignInFailed,
              showCheck: false,
            );
          }
        },
        child: const _LoginFormContent(),
      ),
    );
  }
}
