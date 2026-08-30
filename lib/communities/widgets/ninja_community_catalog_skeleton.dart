import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'community_catalog_skeleton_row.dart';

class NinjaCommunityCatalogSkeleton extends StatelessWidget {
  const NinjaCommunityCatalogSkeleton({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: compact ? 3 : 6,
        itemBuilder: (_, index) => _CommunityCatalogSkeletonRow(
          showDescription: compact || index.isEven,
        ),
      ),
    );
  }
}
