import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:university_app_server_api/client.dart';

class ExportScheduleModalContent extends StatefulWidget {
  final String calendarName;
  final List<LessonSchedulePart> lessons;

  const ExportScheduleModalContent({super.key, required this.calendarName, required this.lessons});

  @override
  State createState() => _ExportScheduleModalContentState();
}

class _ExportScheduleModalContentState extends State<ExportScheduleModalContent> with SingleTickerProviderStateMixin {
  bool _includeEmojis = true;
  bool _includeShortTypeNames = true;
  bool _selectAllSubjects = true;
  late TabController _tabController;

  final Map<String, int> _presetReminders = {'10 минут до': 10, '30 минут до': 30, '1 час до': 60, '12 часов до': 720};

  late Map<String, bool> _selectedPresetReminders;
  late Map<String, bool> _selectedSubjects;

  final TextEditingController _customReminderController = TextEditingController();
  final FocusNode _reminderFocusNode = FocusNode();
  final List<int> _customReminders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _selectedPresetReminders = {for (var key in _presetReminders.keys) key: true};

    final subjects = widget.lessons.map((lesson) => lesson.subject).toSet().toList()..sort((a, b) => a.compareTo(b));

    _selectedSubjects = {for (var subject in subjects) subject: true};

    _reminderFocusNode.addListener(() {
      if (!_reminderFocusNode.hasFocus) {
        _validateCustomReminder(_customReminderController.text);
      }
    });
  }

  List<int> getSelectedReminderMinutes() {
    List<int> selected = [];
    _selectedPresetReminders.forEach((key, value) {
      if (value) selected.add(_presetReminders[key]!);
    });
    selected.addAll(_customReminders);
    return selected.toSet().toList()..sort();
  }

  List<LessonSchedulePart> getFilteredLessons() {
    return widget.lessons.where((lesson) => _selectedSubjects[lesson.subject] == true).toList();
  }

  void _toggleSelectAllSubjects() {
    setState(() {
      _selectAllSubjects = !_selectAllSubjects;
      _selectedSubjects.updateAll((key, value) => _selectAllSubjects);
    });
  }

  bool _validateCustomReminder(String value) {
    final input = value.trim();
    if (input.isEmpty) {
      return true;
    }

    final minutes = int.tryParse(input);
    if (minutes == null) {
      return false;
    }

    if (minutes <= 0) {
      return false;
    }

    if (_customReminders.contains(minutes) || _presetReminders.values.contains(minutes)) {
      return false;
    }

    return true;
  }

  void _addCustomReminder() {
    final input = _customReminderController.text.trim();
    if (!_validateCustomReminder(input)) return;

    final minutes = int.tryParse(input);
    if (minutes != null && minutes > 0) {
      setState(() {
        _customReminders.add(minutes);
        _customReminderController.clear();
      });
    }
  }

  void _removeCustomReminder(int minutes) {
    setState(() {
      _customReminders.remove(minutes);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customReminderController.dispose();
    _reminderFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          unselectedLabelColor: colors.deactive,
          indicatorColor: colors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: "Настройки"), Tab(text: "Предметы"), Tab(text: "Напоминания")],
        ),
        const SizedBox(height: 16),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildSettingsTab(), _buildSubjectsTab(), _buildRemindersTab()],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, -3))],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Календарь: ${widget.calendarName}',
                      style: AppTextStyle.body.copyWith(color: colors.deactive),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Предметов: ${_selectedSubjects.values.where((v) => v).length}/${_selectedSubjects.length}',
                      style: AppTextStyle.body.copyWith(color: colors.deactive),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 160,
                height: 48,
                child: PrimaryButton(
                  onPressed: () {
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
                  icon: Icon(Icons.calendar_today, size: 20, color: colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _SectionCard(
          title: 'Настройки экспорта',
          icon: Icons.settings_outlined,
          children: [
            _SettingToggleItem(
              title: 'Эмодзи в типах пар',
              subtitle: 'Пример: "📚 Лекция" вместо "Лекция"',
              value: _includeEmojis,
              onChanged: (value) {
                setState(() => _includeEmojis = value);
              },
            ),
            const Divider(),
            _SettingToggleItem(
              title: 'Короткие названия типов',
              subtitle: 'Пример: "Лек." вместо "Лекция"',
              value: _includeShortTypeNames,
              onChanged: (value) {
                setState(() => _includeShortTypeNames = value);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Предпросмотр',
          icon: Icons.preview_outlined,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Пример названий пар:', style: AppTextStyle.body.copyWith(color: colors.deactive)),
            ),
            _PreviewItem(
              title: _includeEmojis ? '📚 Лекция' : 'Лекция',
              subtitle: 'Полное название типа',
              enabled: !_includeShortTypeNames,
            ),
            const SizedBox(height: 8),
            _PreviewItem(
              title: _includeEmojis ? '📚 Лек.' : 'Лек.',
              subtitle: 'Сокращенное название типа',
              enabled: _includeShortTypeNames,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectsTab() {
    final colors = Theme.of(context).extension<AppColors>()!;
    final subjects = _selectedSubjects.keys.toList();
    final selectedCount = _selectedSubjects.values.where((v) => v).length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _SectionCard(
          title: 'Выбор предметов',
          icon: Icons.subject_outlined,
          trailing: Text(
            '$selectedCount/${subjects.length}',
            style: AppTextStyle.bodyL.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
          ),
          children: [
            // Select all checkbox
            InkWell(
              onTap: _toggleSelectAllSubjects,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Row(
                  children: [
                    PlatformCheckbox(value: _selectAllSubjects, onChanged: (_) => _toggleSelectAllSubjects()),
                    const SizedBox(width: 8),
                    Text('Выбрать все', style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const Divider(),
            // Subject list
            ...subjects.map((subject) {
              return _SubjectItem(
                subject: subject,
                isSelected: _selectedSubjects[subject] ?? false,
                onToggle: (value) {
                  setState(() {
                    _selectedSubjects[subject] = value;
                    _selectAllSubjects = _selectedSubjects.values.every((v) => v);
                  });
                },
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildRemindersTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _SectionCard(
          title: 'Стандартные напоминания',
          icon: Icons.access_time,
          children:
              _presetReminders.keys.map((key) {
                return _ReminderToggleItem(
                  title: key,
                  value: _selectedPresetReminders[key] ?? false,
                  onChanged: (value) {
                    setState(() {
                      _selectedPresetReminders[key] = value;
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.icon, required this.children, this.trailing});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colors.background02,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600))),
                if (trailing != null) trailing!,
              ],
            ),
            if (children.isNotEmpty) const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _PreviewItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool enabled;

  const _PreviewItem({required this.title, required this.subtitle, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: enabled ? colors.background03 : colors.background03.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: enabled ? Border.all(color: colors.primary.withOpacity(0.3), width: 1.5) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bodyL.copyWith(
                    color: enabled ? colors.active : colors.deactive,
                    fontWeight: enabled ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyle.body.copyWith(color: colors.deactive)),
              ],
            ),
          ),
          if (enabled)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: colors.primary.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(Icons.check, color: colors.primary, size: 16),
            ),
        ],
      ),
    );
  }
}

class _SettingToggleItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggleItem({required this.title, this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w500)),
                  if (subtitle != null) Text(subtitle!, style: AppTextStyle.body.copyWith(color: colors.deactive)),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged, activeColor: colors.primary),
          ],
        ),
      ),
    );
  }
}

class _SubjectItem extends StatelessWidget {
  final String subject;
  final bool isSelected;
  final ValueChanged<bool> onToggle;

  const _SubjectItem({required this.subject, required this.isSelected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: () => onToggle(!isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Row(
          children: [
            PlatformCheckbox(value: isSelected, onChanged: (value) => onToggle(value ?? false)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                subject,
                style: AppTextStyle.bodyL.copyWith(
                  color: isSelected ? colors.active : colors.deactive,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderToggleItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ReminderToggleItem({required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(Icons.notifications_outlined, color: value ? colors.primary : colors.deactive, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.bodyL.copyWith(
                  color: colors.active,
                  fontWeight: value ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            PlatformCheckbox(value: value, onChanged: (value) => onChanged(value ?? false)),
          ],
        ),
      ),
    );
  }
}
