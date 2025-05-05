import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class CustomLessonEditorPage extends StatefulWidget {
  const CustomLessonEditorPage({super.key, required this.scheduleId, this.lesson});

  final String scheduleId;
  final LessonSchedulePart? lesson;

  @override
  State<CustomLessonEditorPage> createState() => _CustomLessonEditorPageState();
}

class _CustomLessonEditorPageState extends State<CustomLessonEditorPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();

  late TabController _tabController;

  LessonType _lessonType = LessonType.practice;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 30);
  int? _lessonNumber = 1;
  List<DateTime> _selectedDates = [];
  List<Classroom> _selectedClassrooms = [];
  List<Teacher> _selectedTeachers = [];
  List<String> _selectedGroups = [];

  bool _isOnline = false;
  final _onlineUrlController = TextEditingController();

  int _currentStep = 0;

  // Предпросмотр пары
  LessonSchedulePart? _previewLesson;

  // Добавляем переменные
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Инициализация PageController
    _pageController = PageController();

    // Инициализация списка групп
    _selectedGroups = [];

    // Если это редактирование существующего урока
    if (widget.lesson != null) {
      _subjectController.text = widget.lesson!.subject;
      _lessonType = widget.lesson!.lessonType;
      _startTime = widget.lesson!.lessonBells.startTime;
      _endTime = widget.lesson!.lessonBells.endTime;
      _lessonNumber = widget.lesson!.lessonBells.number;
      _selectedDates = List<DateTime>.from(widget.lesson!.dates);
      _selectedClassrooms = List<Classroom>.from(widget.lesson!.classrooms);
      _selectedTeachers = List<Teacher>.from(widget.lesson!.teachers);
      _selectedGroups = List<String>.from(widget.lesson!.groups ?? []);

      _isOnline = widget.lesson!.isOnline;
      if (_isOnline && widget.lesson!.classrooms.isNotEmpty) {
        _onlineUrlController.text = widget.lesson!.classrooms.first.url ?? '';
      }

      // Создаем предпросмотр
      _updatePreview();
    } else {
      // Установим хотя бы одну дату для нового урока (сегодня)
      _selectedDates = [DateTime.now()];
    }
  }

  void _handleTabChange() {
    setState(() {
      _currentStep = _tabController.index;
      // Обновляем предпросмотр при переходе между вкладками
      _updatePreview();
    });
  }

  void _updatePreview() {
    // Создаем предпросмотр урока на основе текущих данных
    final lessonBells = LessonBells(startTime: _startTime, endTime: _endTime, number: _lessonNumber);

    final List<Classroom> classrooms;
    if (_isOnline) {
      classrooms = [Classroom.online(url: _onlineUrlController.text)];
    } else {
      classrooms = _selectedClassrooms;
    }

    _previewLesson = LessonSchedulePart(
      subject: _subjectController.text.isNotEmpty ? _subjectController.text : 'Название предмета',
      lessonType: _lessonType,
      teachers: _selectedTeachers,
      classrooms: classrooms,
      lessonBells: lessonBells,
      dates: _selectedDates,
      groups: _selectedGroups,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _pageController.dispose();
    _subjectController.dispose();
    _onlineUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson == null ? 'Создание пары' : 'Редактирование пары'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Tooltip(
            message: 'Сохранить',
            child: IconButton(
              icon: Icon(HugeIcons.strokeRoundedCheckmarkCircle02, color: colors.primary),
              onPressed: _saveLesson,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(color: colors.background01),
              child: _buildStepsIndicator(),
            ),

            // Контент текущего шага
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colors.background01, borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [_buildBasicInfoTab(), _buildDatesTab(), _buildLocationTab(), _buildPreviewTab()],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavButtons(),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Основная информация
        return _subjectController.text.isNotEmpty;
      case 1: // Даты
        return _selectedDates.isNotEmpty;
      case 2: // Место
        return _isOnline || _selectedClassrooms.isNotEmpty;
      default:
        return true;
    }
  }

  Widget _buildBasicInfoTab() {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Название предмета
        TextInput(
          controller: _subjectController,
          labelText: 'Название предмета',
          hintText: 'Введите название предмета',
          onChanged: (_) => _updatePreview(),
          errorText: _subjectController.text.isEmpty ? 'Введите название предмета' : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите название предмета';
            }
            return null;
          },
          fillColor: colors.background02,
        ),

        const SizedBox(height: 24),

        _buildLessonTypeSelector(),

        const SizedBox(height: 24),

        // Время занятия
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Начало', style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final timeOfDay = await _showTimePickerDialog(
                        context,
                        TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
                      );

                      if (timeOfDay != null) {
                        setState(() {
                          _startTime = TimeOfDay(hour: timeOfDay.hour, minute: timeOfDay.minute);

                          // Проверяем, что время окончания позже времени начала
                          if (_endTime.hour < _startTime.hour ||
                              (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute)) {
                            _endTime = TimeOfDay(hour: _startTime.hour + 1, minute: _startTime.minute);
                          }

                          _updatePreview();
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.background02,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.background03),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 20, color: colors.deactive),
                          const SizedBox(width: 8),
                          Text(
                            '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                            style: AppTextStyle.body,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Конец', style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final timeOfDay = await _showTimePickerDialog(
                        context,
                        TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
                      );

                      if (timeOfDay != null) {
                        final newEndTime = TimeOfDay(hour: timeOfDay.hour, minute: timeOfDay.minute);

                        if (newEndTime.hour > _startTime.hour ||
                            (newEndTime.hour == _startTime.hour && newEndTime.minute > _startTime.minute)) {
                          setState(() {
                            _endTime = newEndTime;
                            _updatePreview();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Время окончания должно быть позже времени начала')),
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.background02,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.background03),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 20, color: colors.deactive),
                          const SizedBox(width: 8),
                          Text(
                            '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                            style: AppTextStyle.body,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Номер пары
        Text('Номер пары', style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Нет'),
              selected: _lessonNumber == null,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _lessonNumber = null;
                    _updatePreview();
                  });
                }
              },
            ),
            for (int i = 1; i <= 7; i++)
              ChoiceChip(
                label: Text('$i'),
                selected: _lessonNumber == i,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _lessonNumber = i;
                      _updatePreview();
                    });
                  }
                },
              ),
          ],
        ),

        const SizedBox(height: 24),

        // Группы
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Группы', style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600)),
            IconButton(icon: const Icon(Icons.add), onPressed: () => _addGroup(context)),
          ],
        ),
        const SizedBox(height: 12),
        _buildSelectedGroupsChips(),

        const SizedBox(height: 24),

        // Преподаватели
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Преподаватели',
              style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: () => _addTeacher(context)),
          ],
        ),
        const SizedBox(height: 12),
        _buildSelectedTeachersChips(),
      ],
    );
  }

  Widget _buildLessonTypeSelector() {
    final lessonTypeMap = {
      LessonType.practice: 'Практика',
      LessonType.lecture: 'Лекция',
      LessonType.laboratoryWork: 'Лабораторная',
      LessonType.individualWork: 'Индивидуальная',
      LessonType.physicalEducation: 'Физкультура',
      LessonType.consultation: 'Консультация',
      LessonType.exam: 'Экзамен',
      LessonType.credit: 'Зачет',
      LessonType.courseWork: 'Курсовая работа',
      LessonType.courseProject: 'Курсовой проект',
      LessonType.unknown: 'Неизвестно',
    };

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          lessonTypeMap.entries.map((entry) {
            final lessonType = entry.key;
            final typeName = entry.value;
            final isSelected = _lessonType == lessonType;
            final lessonColor = LessonCard.getColorByType(lessonType);

            return ChoiceChip(
              label: Text(typeName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _lessonType = lessonType;
                  });
                }
              },
              backgroundColor: lessonColor.withOpacity(0.1),
              selectedColor: lessonColor.withOpacity(0.2),
              side: BorderSide(color: isSelected ? lessonColor : Colors.transparent),
              labelStyle: TextStyle(
                color: isSelected ? lessonColor : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSelectedTeachersChips() {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (_selectedTeachers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('Преподаватели не выбраны', style: AppTextStyle.body.copyWith(color: colors.deactive)),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _selectedTeachers.map((teacher) {
            return Chip(
              label: Text(teacher.name),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() {
                  _selectedTeachers.remove(teacher);
                });
              },
            );
          }).toList(),
    );
  }

  void _addTeacher(BuildContext context) {
    final teacherController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить преподавателя'),
            content: Form(
              key: formKey,
              child: TextInput(
                controller: teacherController,
                labelText: 'ФИО преподавателя',
                hintText: 'Например: Иванов Иван Иванович',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите ФИО преподавателя';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final teacher = Teacher(name: teacherController.text.trim());
                    setState(() {
                      _selectedTeachers.add(teacher);
                      _updatePreview();
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
    );
  }

  void _saveLesson() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDates.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Выберите хотя бы одну дату проведения')));
        return;
      }

      if (!_isOnline && _selectedClassrooms.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Добавьте хотя бы одну аудиторию или сделайте занятие онлайн')));
        return;
      }

      final List<Classroom> classrooms;
      if (_isOnline) {
        classrooms = [Classroom.online(url: _onlineUrlController.text)];
      } else {
        classrooms = _selectedClassrooms;
      }

      final lessonBells = LessonBells(startTime: _startTime, endTime: _endTime, number: _lessonNumber);

      final lesson = LessonSchedulePart(
        subject: _subjectController.text,
        lessonType: _lessonType,
        teachers: _selectedTeachers,
        classrooms: classrooms,
        lessonBells: lessonBells,
        dates: _selectedDates,
        groups: _selectedGroups,
      );

      if (widget.lesson == null) {
        // Создаем новую пару
        context.read<ScheduleBloc>().add(AddLessonToCustomSchedule(scheduleId: widget.scheduleId, lesson: lesson));
      } else {
        // Удаляем старую пару и добавляем новую (обновление)
        context.read<ScheduleBloc>().add(
          RemoveLessonFromCustomSchedule(scheduleId: widget.scheduleId, lesson: widget.lesson!),
        );

        context.read<ScheduleBloc>().add(AddLessonToCustomSchedule(scheduleId: widget.scheduleId, lesson: lesson));
      }

      Navigator.pop(context);
    }
  }

  Widget _buildDatesTab() {
    final colors = Theme.of(context).extension<AppColors>()!;
    final dateFormat = DateFormat('dd.MM.yyyy (EEE)', 'ru');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Виджет календаря с возможностью выбора дат
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.background02,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.background03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Выберите даты проведения',
                    style: AppTextStyle.titleM.copyWith(color: colors.active, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _selectDates(context),
                    tooltip: 'Добавить дату',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedDates.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 48, color: colors.deactive),
                      const SizedBox(height: 16),
                      Text('Нет выбранных дат', style: AppTextStyle.body.copyWith(color: colors.deactive)),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _selectDates(context),
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Выбрать даты'),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _selectedDates.map((date) {
                        return Chip(
                          label: Text(dateFormat.format(date)),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              _selectedDates.remove(date);
                              _updatePreview();
                            });
                          },
                          backgroundColor: colors.background03.withOpacity(0.5),
                          side: BorderSide(color: colors.background03),
                        );
                      }).toList(),
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Секция с повторяющимися событиями (опционально для будущего расширения)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.background02,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.background03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Повторение',
                style: AppTextStyle.titleM.copyWith(color: colors.active, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              // TODO: Будущая функциональность
              Text(
                'Функция настройки повторений будет доступна в будущих версиях.',
                style: AppTextStyle.body.copyWith(color: colors.deactive, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTab() {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Переключатель онлайн/оффлайн
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.background02,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.background03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Тип проведения занятия',
                      style: AppTextStyle.titleM.copyWith(color: colors.active, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLocationOption(
                    title: 'Оффлайн',
                    icon: Icons.location_on,
                    isSelected: !_isOnline,
                    onTap: () {
                      setState(() {
                        _isOnline = false;
                        _updatePreview();
                      });
                    },
                  ),
                  _buildLocationOption(
                    title: 'Онлайн',
                    icon: Icons.video_call,
                    isSelected: _isOnline,
                    onTap: () {
                      setState(() {
                        _isOnline = true;
                        _updatePreview();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Если онлайн - поле для ссылки
        if (_isOnline)
          TextInput(
            controller: _onlineUrlController,
            labelText: 'Ссылка на онлайн занятие',
            hintText: 'Введите URL для подключения',
            onChanged: (_) => _updatePreview(),
            keyboardType: TextInputType.url,
          )
        else
          // Аудитории
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.background02,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.background03),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Аудитории',
                      style: AppTextStyle.titleM.copyWith(color: colors.active, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addClassroom(context),
                      tooltip: 'Добавить аудиторию',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_selectedClassrooms.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, size: 48, color: colors.deactive),
                        const SizedBox(height: 16),
                        Text('Нет выбранных аудиторий', style: AppTextStyle.body.copyWith(color: colors.deactive)),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _addClassroom(context),
                          icon: const Icon(Icons.location_on),
                          label: const Text('Добавить аудиторию'),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedClassrooms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final classroom = _selectedClassrooms[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.background01,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.background03),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.colorful01.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.location_on, size: 18, color: colors.colorful01),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(classroom.name, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600)),
                                  if (classroom.campus != null)
                                    Text(
                                      classroom.campus!.name,
                                      style: AppTextStyle.captionL.copyWith(color: colors.deactive),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _selectedClassrooms.remove(classroom);
                                  _updatePreview();
                                });
                              },
                              color: colors.deactive,
                              iconSize: 20,
                              splashRadius: 20,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints.tight(const Size(24, 24)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLocationOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.1) : colors.background01,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? colors.primary : colors.background03, width: isSelected ? 1.5 : 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary.withOpacity(0.1) : colors.background03.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? colors.primary : colors.deactive),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyle.body.copyWith(
                color: isSelected ? colors.primary : colors.active,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewTab() {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (_previewLesson == null) {
      _updatePreview();
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.background02,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.background03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Предпросмотр пары',
                style: AppTextStyle.titleM.copyWith(color: colors.active, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              if (_previewLesson != null)
                LessonCard(lesson: _previewLesson!, onTap: (_) {})
              else
                Center(
                  child: Text(
                    'Заполните данные для предпросмотра',
                    style: AppTextStyle.body.copyWith(color: colors.deactive, fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Сводка информации
        if (_previewLesson != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.background02,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.background03),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Сводка информации',
                  style: AppTextStyle.titleM.copyWith(color: colors.active, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Название', _previewLesson!.subject),
                _buildInfoRow('Тип занятия', LessonCard.getLessonTypeName(_previewLesson!.lessonType)),
                _buildInfoRow(
                  'Время',
                  '${_previewLesson!.lessonBells.startTime} - ${_previewLesson!.lessonBells.endTime}',
                ),
                if (_previewLesson!.lessonBells.number != null)
                  _buildInfoRow('Номер пары', '${_previewLesson!.lessonBells.number}'),
                _buildInfoRow(
                  'Количество дат',
                  '${_previewLesson!.dates.length} (${_previewLesson!.dates.isNotEmpty ? DateFormat('dd.MM.yyyy').format(_previewLesson!.dates.first) : "нет"}${_previewLesson!.dates.length > 1 ? " и др." : ""})',
                ),
                _buildInfoRow(
                  'Место проведения',
                  _isOnline
                      ? 'Онлайн${_onlineUrlController.text.isNotEmpty ? " (ссылка указана)" : ""}'
                      : _previewLesson!.classrooms.map((e) => e.name).join(', '),
                ),
                _buildInfoRow(
                  'Преподаватели',
                  _previewLesson!.teachers.isEmpty
                      ? 'Не указаны'
                      : _previewLesson!.teachers.map((e) => e.name).join(', '),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTextStyle.body.copyWith(color: colors.deactive))),
          Expanded(child: Text(value, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  // Выбор дат проведения занятия
  Future<void> _selectDates(BuildContext context) async {
    final colors = Theme.of(context).extension<AppColors>()!;
    final picker = DateRangePicker(
      initialDateRange:
          _selectedDates.isNotEmpty ? DateTimeRange(start: _selectedDates.first, end: _selectedDates.last) : null,
      selectedDates: _selectedDates,
      selectableDayPredicate: (day) {
        // Исключаем даты до текущей
        return !day.isBefore(DateTime.now().subtract(const Duration(days: 1)));
      },
    );

    final result = await showModalBottomSheet<List<DateTime>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.background01,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder:
          (context) => Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: picker,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedDates = result;
        _updatePreview();
      });
    }
  }

  // Добавление аудитории
  Future<void> _addClassroom(BuildContext context) async {
    final colors = Theme.of(context).extension<AppColors>()!;
    final classroomController = TextEditingController();
    final campusController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Classroom>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить аудиторию'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInput(
                    controller: classroomController,
                    labelText: 'Номер аудитории',
                    hintText: 'Например: А-123',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите номер аудитории';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextInput(
                    controller: campusController,
                    labelText: 'Название кампуса (опционально)',
                    hintText: 'Например: В-78',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final classroom = Classroom(
                      name: classroomController.text.trim(),
                      campus: campusController.text.isNotEmpty ? Campus(name: campusController.text.trim()) : null,
                    );
                    Navigator.pop(context, classroom);
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
    );

    if (result != null) {
      setState(() {
        _selectedClassrooms.add(result);
        _updatePreview();
      });
    }
  }

  Widget _buildSelectedGroupsChips() {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (_selectedGroups.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('Группы не выбраны', style: AppTextStyle.body.copyWith(color: colors.deactive)),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _selectedGroups.map((group) {
            return Chip(
              label: Text(group),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() {
                  _selectedGroups.remove(group);
                  _updatePreview();
                });
              },
            );
          }).toList(),
    );
  }

  void _addGroup(BuildContext context) {
    final groupController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить группу'),
            content: Form(
              key: formKey,
              child: TextInput(
                controller: groupController,
                labelText: 'Название группы',
                hintText: 'Например: ИКБО-01-21',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название группы';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _selectedGroups.add(groupController.text.trim());
                      _updatePreview();
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
    );
  }

  // Helper-метод для отображения диалога выбора времени
  Future<TimeOfDay?> _showTimePickerDialog(BuildContext context, TimeOfDay initialTime) async {
    final res = await showTimePicker(
      context: context,
      initialTime: material.TimeOfDay(hour: initialTime.hour, minute: initialTime.minute),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              hourMinuteShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
          child: child!,
        );
      },
    );

    if (res != null) {
      return TimeOfDay(hour: res.hour, minute: res.minute);
    }

    return null;
  }

  // Индикатор шагов с прогрессом
  Widget _buildStepsIndicator() {
    final colors = Theme.of(context).extension<AppColors>()!;
    final steps = ['Основное', 'Даты', 'Место', 'Превью'];

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: InkWell(
            onTap: () => _navigateToStep(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(child: Container(height: 2, color: isCompleted ? colors.primary : colors.background03)),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            isActive
                                ? colors.primary
                                : isCompleted
                                ? colors.primary.withOpacity(0.1)
                                : colors.background03,
                        shape: BoxShape.circle,
                        border: isActive ? Border.all(color: colors.primary.withOpacity(0.5), width: 4) : null,
                      ),
                      child: Center(
                        child:
                            isCompleted
                                ? Icon(Icons.check_circle, color: colors.primary, size: 16)
                                : Text(
                                  '${index + 1}',
                                  style: AppTextStyle.body.copyWith(
                                    color: isActive ? Colors.white : colors.deactive,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                    if (index < steps.length - 1)
                      Expanded(child: Container(height: 2, color: isCompleted ? colors.primary : colors.background03)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  style: AppTextStyle.captionL.copyWith(
                    color: isActive ? colors.primary : colors.deactive,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Кнопки навигации
  Widget _buildNavButtons() {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background01,
        boxShadow: [BoxShadow(color: colors.background03.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            Expanded(
              child: InkWell(
                onTap: () => _navigateToStep(_currentStep - 1),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.background02,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.background03),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 20, color: colors.active),
                      const SizedBox(width: 8),
                      Text(
                        'Назад',
                        style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap:
                  _currentStep < 3
                      ? () {
                        if (_validateCurrentStep()) {
                          _navigateToStep(_currentStep + 1);
                        }
                      }
                      : _saveLesson,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentStep < 3 ? colors.primary : colors.success,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (_currentStep < 3 ? colors.primary : colors.success).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentStep < 3
                          ? 'Далее'
                          : widget.lesson == null
                          ? 'Создать'
                          : 'Сохранить',
                      style: AppTextStyle.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    if (_currentStep < 3) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Анимированный переход к определённому шагу
  void _navigateToStep(int step) {
    if (step < 0 || step > 3) return;

    setState(() {
      _currentStep = step;
    });

    _pageController.animateToPage(step, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
