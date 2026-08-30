import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';

class MiniAppStateScope extends InheritedNotifier<MiniAppStateStore> {
  const MiniAppStateScope({
    required MiniAppStateStore store,
    required super.child,
    super.key,
  }) : super(notifier: store);

  static MiniAppStateStore? of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<MiniAppStateScope>()?.notifier;
}
