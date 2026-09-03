import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';
import 'package:rtu_mirea_app/app/theme/lesson_type_palette.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/lesson_color_editor.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_theme_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'appearance/accent_choice_swatch.dart';
part 'appearance/accent_color_picker.dart';
part 'appearance/accent_color_setting.dart';
part 'appearance/amoled_toggle.dart';
part 'appearance/lesson_color_picker_row.dart';
part 'appearance/lesson_color_preview.dart';
part 'appearance/lesson_type_colors.dart';
part 'appearance/lesson_types_color_picker.dart';

class SettingsAppearance extends StatelessWidget {
  const SettingsAppearance({super.key, this.preview});

  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const SettingsThemeRow(compact: true),
          const SizedBox(height: 13),
          const _AccentColorSetting(),
          const _AmoledToggle(),
          const _LessonTypeColors(),
          ?preview,
        ],
      ),
    );
  }
}

class SettingsAdvancedAppearance extends StatelessWidget {
  const SettingsAdvancedAppearance({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [SettingsThemeRow()],
  );
}
