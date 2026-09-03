part of '../people_widgets.dart';

class NinjaPeopleSectionHeader extends StatelessWidget {
  const NinjaPeopleSectionHeader(this.text, {super.key, this.topPadding = 28});

  final String text;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .fromLTRB(
        AppSpacing.screen,
        topPadding,
        AppSpacing.screen,
        8,
      ),
      child: Text(
        text,
        maxLines: 2,
        overflow: .ellipsis,
        style: AppText.title.copyWith(color: context.colors.ink),
      ),
    );
  }
}
