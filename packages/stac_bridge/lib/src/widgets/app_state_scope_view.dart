import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';
import 'package:stac_bridge/src/widgets/reactive_mini_app_node.dart';
import 'package:stac_bridge/src/widgets/stac_app_state_scope.dart';

class AppStateScopeView extends StatefulWidget {
  const AppStateScopeView({required this.model, super.key});

  final StacAppStateScope model;

  @override
  State<AppStateScopeView> createState() => _AppStateScopeViewState();
}

class _AppStateScopeViewState extends State<AppStateScopeView> {
  late final MiniAppStateStore _store = MiniAppStateStore()
    ..seed(widget.model.initial);

  @override
  void didUpdateWidget(covariant AppStateScopeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _store.reconcile(widget.model.initial);
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.model.child;
    if (child == null) return const SizedBox.shrink();
    return MiniAppStateScope(
      store: _store,
      child: Builder(
        builder: (context) {
          _store.actionContext = context;
          return ReactiveMiniAppNode(node: child);
        },
      ),
    );
  }
}
