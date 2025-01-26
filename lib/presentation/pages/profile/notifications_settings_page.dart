import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/notification_preferences/notification_preferences_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки уведомлений"),
      ),
      body: const SafeArea(
        child: _NotificationPreferencesView(),
      ),
    );
  }
}

class _NotificationPreferencesView extends StatefulWidget {
  const _NotificationPreferencesView();

  @override
  State<_NotificationPreferencesView> createState() => _NotificationPreferencesViewState();
}

class _NotificationPreferencesViewState extends State<_NotificationPreferencesView> {
  String _getDescription(String category) {
    switch (category) {
      case 'Объявления':
        return 'Важные общеуниверситетские объявления';
      case 'Обновления расписания':
        return 'Изменения в расписании вашей группы';
      default:
        return '';
    }
  }

  late final ScheduleBloc _scheduleBloc;

  @override
  void initState() {
    super.initState();
    _scheduleBloc = context.read<ScheduleBloc>();
  }

  @override
  Widget build(BuildContext context) {
    String? activeGroup = _scheduleBloc.state.selectedSchedule is SelectedGroupSchedule
        ? (_scheduleBloc.state.selectedSchedule as SelectedGroupSchedule).group.name
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Категории уведомлений',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BlocBuilder<NotificationPreferencesBloc, NotificationPreferencesState>(
            builder: (context, state) {
              return ListView(
                children: state.categories
                    .map<Widget>(
                      (category) => _NotificationsSwitch(
                        name: category,
                        description: _getDescription(category),
                        value: state.selectedCategories.contains(category),
                        onChanged: (value) => context.read<NotificationPreferencesBloc>().add(
                              CategoriesPreferenceToggled(
                                category: category,
                                group: activeGroup,
                              ),
                            ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NotificationsSwitch extends StatelessWidget {
  final String name;
  final String description;
  final bool value;
  final Function(bool) onChanged;

  const _NotificationsSwitch({
    required this.name,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(description),
      subtitle: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: CupertinoSwitch(
        activeTrackColor: Theme.of(context).extension<AppColors>()!.primary,
        value: value,
        onChanged: onChanged,
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }
}
