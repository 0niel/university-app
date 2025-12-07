# Theming & UI Library

- Always check `packages/app_ui` before creating any custom widget. If the widget is general-purpose and missing, add it to `packages/app_ui`; if it is feature-only, keep it in `lib/<feature>/widgets`.
- Use the design system from `@packages/app_ui`:
  - Colors: `packages/app_ui/lib/src/colors/colors.dart` (`AppColors` via `Theme.of(context).extension<AppColors>()!`).
  - Typography: `packages/app_ui/lib/src/typography/typography.dart` (`AppTextStyle`).
- Import UI via `package:app_ui/app_ui.dart`; avoid duplicating palettes, text styles, spacing, or widgets that already exist in `app_ui`.
- When adding new shared widgets, place them under `packages/app_ui/lib/src/widgets` and export through the package barrel to keep reuse consistent.
