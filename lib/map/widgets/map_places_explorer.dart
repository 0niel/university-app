import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';
import 'package:url_launcher/url_launcher.dart';

String mapPlaceKindLabel(String kind) => switch (kind) {
  'room' || 'classroom' => 'Аудитория',
  'cafeteria' || 'cafe' || 'canteen' || 'food' => 'Еда',
  'atm' || 'bank' => 'Банкомат',
  'toilet' || 'restroom' || 'wc' => 'Туалет',
  'entrance' || 'exit' => 'Вход',
  'elevator' || 'lift' => 'Лифт',
  'stairs' || 'staircase' => 'Лестница',
  'library' => 'Библиотека',
  'water' || 'drinking_water' => 'Питьевая вода',
  'printer' || 'copy' => 'Печать',
  'wardrobe' || 'cloakroom' => 'Гардероб',
  'medical' || 'first_aid' => 'Медпункт',
  'vending' => 'Автомат',
  'study' || 'coworking' => 'Для учёбы',
  _ => 'Сервис',
};

IconData mapPlaceKindIcon(String kind) => switch (mapPlaceKindLabel(kind)) {
  'Аудитория' => Icons.meeting_room_outlined,
  'Еда' => Icons.restaurant_rounded,
  'Банкомат' => Icons.atm_rounded,
  'Туалет' => Icons.wc_rounded,
  'Вход' => Icons.door_front_door_outlined,
  'Лифт' => Icons.elevator_outlined,
  'Лестница' => Icons.stairs_outlined,
  'Библиотека' => Icons.local_library_outlined,
  'Питьевая вода' => Icons.water_drop_outlined,
  'Печать' => Icons.print_outlined,
  'Гардероб' => Icons.checkroom_rounded,
  'Медпункт' => Icons.medical_services_outlined,
  'Автомат' => Icons.local_cafe_outlined,
  _ => Icons.place_outlined,
};

class MapPlacesExplorer extends StatefulWidget {
  const MapPlacesExplorer({
    required this.campus,
    required this.query,
    required this.onPlace,
    required this.onCommunity,
    required this.onRefresh,
    this.currentFloorId,
    super.key,
  });

  final CampusMapData campus;
  final String query;
  final ValueChanged<MapPlaceData> onPlace;
  final VoidCallback onCommunity;
  final VoidCallback onRefresh;
  final String? currentFloorId;

  @override
  State<MapPlacesExplorer> createState() => _MapPlacesExplorerState();
}

class _MapPlacesExplorerState extends State<MapPlacesExplorer> {
  String? _category;
  bool _onlyCurrentFloor = false;
  bool _sourceFailed = false;
  int _limit = 20;
  late List<_PlaceEntry> _index;
  late List<String> _kinds;

  @override
  void initState() {
    super.initState();
    _rebuildIndex();
  }

  void _rebuildIndex() {
    final groups = <(String, String, String, String), _PlaceEntry>{};
    for (final place in widget.campus.rooms) {
      final label = roomKey(place.label);
      final category = mapPlaceKindLabel(place.kind);
      final separateService =
          category != 'Аудитория' &&
          (category != 'Сервис' || _metadataScore(place) > 0);
      final position = separateService
          ? '${place.x.toStringAsFixed(2)},${place.y.toStringAsFixed(2)}'
          : '';
      final key = (place.floorId, place.kind, label, position);
      final floor = widget.campus.floorForId(place.floorId)?.floor.number;
      final search = roomKey(
        [
          place.label,
          category,
          place.description ?? '',
          if (floor != null) '$floor этаж',
          ...place.equipment,
        ].join(' '),
      );
      final existing = groups[key];
      if (existing == null) {
        groups[key] = _PlaceEntry(place, search);
      } else {
        existing.search = '${existing.search} $search';
        if (_metadataScore(place) > _metadataScore(existing.place)) {
          existing.place = place;
        }
      }
    }
    _index = groups.values.toList();
    _kinds =
        _index
            .map((entry) => mapPlaceKindLabel(entry.place.kind))
            .toSet()
            .toList()
          ..sort();
    if (!_kinds.contains(_category)) _category = null;
  }

  String _subtitle(MapPlaceData room) {
    final floor = widget.campus.floorForId(room.floorId)?.floor.number;
    return [
      mapPlaceKindLabel(room.kind),
      if (floor != null) _floorLabel(floor),
      ...room.equipment.take(2),
    ].join(' · ');
  }

  @override
  void didUpdateWidget(MapPlacesExplorer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.campus.campus.id != widget.campus.campus.id) {
      _category = null;
      _onlyCurrentFloor = false;
      _sourceFailed = false;
    }
    if (oldWidget.campus != widget.campus) _rebuildIndex();
    if (oldWidget.query != widget.query ||
        oldWidget.campus != widget.campus ||
        oldWidget.currentFloorId != widget.currentFloorId) {
      _limit = 20;
    }
  }

  Future<void> _openSource() async {
    final uri = Uri.tryParse(widget.campus.sourceUrl);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return;
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && mounted) setState(() => _sourceFailed = true);
    } on Object {
      if (mounted) setState(() => _sourceFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.query
        .trim()
        .split(RegExp(r'\s+'))
        .map(roomKey)
        .where((token) => token.isNotEmpty)
        .toList();
    final currentFloor = widget.campus.floorForId(widget.currentFloorId ?? '');
    final query = roomKey(widget.query);
    final places =
        _index.where((entry) {
          final room = entry.place;
          if (_category != null && mapPlaceKindLabel(room.kind) != _category) {
            return false;
          }
          if (_onlyCurrentFloor &&
              currentFloor != null &&
              room.floorId != widget.currentFloorId) {
            return false;
          }
          return tokens.every(entry.search.contains);
        }).toList()..sort((a, b) {
          final exactA = query.isNotEmpty && a.label == query;
          final exactB = query.isNotEmpty && b.label == query;
          if (exactA != exactB) return exactA ? -1 : 1;
          final currentA = a.place.floorId == widget.currentFloorId;
          final currentB = b.place.floorId == widget.currentFloorId;
          if (currentA != currentB) return currentA ? -1 : 1;
          final labelOrder = _compareNatural(a.parts, b.parts);
          if (labelOrder != 0) return labelOrder;
          final floorA = widget.campus
              .floorForId(a.place.floorId)
              ?.floor
              .number;
          final floorB = widget.campus
              .floorForId(b.place.floorId)
              ?.floor
              .number;
          final floorOrder = (floorA ?? 0).compareTo(floorB ?? 0);
          if (floorOrder != 0) return floorOrder;
          return a.place.id.compareTo(b.place.id);
        });
    final currentCount = _index
        .where((entry) => entry.place.floorId == widget.currentFloorId)
        .length;
    final sourceUri = Uri.tryParse(widget.campus.sourceUrl);
    final hasSource =
        sourceUri?.scheme == 'https' && (sourceUri?.host.isNotEmpty ?? false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Места и сервисы', style: AppText.sectionLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          query.isNotEmpty
              ? 'Найдено мест: ${places.length}'
              : currentFloor == null
              ? '${places.length} мест на карте'
              : '${places.length} мест · '
                    'сначала '
                    '${_floorLabel(currentFloor.floor.number).toLowerCase()}',
          style: AppText.subtext.copyWith(color: context.colors.muted),
        ),
        if (hasSource)
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton.text(
              label: widget.campus.sourceLabel.isEmpty
                  ? 'Источник планов'
                  : '${widget.campus.sourceLabel} · источник',
              size: AppButtonSize.small,
              onPressed: _openSource,
            ),
          ),
        if (_sourceFailed) ...[
          const AppBanner(
            message: 'Не удалось открыть источник. Ссылка доступна ниже.',
            tone: AppBannerTone.warn,
          ),
          SelectableText(widget.campus.sourceUrl, style: AppText.subtext),
        ],
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (currentFloor != null) ...[
                AppChip.filter(
                  label: _floorLabel(currentFloor.floor.number),
                  count: currentCount,
                  selected: _onlyCurrentFloor,
                  onTap: () => setState(() {
                    _onlyCurrentFloor = !_onlyCurrentFloor;
                    _limit = 20;
                  }),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              AppChip.filter(
                label: 'Всё',
                selected: _category == null,
                onTap: () => setState(() {
                  _category = null;
                  _limit = 20;
                }),
              ),
              for (final category in _kinds) ...[
                const SizedBox(width: AppSpacing.sm),
                AppChip.filter(
                  label: category,
                  selected: _category == category,
                  onTap: () => setState(() {
                    _category = category;
                    _limit = 20;
                  }),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (places.isEmpty)
          const AppBanner(
            message:
                'Совпадений нет. Попробуйте номер '
                'аудитории, название сервиса или оснащение.',
          )
        else
          AppListGroup(
            dividerIndent:
                AppSpacing.lg + AppControlSize.iconTile + AppSpacing.md,
            children: [
              for (final entry in places.take(_limit))
                AppListRow(
                  key: ValueKey(entry.place.id),
                  title: _placeTitle(entry.place),
                  titleMaxLines: 2,
                  subtitle: _subtitle(entry.place),
                  strong: true,
                  leading: AppIconTile(
                    background: context.colors.tintOf(
                      _categoryColor(context, entry.place.kind),
                    ),
                    child: Icon(
                      mapPlaceKindIcon(entry.place.kind),
                      size: AppIconSize.md,
                      color: _categoryColor(context, entry.place.kind),
                    ),
                  ),
                  onTap: () => widget.onPlace(entry.place),
                ),
            ],
          ),
        if (places.length > _limit)
          AppButton.text(
            label: 'Ещё ${places.length - _limit} мест',
            onPressed: () => setState(() => _limit += 30),
          ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton.secondary(
              label: 'Улучшить карту',
              size: AppButtonSize.small,
              onPressed: widget.onCommunity,
            ),
            AppButton.text(
              label: 'Обновить данные',
              size: AppButtonSize.small,
              onPressed: widget.onRefresh,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Версия ${widget.campus.revision} · '
          '${switch (widget.campus.origin) {
            MapDataOrigin.remote => 'Загружена с сервера',
            MapDataOrigin.cache => 'Сохранённая карта',
            MapDataOrigin.bundled => 'Карта из приложения',
          }}',
          style: AppText.caption.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _PlaceEntry {
  _PlaceEntry(this.place, this.search)
    : label = roomKey(place.label),
      parts = _naturalParts(roomKey(place.label));

  MapPlaceData place;
  String search;
  final String label;
  final List<(String, int?)> parts;
}

int _metadataScore(MapPlaceData place) =>
    (place.description?.isNotEmpty ?? false ? 4 : 0) +
    (place.scheduleClassroomId?.isNotEmpty ?? false ? 8 : 0) +
    place.equipment.length +
    place.menu.length +
    (place.openingHours?.isNotEmpty ?? false ? 2 : 0) +
    (place.capacity == null ? 0 : 1);

String _floorLabel(int number) => switch (number) {
  0 => 'Цокольный этаж',
  < 0 => 'Подземный этаж ${number.abs()}',
  _ => '$number этаж',
};

String _placeTitle(MapPlaceData place) {
  final label = place.label.trim();
  if (label.isEmpty) return mapPlaceKindLabel(place.kind);
  if (mapPlaceKindLabel(place.kind) == 'Аудитория' &&
      RegExp(r'^\d+[а-яА-Яa-zA-Z]?$').hasMatch(label)) {
    return 'Аудитория $label';
  }
  return label;
}

Color _categoryColor(BuildContext context, String kind) =>
    switch (mapPlaceKindLabel(kind)) {
      'Еда' || 'Автомат' => context.colors.warn,
      'Банкомат' || 'Библиотека' || 'Для учёбы' => context.colors.lecture,
      'Медпункт' => context.colors.danger,
      _ => context.colors.accent,
    };

List<(String, int?)> _naturalParts(String label) =>
    RegExp(r'\d+|\D+').allMatches(label).map((match) {
      final part = match.group(0)!;
      return (part, int.tryParse(part));
    }).toList();

int _compareNatural(List<(String, int?)> a, List<(String, int?)> b) {
  for (var index = 0; index < a.length && index < b.length; index++) {
    final (partA, numberA) = a[index];
    final (partB, numberB) = b[index];
    final order = numberA != null && numberB != null
        ? numberA.compareTo(numberB)
        : partA.compareTo(partB);
    if (order != 0) return order;
  }
  return a.length.compareTo(b.length);
}
