import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_ninja_mark.dart';
import 'package:flutter/widgets.dart';

class AppEntryBrand extends StatelessWidget {
  const AppEntryBrand({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 44,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppNinjaMark(size: 28, color: context.colors.ink),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.labelStrong.copyWith(color: context.colors.ink),
              ),
            ),
          ],
        ),
      );
}
