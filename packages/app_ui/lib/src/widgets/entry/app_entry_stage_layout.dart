import 'dart:math' as math;

import 'package:app_ui/src/widgets/entry/app_entry_body_transition.dart';
import 'package:flutter/widgets.dart';

class AppEntryStageLayout extends StatelessWidget {
  const AppEntryStageLayout({
    required this.child,
    required this.inset,
    required this.top,
    required this.bottom,
    this.header,
    this.actions,
    this.contentIdentity,
    super.key,
  });

  final Widget child;
  final Widget? header;
  final Widget? actions;
  final Object? contentIdentity;
  final double inset;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null)
              Padding(
                key: const ValueKey('entry-stage-header'),
                padding: EdgeInsets.fromLTRB(inset, top, inset, 12),
                child: header,
              ),
            Expanded(
              child: ClipRect(
                child: AppEntryBodyTransition(
                  identity: contentIdentity,
                  child: SingleChildScrollView(
                    key: ValueKey(('entry-stage-body', contentIdentity)),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(inset, 12, inset, 24),
                    child: child,
                  ),
                ),
              ),
            ),
            if (actions != null)
              ConstrainedBox(
                key: const ValueKey('entry-stage-footer'),
                constraints: BoxConstraints(
                  maxHeight: math.max(0, constraints.maxHeight / 2),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(inset, 16, inset, bottom),
                  child: actions,
                ),
              ),
          ],
        ),
      );
}
