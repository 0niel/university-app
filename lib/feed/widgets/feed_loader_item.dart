import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_skeletons.dart';

class FeedLoaderItem extends StatefulWidget {
  const FeedLoaderItem({super.key, this.onPresented, this.hero = false});

  final VoidCallback? onPresented;
  final bool hero;

  @override
  State<FeedLoaderItem> createState() => _FeedLoaderItemState();
}

class _FeedLoaderItemState extends State<FeedLoaderItem> {
  @override
  void initState() {
    super.initState();
    widget.onPresented?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: widget.hero ? AppSpacing.zero : AppSpacing.gap,
      ),
      child: FeedListSkeleton(hero: widget.hero),
    );
  }
}
