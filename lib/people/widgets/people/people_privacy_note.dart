part of '../people_widgets.dart';

class PeoplePrivacyNote extends StatelessWidget {
  const PeoplePrivacyNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          AppLineIconWidget(
            .people,
            size: 16,
            color: colors.muted,
          ),
          Expanded(
            child: Text(
              text,
              style: AppText.caption.copyWith(
                color: colors.muted,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
