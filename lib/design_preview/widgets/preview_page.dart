import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(
      0,
      AppSpacing.lg,
      0,
      MediaQuery.paddingOf(context).bottom + AppSpacing.xlg,
    ),
    children: [
      for (final child in children) ...[
        if (child is PreviewPageRail)
          child
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: child,
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    ],
  );
}

class PreviewPageRail extends StatelessWidget {
  const PreviewPageRail({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
