import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/forms/text_input.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScheduleDetailsPage extends StatefulWidget {
  const ScheduleDetailsPage({
    super.key,
    required this.lesson,
    required this.selectedDate,
  });

  final LessonSchedulePart lesson;

  /// The date in the [Calendar] where the lesson was selected to display the
  /// details.
  final DateTime selectedDate;

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  final mapTileLayer = TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'ninja.mirea.mireaapp',
    tileProvider: CancellableNetworkTileProvider(),
  );

  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    final comment = _getComment();

    if (comment != null) {
      _textController.text = comment.text;
    }

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
          comment: ScheduleComment(
            subjectName: widget.lesson.subject,
            lessonDate: widget.lesson.dates.first,
            lessonBells: widget.lesson.lessonBells,
            text: _textController.text,
          ),
        ),
      );
    });
  }

  ScheduleComment? _getComment() {
    final bloc = context.read<ScheduleBloc>();

    return bloc.state.comments.firstWhereOrNull(
      (comment) => widget.lesson.dates.contains(comment.lessonDate) && comment.lessonBells == widget.lesson.lessonBells,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String? _textErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        const Divider(height: 16),
      ]);
    }

    if (widget.lesson.teachers.isNotEmpty) {
      content.addAll([
        _buildTeachers(),
        const Divider(height: 8),
      ]);
    }

    content.addAll([
      ListTile(
        title: Text('Комментарий'.toUpperCase()),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextInput(
              hintText: 'Введите комментарий',
              controller: _textController,
              errorText: _textErrorText,
              maxLines: 5,
              fillColor:
                  AdaptiveTheme.of(context).mode.isDark ? AppTheme.colorsOf(context).background03 : Colors.white),
        ),
      ),
      const Divider(),
    ]);

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
          if (classroom.campus != null && classroom.campus?.latitude != null) ...[
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

  ListTile _buildTeachers() {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Theme.of(context).listTileTheme.contentPadding!.horizontal / 2,
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
                color: AppTheme.colorsOf(context).active,
              ),
            ),
            subtitle: teacher.post != null
                ? Text(
                    teacher.post!,
                    style: AppTextStyle.captionS.copyWith(
                      color: AppTheme.colorsOf(context).deactive,
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
