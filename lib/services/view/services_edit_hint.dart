import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ServicesEditHint extends StatelessWidget {
  const ServicesEditHint({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        16,
      ),
      child: NinjaCard(
        outlined: true,
        accent: colors.brand,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLineIconWidget(
              AppLineIcon.pin,
              size: 19,
              color: colors.brandInk,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.servicesConfigureHint,
                style: NinjaText.subtext.copyWith(
                  color: colors.mutedDark,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
