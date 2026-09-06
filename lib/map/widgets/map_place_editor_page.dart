import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_graph_editor_page.dart';
import 'package:uuid/uuid.dart';

const _placeKinds = {
  'canteen': 'Столовая',
  'cafe': 'Кафе',
  'atm': 'Банкомат',
  'water': 'Питьевая вода',
  'printer': 'Печать и копирование',
  'vending': 'Торговый автомат',
  'restroom': 'Туалет',
  'library': 'Библиотека',
  'cloakroom': 'Гардероб',
  'medical': 'Медпункт',
  'classroom': 'Аудитория',
  'entrance': 'Вход',
  'elevator': 'Лифт',
  'stairs': 'Лестница',
  'service': 'Другое полезное место',
};

Map<String, Object?> buildMapPlaceEditorPatch({
  required CampusMapData campus,
  required String floorId,
  required Offset? position,
  required String label,
  required String kind,
  String description = '',
  MapPlaceData? room,
  Path? roomGeometry,
}) {
  final floor = campus.floorForId(floorId);
  if (floor == null) {
    throw const FormatException('Выберите существующий этаж кампуса.');
  }
  if (room != null &&
      (room.floorId != floorId ||
          !campus.rooms.any(
            (item) => item.id == room.id && item.floorId == floorId,
          ))) {
    throw const FormatException('Для существующего места нельзя менять этаж.');
  }
  if (position == null ||
      !position.dx.isFinite ||
      !position.dy.isFinite ||
      position.dx < 0 ||
      position.dy < 0 ||
      position.dx > floor.width ||
      position.dy > floor.height) {
    throw const FormatException('Отметьте место на плане.');
  }
  if (room != null &&
      (kind == 'classroom' || kind == 'room') &&
      roomGeometry != null &&
      !roomGeometry.contains(position)) {
    throw const FormatException(
      'Для аудитории выберите точку внутри её контура. '
      'Изменение стен можно предложить отдельно.',
    );
  }
  final name = label.trim();
  if (name.isEmpty || name.length > 160) {
    throw const FormatException('Укажите название: от 1 до 160 символов.');
  }
  if (!_placeKinds.containsKey(kind) && kind != room?.kind) {
    throw const FormatException('Выберите категорию места.');
  }
  if (description.trim().length > 2000) {
    throw const FormatException('Сократите описание до 2000 символов.');
  }
  return {
    if (room == null) 'floor_id': floorId,
    'x': position.dx,
    'y': position.dy,
    'label': name,
    'kind': kind,
    if (description.trim().isNotEmpty || room?.description != null)
      'description': description.trim(),
  };
}

class MapPlaceEditorPage extends StatefulWidget {
  const MapPlaceEditorPage({
    required this.campus,
    required this.repository,
    this.initialFloorId,
    this.room,
    super.key,
  });

  final CampusMapData campus;
  final MapDataRepository repository;
  final String? initialFloorId;
  final MapPlaceData? room;

  @override
  State<MapPlaceEditorPage> createState() => _MapPlaceEditorPageState();
}

class _MapPlaceEditorPageState extends State<MapPlaceEditorPage> {
  late final _label = TextEditingController(text: widget.room?.label);
  late final _description = TextEditingController(
    text: widget.room?.description,
  );
  late final String _entityId = widget.room?.id ?? const Uuid().v4();
  late String _kind = widget.room?.kind ?? 'canteen';
  late MapFloorData? _floor =
      widget.campus.floorForId(
        widget.room?.floorId ?? widget.initialFloorId ?? '',
      ) ??
      (widget.room == null ? widget.campus.floors.firstOrNull : null);
  late Offset? _point = widget.room == null
      ? null
      : Offset(widget.room!.x, widget.room!.y);
  bool _changed = false;
  bool _reviewBusy = false;
  String? _error;

  @override
  void dispose() {
    _label.dispose();
    _description.dispose();
    super.dispose();
  }

  void _selectFloor(MapFloorData floor) {
    if (floor.floor.id == _floor?.floor.id) return;
    setState(() {
      _floor = floor;
      _point = null;
      _error = null;
    });
  }

  Future<void> _selectKind() async {
    final kind = await showAppSheet<String>(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text('Категория', style: AppText.sectionSmall),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const AppSheetCloseButton(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppListGroup(
            children: [
              for (final kind in _placeKinds.entries)
                AppListRow(
                  title: kind.value,
                  titleMaxLines: null,
                  strong: kind.key == _kind,
                  trailing: kind.key == _kind
                      ? const AppLineIconWidget(AppLineIcon.check)
                      : null,
                  showChevron: false,
                  onTap: () =>
                      Navigator.of(context, rootNavigator: true).pop(kind.key),
                ),
            ],
          ),
        ],
      ),
    );
    if (kind == null || !mounted || kind == _kind) return;
    setState(() {
      _kind = kind;
      _changed = true;
    });
  }

  Future<void> _review() async {
    if (_reviewBusy) return;
    FocusScope.of(context).unfocus();
    setState(() => _reviewBusy = true);
    try {
      final floor = _floor;
      if (floor == null) return;
      Path? roomGeometry;
      final room = widget.room;
      if (room != null && (_kind == 'classroom' || _kind == 'room')) {
        final (rooms, _) = await SvgRoomParser(
          onLoadSvg: widget.repository.loadSvg,
        ).parseSvg(floor.floor.svgPath);
        if (!mounted) return;
        roomGeometry = rooms
            .where(
              (shape) => widget.campus.placeForId(shape.roomId)?.id == room.id,
            )
            .firstOrNull
            ?.path;
      }
      final patch = buildMapPlaceEditorPatch(
        campus: widget.campus,
        floorId: floor.floor.id,
        position: _point,
        label: _label.text,
        kind: _kind,
        description: _description.text,
        room: widget.room,
        roomGeometry: roomGeometry,
      );
      setState(() {
        _error = null;
        _reviewBusy = false;
      });
      final description = _description.text.trim();
      final relocationNotice = room != null && _point != Offset(room.x, room.y)
          ? '\nПосле переноса проходы к месту нужно проверить заново.'
          : '';
      final sent = await showMapEditorReview(
        context: context,
        campus: widget.campus,
        repository: widget.repository,
        entityType: widget.room == null ? 'place_create' : 'room',
        entityId: _entityId,
        patch: patch,
        summary:
            '${widget.room == null ? 'Новое место' : 'Изменение места'}: '
            '${_label.text.trim()}\n'
            '${_placeKinds[_kind] ?? 'Место'} · этаж ${floor.floor.number}.'
            '${description.isEmpty ? '' : '\n$description'}'
            '\nПоложение отмечено на плане. Проверьте, что точка '
            'находится у самого объекта или его входа.$relocationNotice',
      );
      if (sent && mounted) Navigator.pop(context, true);
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on Object {
      if (mounted) {
        setState(
          () => _error = 'Не удалось проверить план. Попробуйте ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _reviewBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final floor = _floor;
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: Column(
        children: [
          AppInnerHeader(
            title: widget.room == null ? 'Добавить место' : 'Исправить место',
            titleStyle: AppText.sectionSmall,
            onBack: () => Navigator.of(context).maybePop(),
            backSemanticsLabel: MaterialLocalizations.of(
              context,
            ).backButtonTooltip,
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: floor == null
                ? const Center(child: Text('План этажа недоступен.'))
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: widget.room == null
                            ? MapEditorFloorPicker(
                                floors: widget.campus.floors,
                                selected: floor.floor.id,
                                onSelected: _selectFloor,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Этаж ${floor.floor.number}',
                                  style: AppText.label,
                                ),
                              ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                          child: Text(
                            _point == null
                                ? 'Коснитесь положения объекта.'
                                : 'Касание передвигает точку.',
                            style: AppText.caption,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: (MediaQuery.sizeOf(context).height * .4)
                              .clamp(
                                220.0,
                                420.0,
                              ),
                          child: MapEditorFloorCanvas(
                            key: ValueKey(floor.floor.id),
                            floor: floor,
                            repository: widget.repository,
                            places: widget.campus.rooms,
                            onTap: (point, hitRadius) => setState(() {
                              _point = point;
                              _changed = true;
                              _error = null;
                            }),
                            painter: _PlacePainter(
                              floor: floor,
                              point: _point,
                              places: widget.campus.rooms
                                  .where(
                                    (room) =>
                                        room.floorId == floor.floor.id &&
                                        room.id != widget.room?.id,
                                  )
                                  .toList(),
                              color: context.colors.accent,
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList.list(
                          children: [
                            AppInputField(
                              controller: _label,
                              label: 'Название',
                              placeholder: 'Банкомат у главного входа',
                              maxLength: 160,
                              onChanged: (value) =>
                                  setState(() => _changed = true),
                            ),
                            const SizedBox(height: 16),
                            AppListGroup(
                              children: [
                                AppListRow(
                                  title:
                                      _placeKinds[_kind] ?? 'Текущая категория',
                                  titleMaxLines: null,
                                  subtitle: 'Категория',
                                  onTap: _selectKind,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AppInputField.multiline(
                              controller: _description,
                              label: 'Описание · необязательно',
                              placeholder:
                                  'Как найти, чем полезно, особенности доступа',
                              minLines: 2,
                              maxLines: 4,
                              maxLength: 2000,
                              onChanged: (value) =>
                                  setState(() => _changed = true),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Новое место и исправления появятся '
                              'после модерации. '
                              'Меню, оснащение и часы работы можно дополнить '
                              'в карточке опубликованного места.',
                              style: AppText.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: floor == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      AppBanner(message: _error!, tone: AppBannerTone.warn),
                      const SizedBox(height: 8),
                    ],
                    AppButton.primary(
                      label: 'Проверить',
                      expanded: true,
                      loading: _reviewBusy,
                      onPressed:
                          !_reviewBusy && (widget.room == null || _changed)
                          ? _review
                          : null,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _PlacePainter extends CustomPainter {
  const _PlacePainter({
    required this.floor,
    required this.point,
    required this.places,
    required this.color,
  });

  final MapFloorData floor;
  final Offset? point;
  final List<MapPlaceData> places;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Offset project(Offset point) => Offset(
      point.dx / floor.width * size.width,
      point.dy / floor.height * size.height,
    );
    for (final place in places) {
      canvas.drawCircle(
        project(Offset(place.x, place.y)),
        2.5,
        Paint()..color = Colors.blueGrey.withValues(alpha: .45),
      );
    }
    if (point case final point?) {
      final center = project(point);
      canvas
        ..drawCircle(center, 16, Paint()..color = color.withValues(alpha: .2))
        ..drawCircle(center, 10, Paint()..color = Colors.white)
        ..drawCircle(center, 7, Paint()..color = color)
        ..drawLine(
          center - const Offset(0, 20),
          center + const Offset(0, 20),
          Paint()
            ..color = color
            ..strokeWidth = 1.5,
        )
        ..drawLine(
          center - const Offset(20, 0),
          center + const Offset(20, 0),
          Paint()
            ..color = color
            ..strokeWidth = 1.5,
        );
    }
  }

  @override
  bool shouldRepaint(_PlacePainter oldDelegate) =>
      point != oldDelegate.point ||
      floor != oldDelegate.floor ||
      color != oldDelegate.color ||
      places != oldDelegate.places;
}
