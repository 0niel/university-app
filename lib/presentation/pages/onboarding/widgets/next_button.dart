import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/src/provider.dart';
import 'package:rtu_mirea_app/presentation/bloc/app_cubit/app_cubit.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
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
          context.go('/schedule');
        } else {
          onClick();
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppTheme.colors.primary.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.colors.primary,
        shadowColor: const Color(0x7f000000),
        elevation: 8.0,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isLastPage
            ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0)
            : const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
        child: isLastPage
            ? Text(
                "Начать!",
                style: AppTextStyle.buttonS.copyWith(
                  color: AppTheme.colors.white,
                ),
              )
            : Icon(Icons.arrow_forward_ios, color: AppTheme.colors.active),
      ),
    );
  }
}
