import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';

class AddGroupButton extends StatelessWidget {
  const AddGroupButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedAddSquare,
        size: 24,
        color: Theme.of(context).extension<AppColors>()!.active,
      ),
      material: (_, __) => MaterialIconButtonData(
        padding: const EdgeInsets.all(16.0),
        tooltip: 'Добавить группу',
      ),
      onPressed: onPressed,
    );
  }
}
