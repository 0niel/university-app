part of '../../create_deadline_sheet.dart';

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      child: AppPressable(
        onTap: () => onChanged(!value),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.ninja.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.control),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: NinjaText.body),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: NinjaText.helper.copyWith(
                          color: context.ninja.mutedDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ExcludeSemantics(
                  child: NinjaSwitch(value: value, onChanged: onChanged),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
