import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_kind.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_index.dart';

export 'map_place_kind.dart';

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
  int _limit = 20;
  late MapPlacesIndex _index;

  @override
  void initState() {
    super.initState();
    _rebuildIndex();
  }

  void _rebuildIndex() {
    _index = MapPlacesIndex(widget.campus);
    if (!_index.kinds.contains(_category)) _category = null;
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
    }
    final dataChanged = !_index.matches(widget.campus);
    if (dataChanged) _rebuildIndex();
    if (oldWidget.query != widget.query ||
        dataChanged ||
        oldWidget.currentFloorId != widget.currentFloorId) {
      _limit = 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFloor = widget.campus.floorForId(widget.currentFloorId ?? '');
    final query = widget.query.trim();
    final places = _index.select(
      query: widget.query,
      category: _category,
      currentFloorId: widget.currentFloorId,
      onlyCurrentFloor: _onlyCurrentFloor,
    );
    final currentCount = _index.countOnFloor(widget.currentFloorId);
    final firstFloor = currentFloor == null
        ? null
        : _floorLabel(currentFloor.floor.number).toLowerCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
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
                          '${firstFloor ?? currentFloor}',
                style: AppText.subtext.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
        SingleChildScrollView(
          key: const ValueKey('map-place-categories'),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
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
              for (final category in _index.kinds) ...[
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      RepaintBoundary(
                        key: ValueKey('map-place-paint-${entry.place.id}'),
                        child: AppListRow(
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
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

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
