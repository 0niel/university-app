import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/ads/ads.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/app/theme/theme_mode.dart';

import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

enum ThemeOption { light, dark, system }

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Профиль")),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return const CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(child: _InitialProfileStatePage()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InitialProfileStatePage extends StatefulWidget {
  const _InitialProfileStatePage();

  @override
  State<_InitialProfileStatePage> createState() => _InitialProfileStatePageState();
}

class _InitialProfileStatePageState extends State<_InitialProfileStatePage> {
  late ThemeOption _selectedTheme;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _selectedTheme = _getCurrentThemeOption();
      _initialized = true;
    }
  }

  ThemeOption _getCurrentThemeOption() {
    final mode = AdaptiveTheme.of(context).mode;
    if (mode == AdaptiveThemeMode.light) {
      return ThemeOption.light;
    } else if (mode == AdaptiveThemeMode.dark) {
      return ThemeOption.dark;
    } else {
      return ThemeOption.system;
    }
  }

  void _setTheme(ThemeOption option) {
    setState(() => _selectedTheme = option);

    switch (option) {
      case ThemeOption.light:
        CustomThemeMode.setAmoled(false);
        AdaptiveTheme.of(context).setLight();
        break;
      case ThemeOption.dark:
        CustomThemeMode.setAmoled(false);
        AdaptiveTheme.of(context).setDark();
        break;
      case ThemeOption.system:
        CustomThemeMode.setAmoled(false);
        AdaptiveTheme.of(context).setSystem();
        break;
    }
  }

  void _onFeedbackTap(BuildContext context) {
    var defaultText = 'Возникла проблема с расписанием';
    final state = context.read<ScheduleBloc>().state;

    if (state.status == ScheduleStatus.loaded && state.selectedSchedule != null) {
      if (state.selectedSchedule is SelectedGroupSchedule) {
        defaultText += ' группы ${(state.selectedSchedule as SelectedGroupSchedule).group.name}';
      } else if (state.selectedSchedule is SelectedTeacherSchedule) {
        defaultText += ' преподавателя ${(state.selectedSchedule as SelectedTeacherSchedule).teacher.name}';
      } else if (state.selectedSchedule is SelectedClassroomSchedule) {
        defaultText += ' аудитории ${(state.selectedSchedule as SelectedClassroomSchedule).classroom.name}';
      }
    }

    final userBloc = context.read<UserBloc>();

    if (userBloc.state.status == UserStatus.authorized) {
      FeedbackBottomModalSheet.show(context, defaultText: defaultText, defaultEmail: userBloc.state.user!.email);
    } else {
      FeedbackBottomModalSheet.show(context, defaultText: defaultText);
    }
  }

  void _onAdsSettingTap(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Поддержите наш сервис'),
            content: const Text(
              'Реклама помогает нам бесплатно развивать приложение, добавлять новые возможности и поддерживать качественную работу сервиса. Отключая рекламу, вы лишаете нас важного источника поддержки. Вы уверены, что хотите отключить показ рекламы?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<AdsBloc>().add(const SetAdsVisibility(showAds: true));
                  Navigator.of(context).pop();
                },
                child: const Text('Оставить рекламу'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AdsBloc>().add(const SetAdsVisibility(showAds: false));
                  Navigator.of(context).pop();
                },
                child: const Text('Отключить'),
              ),
            ],
          ),
    );
  }

  Widget _buildThemeOption(ThemeOption option, String title, IconData icon) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSelected = _selectedTheme == option;

    return InkWell(
      onTap: () => _setTheme(option),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.1) : colors.background03,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? colors.primary : colors.background03, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? colors.primary : colors.active, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyle.body.copyWith(
                color: isSelected ? colors.primary : colors.active,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScheduleSectionWrapper(
          title: "Управление расписанием",
          scheduleSection: ScheduleManagementSection(onFeedbackTap: _onFeedbackTap),
        ),
        const SizedBox(height: 24),
        SettingsSection(
          title: "Общее",
          children: [
            SettingsItem(
              text: 'О приложении',
              icon: HugeIcon(icon: HugeIcons.strokeRoundedCoffee02, color: colors.active),
              onPressed: () => context.go('/profile/about'),
              trailing: Icon(Icons.chevron_right, color: colors.deactive),
            ),
            const Divider(height: 24, thickness: 0.5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Тема приложения',
                    style: AppTextStyle.titleM.copyWith(color: colors.active, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildThemeOption(ThemeOption.light, 'Светлая', Icons.wb_sunny_outlined)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildThemeOption(ThemeOption.dark, 'Тёмная', Icons.nightlight_outlined)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildThemeOption(ThemeOption.system, 'Системная', Icons.settings_suggest_outlined),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            SettingsItem(
              text: 'Управление рекламой',
              icon: Icon(Icons.ad_units, color: Colors.blue, size: 24),
              onPressed: () => _onAdsSettingTap(context),
              trailing: Icon(Icons.chevron_right, color: colors.deactive),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
