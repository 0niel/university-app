import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/forms/labelled_input.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogInSuccess) {
            context.router.pop();
          }
        },
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text("Вход", style: AppTextStyle.h4),
                const SizedBox(height: 13),
                RichText(
                  text: TextSpan(
                    text: 'Используйте ваши данные от  ',
                    style: AppTextStyle.bodyRegular
                        .copyWith(color: AppTheme.colors.deactive),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'lk.mirea.ru', style: AppTextStyle.bodyBold),
                      TextSpan(
                          text: "  для входа.",
                          style: AppTextStyle.bodyRegular
                              .copyWith(color: AppTheme.colors.deactive)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                AutofillGroup(
                  child: Column(
                    children: [
                      LabelledInput(
                          placeholder: "Email",
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          obscureText: obscureText,
                          label: "Ваш Email"),
                      const SizedBox(height: 20),
                      LabelledInput(
                          placeholder: "Пароль",
                          keyboardType: TextInputType.text,
                          controller: _passController,
                          obscureText: obscureText,
                          label: "Ваш пароль"),
                    ],
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  if (state is LogInError && state.cause != '') {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        state.cause,
                        style: AppTextStyle.bodyRegular
                            .copyWith(color: AppTheme.colors.colorful07),
                      ),
                    );
                  }
                  return Container();
                }),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Войти',
                  onClick: () {
                    context.read<AuthBloc>().add(AuthLogInEvent(
                        login: _emailController.text,
                        password: _passController.text));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
