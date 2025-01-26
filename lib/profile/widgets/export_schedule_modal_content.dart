import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:university_app_server_api/client.dart';

class ExportScheduleModalContent extends StatefulWidget {
  final String calendarName;
  final List<LessonSchedulePart> lessons;

  const ExportScheduleModalContent({
    super.key,
    required this.calendarName,
    required this.lessons,
  });

  @override
  State createState() => _ExportScheduleModalContentState();
}

class _ExportScheduleModalContentState extends State<ExportScheduleModalContent> {
  bool _includeEmojis = true;
  bool _includeShortTypeNames = true;
  bool _selectAllSubjects = true;
  bool _isSubjectPanelExpanded = false;

  final Map<String, int> _availableReminders = {
    '10 минут до': 10,
    '30 минут до': 30,
    '1 час до': 60,
    '12 часов до': 720,
  };

  late Map<String, bool> _selectedReminders;
  late Map<String, bool> _selectedSubjects;

  final TextEditingController _customReminderController = TextEditingController();
  final List<int> _customReminders = [];

  @override
  void initState() {
    super.initState();
    _selectedReminders = {
      for (var key in _availableReminders.keys) key: true,
    };

    final subjects = widget.lessons.map((lesson) => lesson.subject).toSet();

    _selectedSubjects = {
      for (var subject in subjects) subject: true,
    };
  }

  List<int> getSelectedReminderMinutes() {
    List<int> selected = [];
    _selectedReminders.forEach((key, value) {
      if (value) selected.add(_availableReminders[key]!);
    });
    selected.addAll(_customReminders);
    return selected.toSet().toList();
  }

  List<LessonSchedulePart> getFilteredLessons() {
    return widget.lessons.where((lesson) => _selectedSubjects[lesson.subject] == true).toList();
  }

  void _toggleSelectAllSubjects() {
    setState(() {
      _selectAllSubjects = !_selectAllSubjects;
      _selectedSubjects.updateAll((key, value) => _selectAllSubjects);

      if (_selectAllSubjects) {
        _isSubjectPanelExpanded = true;
      }
    });
  }

  void _addCustomReminder() {
    final input = _customReminderController.text.trim();
    final minutes = int.tryParse(input);
    if (minutes != null && minutes > 0 && !_customReminders.contains(minutes)) {
      setState(() {
        _customReminders.add(minutes);
      });
      _customReminderController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите корректное, уникальное количество минут.'),
        ),
      );
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExportSettings(),
              const SizedBox(height: 16.0),
              _buildSubjectSelectionPanel(),
              const SizedBox(height: 16.0),
              _buildRemindersCard(),
              const SizedBox(height: 16.0),
              Center(
                child: PrimaryButton(
                  onClick: () {
                    final selectedReminders = getSelectedReminderMinutes();
                    final reminders = selectedReminders.isNotEmpty ? selectedReminders : [10, 30, 720];

                    context.read<ScheduleExporterCubit>().exportSchedule(
                          calendarName: widget.calendarName,
                          lessons: getFilteredLessons(),
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
      ),
    );
  }

  Widget _buildExportSettings() {
    return Column(
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
    );
  }

  Widget _buildSubjectSelectionPanel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: ExpansionPanelList(
        elevation: 2,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            _isSubjectPanelExpanded = isExpanded;
          });
        },
        dividerColor: Theme.of(context).dividerColor,
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            splashColor: Colors.transparent,
            isExpanded: _isSubjectPanelExpanded,
            backgroundColor: Theme.of(context).extension<AppColors>()!.background03,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Text("Предметы", style: AppTextStyle.titleS),
                trailing: PlatformCheckbox(
                  value: _selectAllSubjects,
                  onChanged: (_) => _toggleSelectAllSubjects(),
                ),
              );
            },
            body: Column(
              children: _selectedSubjects.keys.map((subject) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 16.0,
                  ),
                  child: PlatformInkWell(
                    onTap: () {
                      setState(() {
                        final value = _selectedSubjects[subject] ?? false;
                        _selectedSubjects[subject] = !value;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            subject,
                            style: AppTextStyle.titleS,
                          ),
                        ),
                        PlatformCheckbox(
                          value: _selectedSubjects[subject],
                          onChanged: (value) {
                            setState(() {
                              _selectedSubjects[subject] = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      PlatformCheckbox(
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
                PlatformIconButton(
                  icon: Icon(Icons.add, color: Theme.of(context).extension<AppColors>()!.active),
                  onPressed: _addCustomReminder,
                  material: (_, __) => MaterialIconButtonData(
                    tooltip: 'Добавить напоминание',
                  ),
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
          ],
        ),
      ),
    );
  }
}
