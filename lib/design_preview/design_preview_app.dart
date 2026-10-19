import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_home_page.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_map_page.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_profile_page.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_schedule_page.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_services_page.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/view/navigation_branch_container.dart';

class DesignPreviewApp extends StatefulWidget {
  const DesignPreviewApp({super.key});

  @override
  State<DesignPreviewApp> createState() => _DesignPreviewAppState();
}

class _DesignPreviewAppState extends State<DesignPreviewApp> {
  ThemeMode _theme = ThemeMode.dark;
  Locale _locale = const Locale('ru');
  bool _glassEnabled = true;
  int _tab = 0;

  void _select(int index) => setState(() => _tab = index);

  @override
  Widget build(BuildContext context) => MaterialApp(
    scrollBehavior: const AppScrollBehavior(),
    debugShowCheckedModeBanner: false,
    theme: AppTheme.generateTheme(
      AppColors.light,
      Brightness.light,
      glassEnabled: _glassEnabled,
    ),
    darkTheme: AppTheme.generateTheme(
      AppColors.dark,
      Brightness.dark,
      glassEnabled: _glassEnabled,
    ),
    themeMode: _theme,
    locale: _locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) {
        final l10n = context.l10n;
        final items = [
          NinjaBottomBarItem(
            icon: const AppLineIconWidget(AppLineIcon.home),
            label: l10n.navHome,
          ),
          NinjaBottomBarItem(
            icon: const AppLineIconWidget(AppLineIcon.calendar),
            label: l10n.navSchedule,
          ),
          NinjaBottomBarItem(
            icon: const AppLineIconWidget(AppLineIcon.map),
            label: l10n.navMap,
          ),
          NinjaBottomBarItem(
            icon: const AppLineIconWidget(AppLineIcon.services),
            label: l10n.navServices,
          ),
          NinjaBottomBarItem(
            icon: const AppLineIconWidget(AppLineIcon.user),
            label: l10n.navProfile,
          ),
        ];
        final pages = [
          PreviewHomePage(onTab: _select),
          const PreviewSchedulePage(),
          const PreviewMapPage(),
          PreviewServicesPage(onTab: _select),
          PreviewProfilePage(onTab: _select),
        ];
        final toolbarHeight = math.max(
          AppControlSize.buttonHero,
          MediaQuery.textScalerOf(context).scale(14) * 2.6,
        );
        return Scaffold(
          extendBody: true,
          backgroundColor: context.colors.canvas,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(toolbarHeight),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                child: SizedBox(
                  height: toolbarHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.settingsAppearance,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label,
                        ),
                      ),
                      Semantics(
                        toggled: _glassEnabled,
                        child: AppIconButton(
                          tooltip: l10n.settingsGlassEffectTitle,
                          icon: AppLineIconWidget(
                            AppLineIcon.spark,
                            color: _glassEnabled
                                ? context.colors.accent
                                : context.colors.muted,
                          ),
                          onPressed: () =>
                              setState(() => _glassEnabled = !_glassEnabled),
                        ),
                      ),
                      AppIconButton(
                        tooltip: l10n.settingsLanguage,
                        icon: const Icon(Icons.translate_rounded),
                        onPressed: () => setState(
                          () => _locale = _locale.languageCode == 'ru'
                              ? const Locale('en')
                              : const Locale('ru'),
                        ),
                      ),
                      AppIconButton(
                        tooltip: _theme == ThemeMode.dark
                            ? l10n.settingsThemeLight
                            : l10n.settingsThemeDark,
                        icon: Icon(
                          _theme == ThemeMode.dark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                        onPressed: () => setState(
                          () => _theme = _theme == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: AppAmbientBackground(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final content = Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: NavigationBranchContainer(
                      currentIndex: _tab,
                      children: pages,
                    ),
                  ),
                );
                if (constraints.maxWidth >= 720) {
                  return Row(
                    children: [
                      NinjaNavigationRail(
                        items: items,
                        currentIndex: _tab,
                        onSelected: _select,
                      ),
                      Expanded(child: content),
                    ],
                  );
                }
                return AppBottomBarViewport(
                  bottomInset: AppBottomBar.extentOf(context),
                  child: content,
                );
              },
            ),
          ),
          bottomNavigationBar: MediaQuery.widthOf(context) >= 720
              ? null
              : NinjaBottomBar(
                  items: items,
                  currentIndex: _tab,
                  onSelected: _select,
                ),
        );
      },
    ),
  );
}
