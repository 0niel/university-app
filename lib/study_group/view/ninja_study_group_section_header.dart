part of 'study_group_page.dart';

class NinjaStudyGroupSectionHeader extends StatelessWidget {
  const NinjaStudyGroupSectionHeader(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppText.title.copyWith(color: context.colors.ink),
  );
}
