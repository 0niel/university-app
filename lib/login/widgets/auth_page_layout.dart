import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/login/widgets/auth_progress.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    required this.title,
    required this.child,
    super.key,
    this.titleAccent,
    this.subtitle,
    this.leading,
    this.visual,
    this.eyebrow,
    this.headerTrailing,
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
  final Widget? visual;
  final String? eyebrow;
  final Widget? headerTrailing;
  final bool showBack;
  final VoidCallback? onBack;
  final int? step;
  final int? totalSteps;
  final Widget? actions;
  final bool large;

  static const double horizontalPadding = AppEntryLayout.horizontalPadding;
  static const double topPadding = AppEntryLayout.topPadding;
  static const double bottomPadding = AppEntryLayout.bottomPadding;

  @override
  Widget build(BuildContext context) {
    final previewTheme = Theme.of(context);
    return AppEntryTheme(
      child: Builder(
        builder: (context) {
          return AppEntryLayout(
            title: title,
            titleAccent: titleAccent,
            subtitle: subtitle,
            eyebrow: eyebrow,
            hero: large,
            visual:
                (visual == null
                    ? null
                    : Theme(data: previewTheme, child: visual!)) ??
                (leading == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: leading,
                        ),
                      )),
            header: Row(
              children: [
                if (showBack)
                  AppBackButton(onPressed: onBack)
                else
                  Flexible(
                    child: AppEntryBrand(
                      label:
                          context.read<UniversityConfig?>()?.appName ??
                          UniversityConfig.current.appName,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child:
                        headerTrailing ??
                        (step != null && totalSteps != null
                            ? AuthProgress(step: step!, total: totalSteps!)
                            : const SizedBox.shrink()),
                  ),
                ),
              ],
            ),
            actions: actions,
            child: child,
          );
        },
      ),
    );
  }
}
