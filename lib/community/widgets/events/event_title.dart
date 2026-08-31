part of '../featured_event_card.dart';

class _EventTitle extends StatelessWidget {
  const _EventTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: NinjaText.title.copyWith(color: context.ninja.onAccentSoft),
    );
  }
}
