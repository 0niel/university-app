part of '../settings_appearance.dart';

class _GlassEffectToggle extends StatelessWidget {
  const _GlassEffectToggle();

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeState>(
    buildWhen: (previous, current) =>
        previous.glassEnabled != current.glassEnabled,
    builder: (context, state) => SettingsToggleRow(
      label: context.l10n.settingsGlassEffectTitle,
      sub: context.l10n.settingsGlassEffectSubtitle,
      lineIcon: AppLineIcon.spark,
      value: state.glassEnabled,
      onChanged: (value) =>
          context.read<ThemeCubit>().setGlassEnabled(enabled: value),
    ),
  );
}
