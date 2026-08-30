part of 'teacher_profile_page.dart';

class _StarsRow extends StatelessWidget {
  const _StarsRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: NinjaText.body.copyWith(color: colors.ink),
            ),
          ),
          for (var i = 1; i <= 5; i++)
            AppPressable(
              onTap: () => onChanged(i),
              semanticsLabel: '$label $i',
              semanticsSelected: i <= value,
              child: SizedBox.square(
                dimension: NinjaMetrics.minTouchTarget,
                child: Center(
                  child: Text(
                    '★',
                    style: TextStyle(
                      fontSize: 22,
                      color: i <= value ? colors.brand : colors.disabledLine,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
