part of '../schedule_details_page.dart';

class _EmptyMaterialsCard extends StatelessWidget {
  const _EmptyMaterialsCard({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: onTap,
    semanticsLabel: context.l10n.lessonDetailsEmptyMaterialsTitle,
    child: Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const .all(16),
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: .center,
            decoration: BoxDecoration(
              color: context.ninja.brandTint,
              shape: .circle,
            ),
            child: AppLineIconWidget(
              AppLineIcon.upload,
              color: context.ninja.brandInk,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.lessonDetailsEmptyMaterialsTitle,
            textAlign: .center,
            style: NinjaText.body.copyWith(color: context.ninja.ink),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.lessonDetailsEmptyMaterialsSub,
            textAlign: .center,
            style: NinjaText.subtext.copyWith(color: context.ninja.muted),
          ),
        ],
      ),
    ),
  );
}
