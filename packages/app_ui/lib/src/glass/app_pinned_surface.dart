import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/widgets.dart';

class AppPinnedSurface extends StatelessWidget {
  const AppPinnedSurface({
    required this.elevated,
    required this.child,
    super.key,
  });

  final bool elevated;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.passthrough,
    children: [
      Positioned.fill(
        child: ExcludeSemantics(
          child: IgnorePointer(
            child: elevated
                ? const AppGlassSurface(
                    role: AppGlassRole.pinned,
                    borderRadius: AppRadius.none,
                    child: SizedBox.expand(),
                  )
                : const SizedBox.expand(),
          ),
        ),
      ),
      child,
    ],
  );
}
