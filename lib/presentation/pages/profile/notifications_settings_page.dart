import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/presentation/bloc/notification_preferences/notification_preferences_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки уведомлений"),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.status == UserStatus.authorized && state.user != null) {
              return _NotificationPreferencesView(user: state.user!);
            } else {
              return const Center(
                child: Text("Необходимо авторизоваться"),
              );
            }
          },
        ),
      ),
    );
  }
}

class _NotificationPreferencesView extends StatelessWidget {
  const _NotificationPreferencesView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Категории уведомлений',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<NotificationPreferencesBloc, NotificationPreferencesState>(
              builder: (context, state) {
                return ListView(
                  children: state.categories
                      .map<Widget>(
                        (category) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _NotificationsSwitch(
                            name: category,
                            description: _getDescription(category),
                            value: state.selectedCategories.contains(category),
                            onChanged: (value) => context.read<NotificationPreferencesBloc>().add(
                                  CategoriesPreferenceToggled(
                                    category: category,
                                    group: UserBloc.getActiveStudent(user).academicGroup,
                                  ),
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
      ),
    );
  }
}

class _NotificationsSwitch extends StatelessWidget {
  final String name;
  final String description;
  final bool value;
  final Function(bool) onChanged;

  const _NotificationsSwitch({
    Key? key,
    required this.name,
    required this.description,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 120,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: AppTextStyle.buttonL),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyle.body,
                maxLines: 2,
                overflow: TextOverflow.clip,
                softWrap: true,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CupertinoSwitch(
              activeColor: AppTheme.colorsOf(context).primary,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }
}
