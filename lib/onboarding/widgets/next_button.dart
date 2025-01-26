import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/src/provider.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:app_ui/app_ui.dart';

/// Get next button to open next page
/// or to close onboarding and start main app
class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.isLastPage, required this.onClick});

  final bool isLastPage;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isLastPage) {
          context.read<HomeCubit>().closeOnboarding();
          context.go('/schedule');
        } else {
          onClick();
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).extension<AppColors>()!.primary.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Theme.of(context).extension<AppColors>()!.primary,
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
                  color: Theme.of(context).extension<AppColors>()!.white,
                ),
              )
            : Icon(Icons.arrow_forward_ios, color: Theme.of(context).extension<AppColors>()!.active),
      ),
    );
  }
}
