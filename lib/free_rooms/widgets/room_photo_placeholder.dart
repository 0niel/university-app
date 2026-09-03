import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class RoomPhotoPlaceholder extends StatelessWidget {
  const RoomPhotoPlaceholder({super.key});

  static const double height = 150;
  static const labelPadding = EdgeInsets.symmetric(horizontal: 9, vertical: 5);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: height,
      child: AppStripePlaceholder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.checkbox),
          ),
          child: Padding(
            padding: labelPadding,
            child: Text(
              context.l10n.roomPhotoPlaceholder,
              style: AppText.sans(11, FontWeight.w400).copyWith(
                fontFamily: 'monospace',
                fontFamilyFallback: const [AppText.sansFamily],
                color: colors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
