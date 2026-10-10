import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TeacherDaySizeReporter extends SingleChildRenderObjectWidget {
  const TeacherDaySizeReporter({
    required this.onSize,
    required super.child,
    super.key,
  });

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _TeacherDaySizeRender(onSize);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderObject renderObject,
  ) => (renderObject as _TeacherDaySizeRender).onSize = onSize;
}

class _TeacherDaySizeRender extends RenderProxyBox {
  _TeacherDaySizeRender(this.onSize);

  ValueChanged<Size> onSize;
  Size? _reported;

  @override
  void performLayout() {
    super.performLayout();
    if (size == _reported) return;
    final measured = _reported = size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached && size == measured) onSize(measured);
    });
  }
}
