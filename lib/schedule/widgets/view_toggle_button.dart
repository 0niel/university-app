import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';

class ViewToggleButton extends StatelessWidget {
  const ViewToggleButton({
    super.key,
    required this.isListModeEnabled,
    required this.onPressed,
  });

  final bool isListModeEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      onPressed: onPressed,
      material: (_, __) => MaterialIconButtonData(
        iconSize: 24,
        padding: const EdgeInsets.all(16.0),
        tooltip: 'Переключить вид',
      ),
      cupertino: (_, __) => CupertinoIconButtonData(
        padding: const EdgeInsets.all(16.0),
      ),
      icon: AnimatedSwitcher(
        duration: 300.ms,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: HugeIcon(
          key: ValueKey<bool>(isListModeEnabled),
          icon: isListModeEnabled ? HugeIcons.strokeRoundedListView : HugeIcons.strokeRoundedCalendar02,
          size: 24,
          color: Theme.of(context).extension<AppColors>()!.active,
        ),
      ),
    );
  }
}
