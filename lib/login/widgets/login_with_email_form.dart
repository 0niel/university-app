import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/login/login.dart';

class LoginWithEmailForm extends StatelessWidget {
  const LoginWithEmailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select((LoginBloc bloc) => bloc.state.email.value);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          // Navigator.of(context).push<void>(
          //   MagicLinkPromptPage.route(email: email),
          // );
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('Login failed')));
        }
      },
      child: const CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.xlg, AppSpacing.lg, AppSpacing.xlg, AppSpacing.xxlg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HeaderTitle(),
                  SizedBox(height: AppSpacing.xxxlg),
                  _EmailInput(),
                  SizedBox(height: AppSpacing.lg),
                  _TermsAndPrivacyPolicyLinkTexts(),
                  Spacer(),
                  _NextButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      'Войдите, чтобы продолжить',
      key: const Key('loginWithEmailForm_header_title'),
      style: AppTextStyle.h4.copyWith(color: theme.colorScheme.onSurface),
    );
  }
}

class _EmailInput extends StatefulWidget {
  const _EmailInput();

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

    return LabelledInput(
      key: const Key('loginWithEmailForm_emailInput_textField'),
      controller: _controller,
      label: 'Ваш email',
      placeholder: '@mirea.ru или @edu.mirea.ru',
      onChanged: (email) => context.read<LoginBloc>().add(LoginEmailChanged(email)),
      errorText: !state.email.isValid ? 'Недопустимый адрес электронной почты' : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _TermsAndPrivacyPolicyLinkTexts extends StatelessWidget {
  const _TermsAndPrivacyPolicyLinkTexts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: RichText(
        key: const Key('loginWithEmailForm_terms_and_privacy_policy'),
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Вы можете использовать только адрес электронной почты в домене @mirea.ru или @edu.mirea.ru',
              style: AppTextStyle.body.copyWith(color: theme.deactive),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

    return TextButton(
      key: const Key('loginWithEmailForm_nextButton'),
      onPressed: !state.valid ? null : () => context.read<LoginBloc>().add(SendEmailLinkSubmitted()),
      child:
          state.status.isInProgress
              ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator())
              : Text('Далее'),
    );
  }
}

@visibleForTesting
class ClearIconButton extends StatelessWidget {
  const ClearIconButton({required this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final suffixVisible = context.select((LoginBloc bloc) => bloc.state.email.value.isNotEmpty);

    return Padding(
      key: const Key('loginWithEmailForm_clearIconButton'),
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Visibility(
        visible: suffixVisible,
        child: GestureDetector(
          onTap: onPressed,
          child: Icon(Icons.clear, size: 24, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
      ),
    );
  }
}
