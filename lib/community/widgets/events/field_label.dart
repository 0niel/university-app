part of '../create_event_sheet.dart';

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: AppText.overline.copyWith(color: context.colors.muted),
  );
}
