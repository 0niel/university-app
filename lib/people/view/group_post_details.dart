part of 'group_space_view.dart';

class _GroupPostDetails extends StatelessWidget {
  const _GroupPostDetails({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) => Text(
    body.isEmpty ? '—' : body,
    style: NinjaText.body.copyWith(
      color: context.ninja.mutedDark,
      height: 1.5,
    ),
  );
}
