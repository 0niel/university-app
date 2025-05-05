import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart' hide TextInput;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_schedule_selector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_launcher/url_launcher_string.dart';
// Используем карту на всех платформах
import 'package:rtu_mirea_app/schedule/widgets/map_view.dart';

class ScheduleDetailsPage extends StatefulWidget {
  const ScheduleDetailsPage({super.key, required this.lesson, required this.selectedDate});

  final LessonSchedulePart lesson;

  /// The date in the [Calendar] where the lesson was selected to display the
  /// details.
  final DateTime selectedDate;

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> with SingleTickerProviderStateMixin {
  late final TextEditingController _textController;
  late final AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  DateTime get _now => DateTime.now();
  bool get _isLessonActive =>
      widget.selectedDate.year == _now.year &&
      widget.selectedDate.month == _now.month &&
      widget.selectedDate.day == _now.day &&
      _isTimeInRange(
        _now,
        _getTimeFromTimeOfDay(widget.lesson.lessonBells.startTime),
        _getTimeFromTimeOfDay(widget.lesson.lessonBells.endTime),
      );

  double get _lessonProgress {
    if (!_isLessonActive) return 0.0;

    final startTime = _getTimeFromTimeOfDay(widget.lesson.lessonBells.startTime);
    final endTime = _getTimeFromTimeOfDay(widget.lesson.lessonBells.endTime);
    final now = _now;

    final totalDuration = endTime.difference(startTime).inSeconds;
    final elapsedDuration = now.difference(startTime).inSeconds;

    return elapsedDuration / totalDuration;
  }

  DateTime _getTimeFromTimeOfDay(TimeOfDay time) {
    return DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      time.hour,
      time.minute,
    );
  }

  bool _isTimeInRange(DateTime time, DateTime start, DateTime end) {
    return time.isAfter(start) && time.isBefore(end);
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    final comment = _getComment();
    if (comment != null) {
      _textController.text = comment.text;
    }

    _scrollController.addListener(_onScroll);

    _textController.addListener(() {
      if (_textController.text.length > 500 && _textErrorText == null) {
        setState(() {
          _textErrorText = 'Слишком длинный комментарий';
        });
      } else if (_textController.text.length <= 500 && _textErrorText != null) {
        setState(() {
          _textErrorText = null;
        });
      }

      final bloc = context.read<ScheduleBloc>();

      bloc.add(
        SetLessonComment(
          comment: LessonComment(
            subjectName: widget.lesson.subject,
            lessonDate: widget.lesson.dates.first,
            lessonBells: widget.lesson.lessonBells,
            text: _textController.text,
          ),
        ),
      );
    });
  }

  void _onScroll() {
    final shouldBeCollapsed = _scrollController.hasClients && _scrollController.offset > 140;
    if (shouldBeCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = shouldBeCollapsed;
      });
    }
  }

  LessonComment? _getComment() {
    final bloc = context.read<ScheduleBloc>();

    return bloc.state.comments.firstWhereOrNull(
      (comment) => widget.lesson.dates.contains(comment.lessonDate) && comment.lessonBells == widget.lesson.lessonBells,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String? _textErrorText;
  bool _isFavorite = false;

  void _shareLessonDetails() {
    final lessonType = LessonCard.getLessonTypeName(widget.lesson.lessonType);
    final time = '${widget.lesson.lessonBells.startTime} - ${widget.lesson.lessonBells.endTime}';
    final date = DateFormat('dd.MM.yyyy').format(widget.selectedDate);

    final classrooms = widget.lesson.classrooms
        .map((e) => e.name + (e.campus != null ? ' (${e.campus?.shortName ?? e.campus?.name ?? ''})' : ''))
        .join(', ');

    final teachers = widget.lesson.teachers.map((e) => e.name).join(', ');
    final groups = widget.lesson.groups?.join(', ') ?? '';

    final shareText =
        '''
Занятие: ${widget.lesson.subject}
Тип: $lessonType
Дата: $date
Время: $time
${classrooms.isNotEmpty ? 'Аудитория: $classrooms\n' : ''}${teachers.isNotEmpty ? 'Преподаватель: $teachers\n' : ''}${groups.isNotEmpty ? 'Группы: $groups\n' : ''}
    '''.trim();

    Share.share(shareText);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final lessonColor = LessonCard.getColorByType(widget.lesson.lessonType);
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SliverAppBar с эффектом как в iOS
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            stretch: true,
            backgroundColor: lessonColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [lessonColor, lessonColor.withOpacity(0.8)],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 56,
                    left: 24,
                    right: 24,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lesson.subject,
                        style: AppTextStyle.h5.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // Информационные чипы
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              HugeIcons.strokeRoundedClock01,
                              '${widget.lesson.lessonBells.startTime} - ${widget.lesson.lessonBells.endTime}',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              HugeIcons.strokeRoundedNotebook01,
                              LessonCard.getLessonTypeName(widget.lesson.lessonType),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
              ),
            ),
            actions: [
              _buildIconButton(HugeIcons.strokeRoundedAdd01, _showAddToCustomScheduleModal, Colors.white),
              _buildIconButton(
                _isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                () => setState(() => _isFavorite = !_isFavorite),
                Colors.white,
              ),
              _buildIconButton(Icons.share_outlined, _shareLessonDetails, Colors.white),
            ],
            leading: _buildIconButton(Icons.arrow_back_ios_new, () => Navigator.of(context).pop(), Colors.white),
            title:
                _isCollapsed
                    ? Text(
                      widget.lesson.subject,
                      style: AppTextStyle.titleS.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                    : null,
          ),

          // Секции с контентом
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildClassroomInfo(),
                if (widget.lesson.groups != null && widget.lesson.groups!.isNotEmpty) _buildGroups(),
                if (widget.lesson.teachers.isNotEmpty) _buildTeachers(),
                _buildComments(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed, Color color) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: color,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(36, 36),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          HugeIcon(icon: icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.bodyL.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCustomScheduleModal() {
    BottomModalSheet.show(
      context,
      child: CustomScheduleSelector(lesson: widget.lesson),
      title: 'Добавить в расписание',
      showFullScreen: true,
      sheetHeight: MediaQuery.of(context).size.height,
      isExpandable: true,
      scrollable: true,
    );
  }

  Widget _buildClassroomInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          widget.lesson.classrooms.map((classroom) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Аудитория',
                    style: AppTextStyle.captionL.copyWith(
                      color: Theme.of(context).extension<AppColors>()!.deactive,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.go('/schedule/search', extra: classroom.name),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(classroom.name, style: AppTextStyle.title.copyWith(fontWeight: FontWeight.w600)),
                              if (classroom.campus != null)
                                Text(
                                  classroom.campus!.name,
                                  style: AppTextStyle.body.copyWith(
                                    color: Theme.of(context).extension<AppColors>()!.deactive,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).extension<AppColors>()!.deactive,
                        ),
                      ],
                    ),
                  ),
                  if (classroom.campus != null && classroom.campus?.latitude != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 180,
                        child: CampusMapView(
                          latitude: classroom.campus!.latitude!,
                          longitude: classroom.campus!.longitude!,
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        launchUrlString(
                          'https://www.openstreetmap.org/?mlat=${classroom.campus!.latitude}&mlon=${classroom.campus!.longitude}&zoom=15',
                        );
                      },
                      icon: const Icon(Icons.directions, size: 18),
                      label: const Text('Построить маршрут'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildGroups() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Группы',
            style: AppTextStyle.captionL.copyWith(
              color: Theme.of(context).extension<AppColors>()!.deactive,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                widget.lesson.groups?.map((group) {
                  return CustomChip.ChipButton(
                    label: group,
                    onTap: () {
                      context.go('/schedule/search', extra: group);
                    },
                  );
                }).toList() ??
                [],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildTeachers() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Преподаватели',
            style: AppTextStyle.captionL.copyWith(
              color: Theme.of(context).extension<AppColors>()!.deactive,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.lesson.teachers.asMap().entries.map((entry) {
            final index = entry.key;
            final teacher = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: InkWell(
                onTap: () => context.go('/schedule/search', extra: teacher.name),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          teacher.name.isNotEmpty ? teacher.name[0] : '?',
                          style: AppTextStyle.titleM.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).extension<AppColors>()!.active,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(teacher.name, style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.w600)),
                          if (teacher.post != null)
                            Text(
                              teacher.post!,
                              style: AppTextStyle.captionL.copyWith(
                                color: Theme.of(context).extension<AppColors>()!.deactive,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).extension<AppColors>()!.deactive),
                  ],
                ),
              ),
            ).animate(delay: (index * 70).ms).fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0);
          }),
        ],
      ),
    );
  }

  Widget _buildComments() {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Комментарий',
            style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextInput(
            hintText: 'Введите комментарий к занятию...',
            controller: _textController,
            errorText: _textErrorText,
            maxLines: 5,
            fillColor: Theme.of(context).brightness == Brightness.dark ? colors.background02 : Colors.grey.shade50,
          ),
          if (_textController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${_textController.text.length}/500',
                style: AppTextStyle.captionL.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
              ),
            ),
        ],
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const StatusIndicator({super.key, required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: isActive ? Colors.green : Colors.grey, shape: BoxShape.circle),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .scaleXY(begin: 1, end: 1.3, duration: 1000.ms, curve: Curves.easeInOut)
        .then()
        .scaleXY(begin: 1.3, end: 1, duration: 1000.ms, curve: Curves.easeInOut);
  }
}
