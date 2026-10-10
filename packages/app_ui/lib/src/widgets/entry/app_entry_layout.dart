import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/entry/app_entry_stage_layout.dart';
import 'package:flutter/widgets.dart';

enum AppEntryPresentation { scroll, staged }

class AppEntryLayout extends StatelessWidget {
  const AppEntryLayout({
    required this.title,
    required this.child,
    super.key,
    this.titleAccent,
    this.subtitle,
    this.eyebrow,
    this.header,
    this.visual,
    this.actions,
    this.hero = false,
    this.presentation = AppEntryPresentation.scroll,
    this.contentIdentity,
  });

  final String title;
  final String? titleAccent;
  final String? subtitle;
  final String? eyebrow;
  final Widget? header;
  final Widget? visual;
  final Widget? actions;
  final Widget child;
  final bool hero;
  final AppEntryPresentation presentation;
  final Object? contentIdentity;

  static const horizontalPadding = 24.0;
  static const topPadding = 16.0;
  static const bottomPadding = 24.0;
  static const maxWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final safe = MediaQuery.paddingOf(context);
    final bottom = math.max(bottomPadding, safe.bottom + 16);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!,
            style: AppText.overline.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 12),
        ],
        AppEntryTitle(title, accent: titleAccent, hero: hero),
        if (subtitle != null) ...[
          const SizedBox(height: 14),
          Text(
            subtitle!,
            style: AppText.bodyLarge.copyWith(
              color: colors.muted,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
        const SizedBox(height: 28),
        child,
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final inset = math.max(
          horizontalPadding,
          (constraints.maxWidth - maxWidth) / 2,
        );
        if (presentation == AppEntryPresentation.staged) {
          return AppEntryStageLayout(
            header: header,
            actions: actions,
            contentIdentity: contentIdentity,
            inset: inset,
            top: safe.top + topPadding,
            bottom: bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (visual != null) ...[
                  visual!,
                  const SizedBox(height: 24),
                ],
                content,
              ],
            ),
          );
        }
        return CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                inset,
                safe.top + topPadding,
                inset,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (header != null) header!,
                    if (visual != null) ...[
                      const SizedBox(height: 16),
                      visual!,
                      const SizedBox(height: 24),
                    ] else
                      SizedBox(height: hero ? 40 : 32),
                    content,
                  ],
                ),
              ),
            ),
            if (actions != null)
              SliverLayoutBuilder(
                builder: (context, sliver) => SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: math.max(
                        0,
                        sliver.viewportMainAxisExtent -
                            sliver.precedingScrollExtent,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(inset, 24, inset, bottom),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [actions!],
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(child: SizedBox(height: bottom)),
          ],
        );
      },
    );
  }
}

class AppEntryTitle extends StatelessWidget {
  const AppEntryTitle(this.text, {super.key, this.accent, this.hero = false});

  final String text;
  final String? accent;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final style = (hero ? AppText.entryHero : AppText.entryTitle).copyWith(
      color: context.colors.ink,
    );
    final word = accent ?? '';
    final index = word.isEmpty ? -1 : text.lastIndexOf(word);
    if (index < 0) return Text(text, style: style);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: word,
            style: AppText.serif(
              style.fontSize!,
              height: style.height!,
              italic: true,
            ).copyWith(color: context.colors.ink),
          ),
          TextSpan(text: text.substring(index + word.length)),
        ],
      ),
    );
  }
}
