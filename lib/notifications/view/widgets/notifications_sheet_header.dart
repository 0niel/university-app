import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NotificationsSheetHeader extends StatelessWidget {
  const NotificationsSheetHeader({required this.onReadAll, super.key});

  final VoidCallback? onReadAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final titleStyle = AppText.sectionLarge.copyWith(
      height: 1.3,
      color: colors.ink,
    );
    final actionStyle = AppText.labelStrong.copyWith(
      color: onReadAll == null ? colors.muted2 : colors.accent,
    );
    if (MediaQuery.textScalerOf(context).scale(1) >= 1.5) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.notifications, style: titleStyle),
            AppButton.text(
              label: l10n.notificationsReadAll,
              textStyle: actionStyle,
              foregroundColor: actionStyle.color,
              size: AppButtonSize.small,
              padding: EdgeInsets.zero,
              onPressed: onReadAll,
            ),
          ],
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: l10n.notificationsReadAll, style: actionStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          locale: Localizations.localeOf(context),
        )..layout(maxWidth: constraints.maxWidth / 2);
        final actionWidth = painter.width;
        painter.dispose();
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
              child: Row(
                children: [
                  Expanded(child: Text(l10n.notifications, style: titleStyle)),
                  const SizedBox(width: AppSpacing.sm),
                  SizedBox(
                    width: actionWidth,
                    child: ExcludeSemantics(
                      child: Text(
                        l10n.notificationsReadAll,
                        style: actionStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 0,
              bottom: 0,
              end: 0,
              width: actionWidth < AppControlSize.touchTarget
                  ? AppControlSize.touchTarget
                  : actionWidth,
              child: AppPressable(
                onTap: onReadAll,
                enabled: onReadAll != null,
                semanticsButton: true,
                semanticsLabel: l10n.notificationsReadAll,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        );
      },
    );
  }
}
