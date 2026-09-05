import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/tour/model/app_tour_target.dart';

abstract final class AppTourAnchors {
  static final Map<AppTourTarget, List<BuildContext>> _anchors = {};

  static void register(AppTourTarget target, BuildContext context) =>
      _anchors.putIfAbsent(target, () => <BuildContext>[]).add(context);

  static void unregister(AppTourTarget target, BuildContext context) =>
      _anchors[target]?.remove(context);

  static BuildContext? contextOf(AppTourTarget target) {
    final contexts = _anchors[target];
    if (contexts == null) return null;
    for (final candidate in contexts.reversed) {
      if (_boxOf(candidate) != null) return candidate;
    }
    return null;
  }

  static Rect? rectOf(AppTourTarget target) {
    final context = contextOf(target);
    if (context == null) return null;
    return rectOfContext(context);
  }

  static Rect? rectOfContext(BuildContext context) {
    final box = _boxOf(context);
    if (box == null) return null;
    final origin = box.localToGlobal(Offset.zero);
    if (!origin.dx.isFinite || !origin.dy.isFinite) return null;
    final bottomRight = box.localToGlobal(box.size.bottomRight(Offset.zero));
    if (!bottomRight.dx.isFinite || !bottomRight.dy.isFinite) return null;
    return Rect.fromPoints(origin, bottomRight);
  }

  static RenderBox? _boxOf(BuildContext context) {
    if (!context.mounted) return null;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.size.isEmpty ? null : box;
  }
}

class AppTourAnchor extends StatefulWidget {
  const AppTourAnchor({
    required this.target,
    required this.child,
    super.key,
  });

  final AppTourTarget target;
  final Widget child;

  @override
  State<AppTourAnchor> createState() => _AppTourAnchorState();
}

class _AppTourAnchorState extends State<AppTourAnchor> {
  @override
  void initState() {
    super.initState();
    AppTourAnchors.register(widget.target, context);
  }

  @override
  void didUpdateWidget(AppTourAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target == widget.target) return;
    AppTourAnchors.unregister(oldWidget.target, context);
    AppTourAnchors.register(widget.target, context);
  }

  @override
  void dispose() {
    AppTourAnchors.unregister(widget.target, context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
