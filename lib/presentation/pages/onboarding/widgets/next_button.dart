import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:rtu_mirea_app/presentation/bloc/app_cubit/app_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

/// Get next button to open next page
/// or to close onboarding and start main app
class NextPageViewButton extends StatelessWidget {
  const NextPageViewButton(
      {Key? key, required this.isLastPage, required this.onClick})
      : super(key: key);

  final bool isLastPage;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isLastPage) {
          context.read<AppCubit>().closeOnboarding();
          context.router.replace(const HomeRoute());
        } else {
          onClick();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isLastPage
            ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0)
            : const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
        child: isLastPage
            ? Text(
                "Начать!",
                style: DarkTextTheme.buttonS,
              )
            : const Icon(Icons.arrow_forward_ios, color: DarkThemeColors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPrimary: DarkThemeColors.primary.withOpacity(0.25),
        shadowColor: const Color(0x7f000000),
        primary: DarkThemeColors.primary,
        elevation: 8.0,
      ),
    );
  }
}
