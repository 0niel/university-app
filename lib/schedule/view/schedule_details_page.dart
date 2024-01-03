import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScheduleDetailsPage extends StatefulWidget {
  const ScheduleDetailsPage({super.key, required this.lesson});

  final LessonSchedulePart lesson;

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  final mapTileLayer = TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'ninja.mirea.mireaapp',
    tileProvider: CancellableNetworkTileProvider(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        title: const Text(
          'Предмет',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildPageContent(),
        ),
      ),
    );
  }

  List<Widget> _buildPageContent() {
    List<Widget> content = [];

    content.addAll([
      _buildLessonTitle(),
      const Divider(),
      _buildLessonType(),
      const Divider(),
      ..._buildClassroomDetails(),
    ]);

    if (widget.lesson.groups != null && widget.lesson.groups!.isNotEmpty) {
      content.addAll([
        _buildGroups(),
        const Divider(),
      ]);
    }

    if (widget.lesson.teachers.isNotEmpty) {
      content.addAll([
        _buildTeachers(),
      ]);
    }

    return content;
  }

  ListTile _buildLessonTitle() {
    return ListTile(
      title: Text(
        'Название предмета'.toUpperCase(),
      ),
      subtitle: Text(widget.lesson.subject),
    );
  }

  // Build the lesson type
  ListTile _buildLessonType() {
    return ListTile(
      title: Text('Тип занятия'.toUpperCase()),
      subtitle: Row(
        children: [
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(
              color: LessonCard.getColorByType(widget.lesson.lessonType),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            LessonCard.getLessonTypeName(widget.lesson.lessonType),
            style: AppTextStyle.titleM,
          ),
        ],
      ),
    );
  }

  // Build the classroom details
  List<Widget> _buildClassroomDetails() {
    return widget.lesson.classrooms.map((classroom) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Аудитория'.toUpperCase()),
            subtitle: Text(classroom.name),
            trailing: const Icon(
              Icons.chevron_right_sharp,
              size: 24,
            ),
            onTap: () => context.go('/schedule/search', extra: classroom.name),
          ),
          const Divider(),
          if (classroom.campus != null &&
              classroom.campus?.latitude != null) ...[
            ListTile(
              title: Text('Кампус'.toUpperCase()),
              subtitle: Text(classroom.campus!.name),
            ),
            _buildClassroomMap(classroom),
            const Divider(
              height: 32,
            ),
          ],
        ],
      );
    }).toList();
  }

  // Build the map for the classroom
  SizedBox _buildClassroomMap(Classroom classroom) {
    return SizedBox(
      height: 200,
      child: FlutterMap(
        options: MapOptions(
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
          initialCenter: LatLng(
            classroom.campus!.latitude!,
            classroom.campus!.longitude!,
          ),
          crs: const Epsg3857(),
          onTap: (tapPosition, point) {
            launchUrlString(
                'https://yandex.ru/maps/?ll=${classroom.campus!.longitude},${classroom.campus!.latitude}&z=15&mode=whatshere&whatshere%5Bpoint%5D=${classroom.campus!.longitude},${classroom.campus!.latitude}&whatshere%5Bzoom%5D=15&whatshere%5Bdirection%5D=down&whatshere%5Bviewport%5D=%5B${classroom.campus!.longitude! - 0.0001},${classroom.campus!.latitude! - 0.0001}%2C${classroom.campus!.longitude! + 0.0001},${classroom.campus!.latitude! + 0.0001}%5D&basemap=map');
          },
        ),
        children: [
          mapTileLayer,
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(
                  classroom.campus!.latitude!,
                  classroom.campus!.longitude!,
                ),
                color: AppTheme.colors.primary,
                borderColor: AppTheme.colors.colorful01,
                radius: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the groups
  ListTile _buildGroups() {
    return ListTile(
      title: Text('Группы'.toUpperCase()),
      subtitle: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: widget.lesson.groups?.map((group) {
              return InputChip(
                label: Text(group),
                onPressed: () => context.go('/schedule/search', extra: group),
              );
            }).toList() ??
            [],
      ),
    );
  }

  // Build the teachers
  ListTile _buildTeachers() {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              Theme.of(context).listTileTheme.contentPadding!.horizontal / 2,
        ),
        child: Text('Преподаватели'.toUpperCase()),
      ),
      contentPadding: EdgeInsets.zero,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.lesson.teachers.map((teacher) {
          return ListTile(
            title: Text(
              teacher.name,
              style: AppTextStyle.titleM.copyWith(
                color: AppTheme.colors.active,
              ),
            ),
            subtitle: teacher.post != null
                ? Text(
                    teacher.post!,
                    style: AppTextStyle.captionS.copyWith(
                      color: AppTheme.colors.deactive,
                    ),
                  )
                : null,
            dense: true,
            visualDensity: VisualDensity.compact,
            trailing: const Icon(
              Icons.chevron_right_sharp,
              size: 24,
            ),
            onTap: () => context.go('/schedule/search', extra: teacher.name),
          );
        }).toList(),
      ),
    );
  }
}
