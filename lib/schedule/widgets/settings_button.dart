import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedSettings02,
        size: 24,
        color: Theme.of(context).extension<AppColors>()!.active,
      ),
      material: (_, __) => MaterialIconButtonData(
        padding: const EdgeInsets.all(16.0),
        tooltip: 'Управление расписанием',
      ),
      onPressed: onPressed,
    );
  }
}
