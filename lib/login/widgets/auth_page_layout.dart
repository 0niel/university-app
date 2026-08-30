import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/ninja_logo_badge.dart';

part 'auth_back_button.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
    this.showBack = false,
    this.onBack,
    this.footer,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? footer;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final titleStyle = compact ? NinjaText.title : NinjaText.display;
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: .fromLTRB(
            NinjaMetrics.screenPadding,
            10,
            NinjaMetrics.screenPadding,
            24 + bottomPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - 34).clamp(0, double.infinity),
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  SizedBox(
                    height: NinjaMetrics.minTouchTarget,
                    child: showBack
                        ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: _AuthBackButton(onTap: onBack),
                          )
                        : null,
                  ),
                  SizedBox(height: compact ? 18 : 28),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: NinjaLogoBadge(
                      size: compact ? 56 : 64,
                      spin: false,
                    ),
                  ),
                  SizedBox(height: compact ? 20 : 26),
                  Text(title, style: titleStyle.copyWith(color: colors.ink)),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: NinjaText.body.copyWith(color: colors.mutedDark),
                  ),
                  SizedBox(height: compact ? 24 : 30),
                  child,
                  const Spacer(),
                  if (footer != null) ...[
                    const SizedBox(height: 24),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
