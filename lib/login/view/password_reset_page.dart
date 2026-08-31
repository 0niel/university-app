import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';

part 'password_reset_button.dart';
part 'password_reset_view.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => PasswordResetBloc(
        userRepository: innerContext.read(),
        allowedEmailDomains: innerContext
            .read<UniversityConfig>()
            .allowedEmailDomains,
      ),
      child: const _PasswordResetView(),
    );
  }
}
