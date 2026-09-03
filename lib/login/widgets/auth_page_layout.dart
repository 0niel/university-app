import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/accent_title.dart';
import 'package:rtu_mirea_app/login/widgets/auth_progress.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    required this.title,
    required this.child,
    super.key,
    this.titleAccent,
    this.subtitle,
    this.leading,
    this.showBack = true,
    this.onBack,
    this.step,
    this.totalSteps,
    this.actions,
    this.large = false,
  });

  final String title;
  final String? titleAccent;
  final String? subtitle;
  final Widget child;
  final Widget? leading;
  final bool showBack;
  final VoidCallback? onBack;
  final int? step;
  final int? totalSteps;
  final Widget? actions;
  final bool large;

  static const double horizontalPadding = 24;
  static const double topPadding = 60;
  static const double bottomPadding = 40;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final padding = MediaQuery.paddingOf(context);
    final top = math.max(topPadding, padding.top + 16);
    final bottom = math.max(bottomPadding, padding.bottom + 16);
    final step = this.step;
    final totalSteps = this.totalSteps;
    final subtitle = this.subtitle;
    final actions = this.actions;
    final leading = this.leading;
    final titleStyle = large ? AppText.displayLarge : AppText.displayHero;
    final leadStyle = large
        ? AppText.lead.copyWith(height: 1.45, color: colors.muted)
        : AppText.bodyLarge.copyWith(height: 1.45, color: colors.muted);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            top,
            horizontalPadding,
            AppSpacing.zero,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (step != null && totalSteps != null) ...[
                  AuthProgress(step: step, total: totalSteps),
                  const SizedBox(height: 28),
                ],
                if (showBack)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Semantics(
                        label: context.l10n.back,
                        child: AppBackButton(onPressed: onBack),
                      ),
                    ),
                  ),
                if (leading != null) ...[
                  if (showBack) const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: leading,
                  ),
                ],
                SizedBox(height: large ? 32 : 24),
                AccentTitle(title, accent: titleAccent, style: titleStyle),
                if (subtitle != null) ...[
                  SizedBox(height: large ? 16 : 10),
                  Text(subtitle, style: leadStyle),
                ],
                SizedBox(height: large ? 28 : 20),
                child,
              ],
            ),
          ),
        ),
        if (actions != null)
          SliverLayoutBuilder(
            builder: (context, constraints) => SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: math.max(
                    AppSpacing.zero,
                    constraints.viewportMainAxisExtent -
                        constraints.precedingScrollExtent,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.xlg,
                    horizontalPadding,
                    bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [actions],
                  ),
                ),
              ),
            ),
          )
        else
          SliverToBoxAdapter(child: SizedBox(height: bottom)),
      ],
    );
  }
}
