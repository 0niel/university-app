part of '../settings_appearance.dart';

class _AccentColorSetting extends StatelessWidget {
  const _AccentColorSetting();

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeState>(
    buildWhen: (previous, current) =>
        previous.colorScheme != current.colorScheme,
    builder: (context, state) => SettingsRow(
      title: context.l10n.settingsAccentLabel,
      horizontalPadding: 0,
      verticalPadding: 0,
      minimumHeight: 44,
      trailing: SizedBox(
        width: 150,
        height: 44,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final (index, scheme) in AppColorSchemes.selectable.indexed)
              Positioned(
                left: index * 40 - 7,
                top: 0,
                child: AppPressable(
                  semanticsLabel: _accentLabel(context, scheme),
                  semanticsButton: true,
                  onTap: () {
                    context.read<ThemeCubit>().setColorScheme(scheme);
                    final profile = context.read<ProfileCubit?>();
                    if (profile != null) {
                      unawaited(
                        profile.updateSettings(
                          profile.state.settings.copyWith(
                            accentColor: scheme.name,
                          ),
                        ),
                      );
                    }
                  },
                  child: SizedBox.square(
                    dimension: 44,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(5),
                        foregroundDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: state.colorScheme == scheme
                              ? Border.all(color: context.colors.ink, width: 2)
                              : null,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColorSchemes.getSchemePreviewColor(
                              scheme,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      showChevron: false,
      onTap: () => _showAccentSheet(context),
    ),
  );
}
