import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/material.dart';

class AppEntryPreview extends StatelessWidget {
  const AppEntryPreview({
    required this.child,
    this.viewport = const Size(390, 350),
    super.key,
  });

  final Widget child;
  final Size viewport;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height =
        (MediaQuery.sizeOf(context).height * .36).clamp(220.0, 320.0);
    return ExcludeSemantics(
      child: ExcludeFocus(
        child: IgnorePointer(
          child: RepaintBoundary(
            child: SizedBox(
              height: height,
              child: FittedBox(
                child: Container(
                  width: viewport.width,
                  height: viewport.height,
                  decoration: BoxDecoration(
                    color: colors.canvas,
                    borderRadius: BorderRadius.circular(AppRadius.hero),
                    border: Border.all(
                      color: colors.ink.withValues(alpha: .12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.scrim.withValues(alpha: .12),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: viewport,
                      padding: EdgeInsets.zero,
                      viewPadding: EdgeInsets.zero,
                      viewInsets: EdgeInsets.zero,
                      textScaler: TextScaler.noScaling,
                    ),
                    child: AppPreviewScope(child: child),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppPreviewScope extends InheritedWidget {
  const AppPreviewScope({required super.child, super.key});

  static bool of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppPreviewScope>() != null;

  @override
  bool updateShouldNotify(AppPreviewScope oldWidget) => false;
}
