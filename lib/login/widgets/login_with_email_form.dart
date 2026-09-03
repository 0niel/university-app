import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

class LoginWithEmailForm extends StatefulWidget {
  const LoginWithEmailForm({super.key});

  @override
  State<LoginWithEmailForm> createState() => _LoginWithEmailFormState();
}

class _LoginWithEmailFormState extends State<LoginWithEmailForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<LoginBloc>().state;
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          LoginEmailConfirmationRoute(email: state.email.value).go(context);
        } else if (state.status.isFailure) {
          ToastManager.showError(context, message: l10n.authEmailLinkFailed);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppInputField(
            key: const Key('loginWithEmailForm_emailInput_textField'),
            controller: _controller,
            readOnly: state.status.isInProgress,
            label: l10n.authYourEmail,
            placeholder: l10n.loginEmailPlaceholder,
            leadingIcon: AppLineIcon.at,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            onChanged: (email) =>
                context.read<LoginBloc>().add(LoginEmailChanged(email)),
            onSubmitted: (_) {
              final bloc = context.read<LoginBloc>();
              if (bloc.state.isEmailValid && !bloc.state.status.isInProgress) {
                bloc.add(EmailLinkRequested());
              }
            },
            validateOnBlur: true,
            errorText: !state.email.isPure && !state.email.isValid
                ? l10n.authInvalidEmail
                : null,
          ),
          const SizedBox(height: 12),
          AuthHintCard(
            key: const Key('loginWithEmailForm_terms_and_privacy_policy'),
            icon: AppLineIcon.at,
            color: colors.lecture,
            title: l10n.authAnyEmailHint,
          ),
        ],
      ),
    );
  }
}

class LoginWithEmailNextButton extends StatelessWidget {
  const LoginWithEmailNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    return AppButton.primary(
      key: const Key('loginWithEmailForm_nextButton'),
      label: context.l10n.authNext,
      size: AppButtonSize.hero,
      expanded: true,
      loading: state.status.isInProgress,
      onPressed: state.isEmailValid
          ? () => context.read<LoginBloc>().add(EmailLinkRequested())
          : null,
    );
  }
}
