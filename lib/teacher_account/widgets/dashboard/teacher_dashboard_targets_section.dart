import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_target_list.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherDashboardTargetsSection extends StatelessWidget {
  const TeacherDashboardTargetsSection({
    required this.groups,
    required this.rooms,
    required this.onOpenGroup,
    required this.onOpenRoom,
    super.key,
  });

  final List<Group> groups;
  final List<Classroom> rooms;
  final ValueChanged<Group> onOpenGroup;
  final ValueChanged<Classroom> onOpenRoom;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TeacherDashboardTargetList<Group>(
          key: const ValueKey('teacher-dashboard-groups'),
          title: l10n.teacherGroups,
          items: groups,
          labelFor: (group) => group.name,
          iconFor: (_) => AppLineIcon.people,
          onOpen: onOpenGroup,
        ),
        TeacherDashboardTargetList<Classroom>(
          key: const ValueKey('teacher-dashboard-rooms'),
          title: l10n.teacherRooms,
          items: rooms,
          labelFor: classroomLabel,
          iconFor: (room) =>
              room.isOnline ? AppLineIcon.link : AppLineIcon.door,
          onOpen: onOpenRoom,
        ),
      ],
    );
  }
}
