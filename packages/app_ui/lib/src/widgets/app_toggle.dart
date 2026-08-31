import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppToggle extends StatelessWidget {
  const AppToggle({
    required this.value,
    super.key,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) =>
      NinjaSwitch(value: value, onChanged: onChanged);
}

class AppLangToggle extends StatelessWidget {
  const AppLangToggle({
    required this.value,
    required this.options,
    super.key,
    this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);
    return SizedBox(
      width: 96,
      height: 44,
      child: Row(
        children: [
          for (var index = 0; index < options.length; index++) ...[
            if (index > 0) const SizedBox(width: 4),
            Expanded(
              child: Builder(
                builder: (context) {
                  final option = options[index];
                  final selected = option == value;
                  return AppPressable(
                    haptics: !selected,
                    onTap: onChanged == null
                        ? null
                        : () {
                            if (!selected) onChanged?.call(option);
                          },
                    semanticsLabel: option,
                    semanticsButton: true,
                    semanticsSelected: selected,
                    child: AnimatedContainer(
                      duration: duration,
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        color: selected ? colors.brand : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          NinjaRadius.button,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AnimatedDefaultTextStyle(
                        duration: duration,
                        style: NinjaText.buttonSmall.copyWith(
                          color: selected ? colors.onBrand : colors.mutedDark,
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w700,
                        ),
                        child: Text(option),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
