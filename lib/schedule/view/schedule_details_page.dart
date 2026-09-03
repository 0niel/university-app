import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart'
    show SettingsToggleRow;
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page/material_badge.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:rtu_mirea_app/schedule/view/teacher_profile_page.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_schedule_selector.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_metrics.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:rtu_mirea_app/search/widgets/global_search_button.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'schedule_details_page/helpers.dart';
part 'schedule_details_page/lesson_details_body.dart';
part 'schedule_details_page/lesson_details_loader.dart';
part 'schedule_details_page/lesson_reaction_queue.dart';
part 'schedule_details_page/lesson_runtime.dart';
part 'schedule_details_page/lesson_share_actions.dart';
part 'schedule_details_page/material_card.dart';
part 'schedule_details_page/material_card_skeleton.dart';
part 'schedule_details_page/material_inline_row.dart';
part 'schedule_details_page/material_inline_row_skeleton.dart';
part 'schedule_details_page/material_meta.dart';
part 'schedule_details_page/material_text.dart';
part 'schedule_details_page/lesson_materials_page.dart';
part 'schedule_details_page/materials_page_skeleton.dart';
part 'schedule_details_page/materials_preview.dart';
part 'schedule_details_page/materials_preview_skeleton.dart';
part 'schedule_details_page/contribute_banner.dart';
part 'schedule_details_page/empty_materials_card.dart';
part 'schedule_details_page/file_badge.dart';
part 'schedule_details_page/review_sheet.dart';
part 'schedule_details_page/reactions_section.dart';
part 'schedule_details_page/reactions_skeleton.dart';
part 'schedule_details_page/review_preview.dart';
part 'schedule_details_page/empty_review_prompt.dart';
part 'schedule_details_page/round_icon_button.dart';
part 'schedule_details_page/section_title.dart';
part 'schedule_details_page/subject_top_bar.dart';
part 'schedule_details_page/subject_hero.dart';
part 'schedule_details_page/lesson_progress_card.dart';
part 'schedule_details_page/lesson_action_grid.dart';
part 'schedule_details_page/teacher_card.dart';
part 'schedule_details_page/teacher_row.dart';
part 'schedule_details_page/group_note_card.dart';
part 'schedule_details_page/groups_card.dart';
part 'schedule_details_page/peers_card.dart';
part 'schedule_details_page/upload_material_sheet.dart';
part 'schedule_details_page/drop_zone.dart';
part 'schedule_details_page/source_button.dart';
part 'schedule_details_page/type_chip.dart';

class ScheduleDetailsPage extends StatefulWidget {
  const ScheduleDetailsPage({
    required this.lesson,
    required this.selectedDate,
    super.key,
  });

  final LessonSchedulePart lesson;
  final DateTime selectedDate;

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage>
    with _LessonDetailsLoader, _LessonReactionQueue, _LessonShareActions {
  @override
  void initState() {
    super.initState();
    _startDetailsLoad();
  }

  Future<void> _openMaterials() async {
    final scheduleRepository = RepositoryProvider.of<ScheduleRepository>(
      context,
    );
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: scheduleRepository,
          child: LessonMaterialsPage(
            lesson: widget.lesson,
            selectedDate: widget.selectedDate,
            lessonNumber: _lessonNumber,
          ),
        ),
      ),
    );
    if (mounted) unawaited(_loadDetails());
  }

  Future<void> _showReviewSheet() async {
    final saved = await showAppSheet<bool>(
      context,
      title: context.l10n.lessonDetailsReviewTitle,
      subtitle: widget.lesson.subject,
      child: RepositoryProvider<ScheduleRepository>.value(
        value: context.read(),
        child: _ReviewSheet(
          lesson: widget.lesson,
          selectedDate: widget.selectedDate,
          lessonNumber: _lessonNumber,
        ),
      ),
    );
    if (saved == true && mounted) await _loadDetails();
  }

  Future<void> _uploadMaterial() async {
    final uploaded = await showAppSheet<bool>(
      context,
      title: context.l10n.lessonDetailsMaterialToClass,
      subtitle: widget.lesson.subject,
      child: RepositoryProvider<ScheduleRepository>.value(
        value: context.read(),
        child: LessonMaterialUploadSheet(
          lesson: widget.lesson,
          selectedDate: widget.selectedDate,
          lessonNumber: _lessonNumber,
        ),
      ),
    );
    if (uploaded == true && mounted) await _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: _LessonDetailsBody(
        lesson: widget.lesson,
        selectedDate: widget.selectedDate,
        details: _details,
        loading: _loading,
        loadError: _loadError,
        reactionBusy: _reactionBusy,
        peers: _peers,
        teacherProfile: _teacherProfile,
        showGroups: _streamGroupNames.isNotEmpty,
        onBack: () => Navigator.of(context).maybePop(),
        onShare: () => showScheduleShareSheet(
          context,
          lesson: widget.lesson,
          day: widget.selectedDate,
        ),
        onMore: _showAddToCustomScheduleModal,
        onNote: () => showLessonNoteSheet(
          context,
          lesson: widget.lesson,
          day: widget.selectedDate,
        ),
        onRoute: _openRoute,
        onReactionTap: _toggleReaction,
        onReviewTap: () => unawaited(_showReviewSheet()),
        onRetryDetails: () => unawaited(_loadDetails()),
        onOpenMaterials: () => unawaited(_openMaterials()),
        onUploadMaterial: () => unawaited(_uploadMaterial()),
        onRemind: () => showLessonRemindSheet(
          context,
          lesson: widget.lesson,
          day: widget.selectedDate,
        ),
      ).animatePageEntrance(),
    );
  }
}
