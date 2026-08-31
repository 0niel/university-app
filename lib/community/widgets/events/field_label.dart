part of '../create_event_sheet.dart';

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: NinjaText.microLabel.copyWith(color: context.ninja.muted),
  );
}
