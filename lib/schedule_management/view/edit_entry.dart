part of 'edit_schedules_page.dart';

class _EditEntry {
  const _EditEntry({
    required this.id,
    required this.name,
    required this.schedule,
  });

  final String id;
  final String name;
  final List<SchedulePart> schedule;
}
