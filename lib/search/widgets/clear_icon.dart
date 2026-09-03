part of 'search_history_item.dart';

class _ClearIcon extends StatelessWidget {
  const _ClearIcon();

  @override
  Widget build(BuildContext context) {
    return AppLineIconWidget(
      .close,
      size: 17,
      color: context.colors.muted,
    );
  }
}
