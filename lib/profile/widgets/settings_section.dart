import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_card.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.label,
    required this.children,
    super.key,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            28,
            NinjaMetrics.screenPadding,
            8,
          ),
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.title.copyWith(color: colors.ink),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NinjaMetrics.screenPadding,
          ),
          child: SettingsCard(children: children),
        ),
      ],
    );
  }
}
