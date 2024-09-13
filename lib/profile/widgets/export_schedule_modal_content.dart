// export_schedule_modal_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/container_label.dart';
import 'package:rtu_mirea_app/presentation/widgets/forms/text_input.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:university_app_server_api/client.dart';

/// Виджет, содержащий опции экспорта расписания.
class ExportScheduleModalContent extends StatefulWidget {
  final String calendarName;
  final List<LessonSchedulePart> lessons;

  const ExportScheduleModalContent({
    Key? key,
    required this.calendarName,
    required this.lessons,
  }) : super(key: key);

  @override
  _ExportScheduleModalContentState createState() => _ExportScheduleModalContentState();
}

class _ExportScheduleModalContentState extends State<ExportScheduleModalContent> {
  bool _includeEmojis = true;
  bool _includeShortTypeNames = false;

  // Определение доступных вариантов напоминаний
  final Map<String, int> _availableReminders = {
    '10 минут до': 10,
    '30 минут до': 30,
    '1 час до': 60,
    '12 часов до': 720,
  };

  late Map<String, bool> _selectedReminders;

  // Контроллер для ввода кастомного времени напоминания
  final TextEditingController _customReminderController = TextEditingController();

  // Список для хранения кастомных напоминаний
  List<int> _customReminders = [];

  @override
  void initState() {
    super.initState();
    // Инициализация всех предустановленных напоминаний как выбранных по умолчанию
    _selectedReminders = {
      for (var key in _availableReminders.keys) key: true,
    };
  }

  /// Получает список выбранных напоминаний в минутах.
  List<int> getSelectedReminderMinutes() {
    List<int> selected = [];
    _selectedReminders.forEach((key, value) {
      if (value) selected.add(_availableReminders[key]!);
    });
    // Добавляет кастомные напоминания
    selected.addAll(_customReminders);
    // Удаляет дубликаты
    return selected.toSet().toList();
  }

  /// Добавляет кастомное напоминание, если оно валидно.
  void _addCustomReminder() {
    final input = _customReminderController.text.trim();
    final minutes = int.tryParse(input);
    if (minutes != null && minutes > 0 && !_customReminders.contains(minutes)) {
      setState(() {
        _customReminders.add(minutes);
      });
      _customReminderController.clear();
    } else {
      // Показать сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите корректное, уникальное количество минут.'),
        ),
      );
    }
  }

  /// Удаляет кастомное напоминание.
  void _removeCustomReminder(int minutes) {
    setState(() {
      _customReminders.remove(minutes);
    });
  }

  @override
  void dispose() {
    _customReminderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Эмодзи в типах',
                        style: AppTextStyle.titleS,
                      ),
                      Switch(
                        value: _includeEmojis,
                        onChanged: (value) {
                          setState(() {
                            _includeEmojis = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Короткие названия типов',
                        style: AppTextStyle.titleS,
                      ),
                      Switch(
                        value: _includeShortTypeNames,
                        onChanged: (value) {
                          setState(() {
                            _includeShortTypeNames = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const ContainerLabel(label: "Напоминания"),
                  Column(
                    children: _availableReminders.keys.map((key) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                key,
                                style: AppTextStyle.titleS,
                              ),
                            ),
                            Checkbox(
                              value: _selectedReminders[key],
                              onChanged: (value) {
                                setState(() {
                                  _selectedReminders[key] = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      'Кастомные напоминания',
                      style: AppTextStyle.bodyBold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextInput(
                          controller: _customReminderController,
                          keyboardType: TextInputType.number,
                          hintText: 'Введите количество минут',
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addCustomReminder,
                        tooltip: 'Добавить напоминание',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    children: _customReminders.map((minutes) {
                      return Chip(
                        label: Text('$minutes мин'),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => _removeCustomReminder(minutes),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                ]),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: PrimaryButton(
                onClick: () {
                  final selectedReminders = getSelectedReminderMinutes();
                  final reminders = selectedReminders.isNotEmpty ? selectedReminders : [10, 30, 720];

                  context.read<ScheduleExporterCubit>().exportSchedule(
                        calendarName: widget.calendarName,
                        lessons: widget.lessons,
                        includeEmojis: _includeEmojis,
                        includeShortTypeNames: _includeShortTypeNames,
                        reminderMinutes: reminders,
                      );

                  Navigator.of(context).pop();
                },
                text: 'Экспортировать',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
