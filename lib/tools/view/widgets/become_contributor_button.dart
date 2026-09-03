import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class BecomeContributorButton extends StatelessWidget {
  const BecomeContributorButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton.tonal(
      label: context.l10n.toolsBecomeContributor,
      icon: const AppLineIconWidget(AppLineIcon.plus),
      expanded: true,
      onPressed: onTap,
    );
  }
}
