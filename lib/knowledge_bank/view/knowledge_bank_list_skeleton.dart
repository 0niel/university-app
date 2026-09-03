import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'material_card_skeleton.dart';

class KnowledgeBankListSkeleton extends StatelessWidget {
  const KnowledgeBankListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: context.l10n.loadingContent,
      child: ExcludeSemantics(
        child: NinjaSkeletonGroup(
          child: AppListGroup(
            children: List.generate(4, (_) => const _MaterialCardSkeleton()),
          ),
        ),
      ),
    );
  }
}
