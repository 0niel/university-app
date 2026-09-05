import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';

class StacReactiveNodeParser extends StacParser<Map<String, Object?>> {
  const StacReactiveNodeParser();

  @override
  String get type => 'appReactiveNode';

  @override
  Map<String, Object?> getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, Map<String, Object?> model) {
    final node = model['node'];
    if (node is! Map<Object?, Object?>) return const SizedBox.shrink();
    final bindings = model['bindings'];
    return ReactiveMiniAppNode(
      node: Map<String, Object?>.from(node),
      bindings: bindings is Map<Object?, Object?>
          ? Map<String, Object?>.from(bindings)
          : const {},
    );
  }
}

class ReactiveMiniAppNode extends StatefulWidget {
  ReactiveMiniAppNode({required this.node, this.bindings = const {}})
    : super(key: node['key'] is String ? ValueKey(node['key']) : null);

  final Map<String, Object?> node;
  final Map<String, Object?> bindings;

  @override
  State<ReactiveMiniAppNode> createState() => _ReactiveMiniAppNodeState();
}

class _ReactiveMiniAppNodeState extends State<ReactiveMiniAppNode> {
  static final _resolver = MiniAppTreeResolver(
    defaultMiniAppExpressionEngine,
    deferActions: true,
    deferWidgets: true,
  );
  static const _equality = DeepCollectionEquality();
  Map<String, Object?>? _resolved;
  Object? _boundValue;
  Widget? _child;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _child = null;
  }

  @override
  Widget build(BuildContext context) {
    final store = MiniAppStateScope.of(context);
    Widget resolve(BuildContext context) {
      final resolved = _resolver.resolveTree(widget.node, {
        ...widget.bindings,
        'state': store?.snapshot() ?? const {},
      });
      final key = widget.node['stateKey'];
      final boundValue = key is String ? store?.get(key) : null;
      if (_child == null ||
          !_equality.equals(_resolved, resolved) ||
          !_equality.equals(_boundValue, boundValue)) {
        _resolved = resolved;
        _boundValue = boundValue;
        _child = resolved == null
            ? const SizedBox.shrink()
            : Stac.fromJson(resolved, context) ?? const SizedBox.shrink();
      }
      return _child!;
    }

    if (store == null) return resolve(context);
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => resolve(context),
    );
  }
}
