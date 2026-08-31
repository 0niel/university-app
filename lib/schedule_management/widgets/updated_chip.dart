part of 'primary_schedule_card.dart';

class _UpdatedChip extends StatelessWidget {
  const _UpdatedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: NinjaText.helper.copyWith(color: context.ninja.onAccentSoftMuted),
    );
  }
}
