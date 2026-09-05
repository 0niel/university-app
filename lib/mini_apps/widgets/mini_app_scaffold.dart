import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MiniAppScaffold extends StatelessWidget {
  const MiniAppScaffold({
    required this.title,
    required this.body,
    super.key,
    this.onBack,
    this.actions = const [],
    this.scrollingHeader = const [],
  });

  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final List<AppHeaderAction> actions;
  final List<Widget> scrollingHeader;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.canvas,
    body: SafeArea(
      bottom: false,
      top: false,
      child: scrollingHeader.isNotEmpty
          ? NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: AppInnerHeader(
                    title: title,
                    onBack: onBack ?? () => Navigator.of(context).maybePop(),
                    backSemanticsLabel: context.l10n.back,
                    actions: actions,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.lg),
                ),
                for (final child in scrollingHeader)
                  SliverToBoxAdapter(child: child),
              ],
              body: body,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInnerHeader(
                  title: title,
                  onBack: onBack ?? () => Navigator.of(context).maybePop(),
                  backSemanticsLabel: context.l10n.back,
                  actions: actions,
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(child: body),
              ],
            ),
    ),
  );
}
