import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

part 'login_with_email_form_email_input.dart';
part 'login_with_email_form_next_button.dart';
part 'login_with_email_form_university_hint.dart';

class LoginWithEmailForm extends StatelessWidget {
  const LoginWithEmailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select<LoginBloc, String>(
      (bloc) => bloc.state.email.value,
    );
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          LoginEmailConfirmationRoute(email: email).go(context);
        } else if (state.status.isFailure) {
          showNinjaToast(
            context,
            message: context.l10n.authEmailLinkFailed,
            showCheck: false,
          );
        }
      },
      child: const Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          _LoginWithEmailFormEmailInput(),
          SizedBox(height: 12),
          _LoginWithEmailFormUniversityHint(),
          SizedBox(height: 24),
          _LoginWithEmailFormNextButton(),
        ],
      ),
    );
  }
}
