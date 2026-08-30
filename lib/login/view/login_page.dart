import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';

part 'login_page_bottom_links.dart';
part 'login_page_form.dart';
part 'login_page_submit_button.dart';
part 'login_page_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (innerContext) => LoginBloc(
        userRepository: innerContext.read(),
        allowedEmailDomains: innerContext
            .read<UniversityConfig>()
            .allowedEmailDomains,
      ),
      child: const _LoginPageView(),
    );
  }
}
