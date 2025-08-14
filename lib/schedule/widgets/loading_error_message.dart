import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LoadingErrorMessage extends StatelessWidget {
  const LoadingErrorMessage({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTable = MediaQuery.of(context).size.width > tabletBreakpoint;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isTable ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Center(child: Assets.images.saly2.image(height: 200)),
            const SizedBox(height: 8),
            Text(context.l10n.error, style: AppTextStyle.h5),
            const SizedBox(height: 8),
            Text(context.l10n.scheduleLoadError, style: AppTextStyle.captionL.copyWith(color: AppColors.dark.deactive)),
            const SizedBox(height: 24),
            SizedBox(
              width: isTable ? 420 : double.infinity,
              child: ColorfulButton(text: context.l10n.retry, onClick: onTap, backgroundColor: AppColors.dark.primary),
            ),
          ],
        ),
      ),
    );
  }
}
