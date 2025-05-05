import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/app.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({super.key, required this.message, required this.icon, this.buttonText, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isLoggedIn = context.select<AppBloc, bool>((bloc) => bloc.state.status.isLoggedIn);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context),
            const SizedBox(height: 24),
            Text(
              message,
              style: AppTextStyle.titleM.copyWith(color: appColors.active, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isLoggedIn
                  ? 'Объявлений пока нет. Вы можете создать первое объявление прямо сейчас.'
                  : 'Объявлений пока нет. Авторизуйтесь, чтобы создать объявление.',
              style: AppTextStyle.body.copyWith(color: appColors.deactive),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 240,
                child: ElevatedButton.icon(
                  onPressed: onButtonPressed,
                  icon: Icon(isLoggedIn ? Icons.add : Icons.login),
                  label: Text(buttonText!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(color: appColors.primary.withOpacity(0.1), shape: BoxShape.circle),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: appColors.surface,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: appColors.cardShadowLight, blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, size: 50, color: appColors.primary),
        ),
      ],
    );
  }
}
