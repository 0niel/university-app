import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';
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

  static final _resolver = MiniAppTreeResolver(defaultMiniAppExpressionEngine);

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
      child: ListenableBuilder(
        listenable: _store,
        builder: (context, _) {
          final resolved = _resolver.resolveTree(child, {
            'state': _store.snapshot(),
          });
          if (resolved == null) return const SizedBox.shrink();
          return Stac.fromJson(resolved, context) ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
