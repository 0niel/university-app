import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:university_app_server_api/client.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../schedule.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({super.key, required this.lesson, this.indexInGroup, this.countInGroup, this.onTap});

  final LessonSchedulePart lesson;
  final void Function(LessonSchedulePart)? onTap;
  final int? indexInGroup;
  final int? countInGroup;

  static Color getColorByType(LessonType lessonType) {
    switch (lessonType) {
      case LessonType.lecture:
        return AppColors.dark.colorful01;
      case LessonType.laboratoryWork:
        return AppColors.dark.colorful02;
      case LessonType.practice:
        return AppColors.dark.colorful03;
      case LessonType.individualWork:
        return AppColors.dark.colorful07;
      case LessonType.exam:
        return AppColors.dark.colorful06;
      case LessonType.credit:
        return AppColors.dark.colorful07;
      case LessonType.consultation:
        return AppColors.dark.colorful04;
      case LessonType.courseWork:
        return AppColors.dark.colorful05;
      case LessonType.courseProject:
        return AppColors.dark.colorful05;
      default:
        return AppColors.dark.colorful01;
    }
  }

  static String getLessonTypeName(LessonType lessonType) {
    switch (lessonType) {
      case LessonType.lecture:
        return 'Лекция';
      case LessonType.laboratoryWork:
        return 'Лабораторная';
      case LessonType.practice:
        return 'Практика';
      case LessonType.individualWork:
        return 'Сам. работа';
      case LessonType.exam:
        return 'Экзамен';
      case LessonType.consultation:
        return 'Консультация';
      case LessonType.courseWork:
        return 'Курс. раб.';
      case LessonType.courseProject:
        return 'Курс. проект';
      case LessonType.credit:
        return 'Зачет';
      default:
        return 'Неизвестно';
    }
  }

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  Timer? _timer;
  double? _progress;

  double? _computeProgress() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lessonStart = DateTime(
      today.year,
      today.month,
      today.day,
      widget.lesson.lessonBells.startTime.hour,
      widget.lesson.lessonBells.startTime.minute,
    );
    final lessonEnd = DateTime(
      today.year,
      today.month,
      today.day,
      widget.lesson.lessonBells.endTime.hour,
      widget.lesson.lessonBells.endTime.minute,
    );
    if ((now.isAtSameMomentAs(lessonStart) || now.isAfter(lessonStart)) && now.isBefore(lessonEnd)) {
      return now.difference(lessonStart).inSeconds / lessonEnd.difference(lessonStart).inSeconds;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _progress = _computeProgress();
    if (_progress != null) {
      _startProgressTimer();
    }
  }

  void _startProgressTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final newProgress = _computeProgress();
      if ((newProgress == null && _progress != null) ||
          (newProgress != null && _progress != null && (newProgress - _progress!).abs() > 0.01) ||
          (newProgress != null && _progress == null)) {
        setState(() {
          _progress = newProgress;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getClassroomNames(List<Classroom> classrooms) {
    return classrooms
        .map((e) => e.name + (e.campus != null ? ' (${e.campus?.shortName ?? e.campus?.name ?? ''})' : ''))
        .join(', ');
  }

  Widget _buildCommentAlert(BuildContext context, List<LessonComment> comments) {
    final comment = comments.firstWhereOrNull(
      (comment) => widget.lesson.dates.contains(comment.lessonDate) && comment.lessonBells == widget.lesson.lessonBells,
    );
    if (comment == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.dark.colorful01.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedComment01,
              color: Theme.of(context).extension<AppColors>()!.colorful01,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              comment.text,
              style: AppTextStyle.body.copyWith(height: 1.3),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final state = context.read<ScheduleBloc>().state;
    final lessonColor = LessonCard.getColorByType(widget.lesson.lessonType);
    final isActive = _progress != null;

    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.all(0),
        color: isActive ? lessonColor.withOpacity(0.05) : Theme.of(context).extension<AppColors>()!.surface,
        surfaceTintColor: Colors.transparent,
        child: Theme(
          data: Theme.of(
            context,
          ).copyWith(splashColor: lessonColor.withOpacity(0.1), highlightColor: Colors.transparent),
          child: PlatformInkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => widget.onTap?.call(widget.lesson),
            child: Stack(
              children: [
                if (_progress != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: _progress!, end: _progress!),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, animatedProgress, child) {
                        return GradientProgressBar(
                          progress: animatedProgress,
                          height: 3,
                          startColor: lessonColor,
                          endColor: lessonColor.withOpacity(0.7),
                        );
                      },
                    ),
                  ),
                Container(
                  constraints: const BoxConstraints(minHeight: 75),
                  padding: EdgeInsets.only(
                    top: _progress != null ? (isDesktop ? 12 : 16) : (isDesktop ? 8 : 12),
                    bottom: isDesktop ? 8 : 12,
                    left: isDesktop ? 12 : 16,
                    right: isDesktop ? 12 : 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lesson.subject,
                        style: AppTextStyle.titleM.copyWith(height: 1.3, fontWeight: FontWeight.w600),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTag(
                              context,
                              '${widget.lesson.lessonBells.startTime} - ${widget.lesson.lessonBells.endTime}',
                              lessonColor,
                              isHighlighted: true,
                              icon: HugeIcons.strokeRoundedClock01,
                            ),
                            const SizedBox(width: 8),
                            _buildTag(
                              context,
                              '${widget.lesson.lessonBells.number} пара',
                              lessonColor.withOpacity(0.7),
                              showBorder: true,
                            ),
                            const SizedBox(width: 8),
                            _buildTag(context, LessonCard.getLessonTypeName(widget.lesson.lessonType), lessonColor),
                          ],
                        ),
                      ),
                      // Details section
                      Animate(autoPlay: false).toggle(
                        builder: (_, value, child) {
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 150),
                            child: state.isMiniature ? const SizedBox() : _buildDetailsSection(context),
                          );
                        },
                      ),
                      // Comments
                      _buildCommentAlert(context, state.comments),
                      // Group indicator for overlapping lessons
                      if ((widget.indexInGroup != null && widget.countInGroup != null) && widget.countInGroup! > 1)
                        _buildGroupIndicator(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(
    BuildContext context,
    String text,
    Color color, {
    bool isHighlighted = false,
    bool showBorder = false,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: icon != null ? 8 : 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            isHighlighted
                ? color.withOpacity(0.15)
                : showBorder
                ? Colors.transparent
                : Theme.of(context).extension<AppColors>()!.background03,
        border: showBorder ? Border.all(color: color.withOpacity(0.3), width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            HugeIcon(
              icon: icon,
              size: 14,
              color: isHighlighted ? color : Theme.of(context).extension<AppColors>()!.deactive,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTextStyle.captionL.copyWith(
              color: isHighlighted ? color : Theme.of(context).extension<AppColors>()!.deactive,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final state = context.read<ScheduleBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        // Location info
        if (widget.lesson.classrooms.isNotEmpty)
          _buildInfoRow(
            context,
            HugeIcons.strokeRoundedUniversity,
            _getClassroomNames(widget.lesson.classrooms),
            Theme.of(context).extension<AppColors>()!.active,
          ),

        // Groups info
        if (widget.lesson.groups != null &&
            ((state.selectedSchedule is! SelectedGroupSchedule && widget.lesson.groups!.isNotEmpty) ||
                (state.selectedSchedule is SelectedGroupSchedule && widget.lesson.groups!.length > 1)))
          _buildInfoRow(
            context,
            HugeIcons.strokeRoundedUserGroup,
            widget.lesson.groups?.join(', ') ?? '',
            Theme.of(context).extension<AppColors>()!.deactive,
          ),

        // Teacher info
        if (widget.lesson.teachers.isNotEmpty)
          _buildInfoRow(
            context,
            HugeIcons.strokeRoundedTeacher,
            widget.lesson.teachers.map((e) => e.name).join(', '),
            Theme.of(context).extension<AppColors>()!.deactive,
          ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: HugeIcon(icon: icon, size: 14, color: Theme.of(context).extension<AppColors>()!.deactive),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: AppTextStyle.body.copyWith(color: textColor, height: 1.3),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupIndicator(BuildContext context) {
    if (widget.indexInGroup == null || widget.countInGroup == null) {
      return const SizedBox.shrink();
    }

    final lessonColor = LessonCard.getColorByType(widget.lesson.lessonType);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${widget.indexInGroup! + 1}/${widget.countInGroup} ${Intl.plural(widget.countInGroup!, one: 'пара', few: 'пары', many: 'пар', other: 'пар')}',
              style: AppTextStyle.captionL.copyWith(
                color: Theme.of(context).extension<AppColors>()!.deactive,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: List.generate(
              widget.countInGroup!,
              (i) => Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: i == widget.indexInGroup! ? lessonColor : lessonColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color startColor;
  final Color endColor;

  const GradientProgressBar({
    super.key,
    required this.progress,
    this.height = 3,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        return SizedBox(
          width: fullWidth,
          height: height,
          child: Stack(
            children: [
              // Background
              Container(
                width: fullWidth,
                height: height,
                color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.3),
              ),

              // Progress
              Container(
                width: fullWidth * progress,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [startColor, endColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
