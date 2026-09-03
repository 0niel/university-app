part of 'group_space_view.dart';

class _GroupPostDetails extends StatelessWidget {
  const _GroupPostDetails({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) => Text(
    body.isEmpty ? '—' : body,
    style: AppText.body.copyWith(
      color: context.colors.muted,
      height: 1.5,
    ),
  );
}
