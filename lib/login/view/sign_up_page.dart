import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

part 'sign_up_button.dart';
part 'sign_up_view.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => SignUpBloc(
        userRepository: innerContext.read(),
        allowedEmailDomains: innerContext
            .read<UniversityConfig>()
            .allowedEmailDomains,
      ),
      child: const _SignUpView(),
    );
  }
}
