import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'bounded.dart';
part 'hero_skeleton.dart';
part 'row_skeleton.dart';

class CategoryFeedLoaderItem extends StatefulWidget {
  const CategoryFeedLoaderItem({super.key, this.onPresented});

  final VoidCallback? onPresented;

  @override
  State<CategoryFeedLoaderItem> createState() => _CategoryFeedLoaderItemState();
}

class _CategoryFeedLoaderItemState extends State<CategoryFeedLoaderItem> {
  @override
  void initState() {
    super.initState();
    widget.onPresented?.call();
  }

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Column(
        children: [
          _HeroSkeleton(),
          _RowSkeleton(),
          _RowSkeleton(),
          _RowSkeleton(isLast: true),
        ],
      ),
    );
  }
}
