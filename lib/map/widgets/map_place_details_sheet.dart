import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/widgets/map_community_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_share_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPlaceDetailsSheet extends StatefulWidget {
  const MapPlaceDetailsSheet({
    required this.repository,
    required this.campus,
    required this.room,
    this.onRouteFrom,
    this.onRouteTo,
    this.onEditLocation,
    this.onClose,
    this.onRefreshMap,
    super.key,
  });

  final MapDataRepository repository;
  final CampusMapData campus;
  final MapPlaceData room;
  final VoidCallback? onRouteFrom;
  final VoidCallback? onRouteTo;
  final VoidCallback? onEditLocation;
  final VoidCallback? onClose;
  final VoidCallback? onRefreshMap;

  @override
  State<MapPlaceDetailsSheet> createState() => _MapPlaceDetailsSheetState();
}

class _MapPlaceDetailsSheetState extends State<MapPlaceDetailsSheet> {
  late DateTime _date = _moscowDate();
  MapRoomDetails? _details;
  bool _loading = true;
  bool _failed = false;
  bool _sourceFailed = false;
  bool? _saved;
  bool _bookmarkBusy = false;
  int _bookmarkGeneration = 0;
  bool _verificationBusy = false;
  MapRoomVerification? _verification;
  String? _actionError;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
    if (widget.repository.isAuthenticated) unawaited(_loadBookmark());
  }

  Future<void> _loadBookmark() async {
    final generation = _bookmarkGeneration;
    try {
      final bookmarks = await widget.repository.getBookmarks();
      if (!mounted || generation != _bookmarkGeneration) return;
      setState(() {
        _saved = bookmarks.any(
          (bookmark) =>
              bookmark.campusId == widget.campus.campus.id &&
              widget.campus.placeForId(bookmark.roomId)?.id == widget.room.id,
        );
      });
    } on Object {
      if (mounted && generation == _bookmarkGeneration) {
        setState(() => _saved = null);
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (_bookmarkBusy) return;
    _bookmarkGeneration++;
    setState(() {
      _bookmarkBusy = true;
      _actionError = null;
    });
    try {
      final saved = await widget.repository.setBookmark(
        widget.campus.campus.id,
        widget.room.id,
        saved: !(_saved ?? false),
      );
      if (mounted) setState(() => _saved = saved);
    } on Object catch (error) {
      if (mounted) {
        final message = mapContributionError(error);
        setState(() => _actionError = message);
        showNinjaToast(context, message: message);
      }
    } finally {
      if (mounted) setState(() => _bookmarkBusy = false);
    }
  }

  Future<void> _confirm() async {
    if (_verificationBusy) return;
    setState(() {
      _verificationBusy = true;
      _actionError = null;
    });
    try {
      final verification = await widget.repository.confirmRoom(
        widget.campus.campus.id,
        widget.room.id,
        _details!.revision,
        confirmed: !(_verification?.confirmedByMe ?? false),
      );
      if (mounted) setState(() => _verification = verification);
    } on Object catch (error) {
      if (mounted) setState(() => _actionError = mapContributionError(error));
    } finally {
      if (mounted) setState(() => _verificationBusy = false);
    }
  }

  Future<void> _load() async {
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final details = await widget.repository.getRoom(
        widget.campus.campus.id,
        widget.room.id,
        date: _date,
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        _details = details;
        _verification = details.verification;
        _loading = false;
      });
    } on Object {
      if (!mounted || generation != _generation) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  Future<void> _pickDate() async {
    final today = _moscowDate();
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: today.subtract(const Duration(days: 30)),
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Расписание аудитории',
    );
    if (date == null || !mounted) return;
    setState(() {
      _date = date;
    });
    await _load();
  }

  Future<void> _openSource() async {
    final source = Uri.tryParse(widget.campus.sourceUrl);
    if (source == null || source.scheme != 'https' || source.host.isEmpty) {
      setState(() => _sourceFailed = true);
      return;
    }
    try {
      final opened = await launchUrl(
        source,
        mode: LaunchMode.externalApplication,
      );
      if (!opened && mounted) setState(() => _sourceFailed = true);
    } on Object {
      if (mounted) setState(() => _sourceFailed = true);
    }
  }

  Future<void> _share(MapPlaceData room) => showAppSheet<void>(
    context,
    title: room.label,
    child: MapPlaceShareSheet(
      campusId: widget.campus.campus.id,
      roomId: room.id,
      title: '${room.label} · ${widget.campus.campus.displayName}',
    ),
  );

  Future<void> _edit(MapPlaceData room) => showAppSheet<void>(
    context,
    title: 'Уточнить место',
    subtitle: room.label,
    child: AppListGroup(
      children: [
        AppListRow(
          title: 'Сведения о месте',
          subtitle: 'Название, оснащение, часы работы или меню',
          leading: const AppIconTile(icon: AppLineIcon.pencil),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            unawaited(
              showMapCommunitySheet(
                context,
                repository: widget.repository,
                campus: widget.campus,
                room: room,
              ),
            );
          },
        ),
        if (widget.onEditLocation != null)
          AppListRow(
            title: 'Точка на плане',
            subtitle: 'Уточнить расположение и этаж',
            leading: const AppIconTile(icon: AppLineIcon.pin),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              widget.onEditLocation!();
            },
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final room = _details?.room ?? widget.room;
    final staleMap =
        _details != null &&
        (widget.campus.origin == MapDataOrigin.bundled ||
            _details!.revision != widget.campus.revision);
    final navigationNeedsReview = room.raw['navigation_needs_review'] == true;
    final canRoute = !staleMap && !navigationNeedsReview;
    final colors = context.colors;
    final metadata = room.metadata;
    final updatedAt = DateTime.tryParse('${metadata['updated_at'] ?? ''}');
    final verifiedAt = DateTime.tryParse('${metadata['verified_at'] ?? ''}');
    final capacity = metadata['capacity'];
    final accessibility = metadata['accessibility'];
    final menuDate = DateTime.tryParse('${metadata['menu_date'] ?? ''}');
    final expiry = DateTime.tryParse('${metadata['expires_at'] ?? ''}');
    final today = _moscowDate();
    final menuCurrent =
        menuDate != null &&
        DateUtils.isSameDay(menuDate, today) &&
        (expiry == null || expiry.isAfter(DateTime.now().toUtc()));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppChip(label: mapPlaceKindLabel(room.kind)),
                  AppChip(label: widget.campus.campus.displayName),
                  if (capacity is num)
                    AppChip(label: '${capacity.toInt()} мест'),
                ],
              ),
            ),
            if (widget.onClose != null) ...[
              const SizedBox(width: AppSpacing.sm),
              AppSheetCloseButton(onTap: widget.onClose),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(
                room.label,
                style: AppText.serif(
                  30,
                  height: 1.12,
                ).copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppIconButton(
              icon: _bookmarkBusy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : AppLineIconWidget(
                      _saved == true ? AppLineIcon.check : AppLineIcon.bookmark,
                    ),
              tooltip: _saved == true
                  ? 'Убрать из избранного'
                  : 'Сохранить место',
              shape: AppIconButtonShape.circle,
              tone: _saved == true
                  ? AppIconButtonTone.primary
                  : AppIconButtonTone.surface,
              onPressed: _bookmarkBusy ? null : _toggleBookmark,
            ),
            const SizedBox(width: AppSpacing.xs),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.share),
              tooltip: 'Поделиться · QR-код',
              shape: AppIconButtonShape.circle,
              tone: AppIconButtonTone.surface,
              onPressed: () => _share(room),
            ),
          ],
        ),
        if (room.description?.trim().isNotEmpty ?? false) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            room.description!,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 350 ||
                MediaQuery.textScalerOf(context).scale(16) > 22;
            final actions = [
              AppButton.primary(
                label: 'Маршрут сюда',
                expanded: true,
                onPressed: canRoute ? widget.onRouteTo : null,
              ),
              AppButton.secondary(
                label: 'Отсюда',
                expanded: true,
                onPressed: canRoute ? widget.onRouteFrom : null,
              ),
            ];
            return stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      actions[0],
                      const SizedBox(height: AppSpacing.sm),
                      actions[1],
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: actions[0]),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: actions[1]),
                    ],
                  );
          },
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        if (staleMap)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: AppBanner(
              message: navigationNeedsReview
                  ? 'Место перенесено. Обновите полный план; '
                        'проходы к нему ещё проверяются.'
                  : 'Обновите полный план, '
                        'чтобы построить актуальный маршрут.',
              tone: AppBannerTone.warn,
              actionLabel: widget.onRefreshMap == null
                  ? null
                  : 'Обновить карту',
              onAction: widget.onRefreshMap,
            ),
          )
        else if (navigationNeedsReview)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: AppBanner(
              message: 'Место перенесено. Проходы к нему ещё проверяются.',
              tone: AppBannerTone.warn,
            ),
          )
        else if (widget.onRouteTo == null)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: AppBanner(
              message: 'Для этого места пока нет проверенного пути на плане.',
              tone: AppBannerTone.warn,
            ),
          ),
        _PlaceSection(
          title: mapPlaceKindLabel(room.kind) == 'Аудитория'
              ? 'Об аудитории'
              : 'О месте',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (room.equipment.isNotEmpty)
                Text(room.equipment.join(' · '), style: AppText.body)
              else
                const Text('Оснащение ещё не указано.'),
              const SizedBox(height: AppSpacing.md),
              Text(switch (accessibility) {
                true ||
                'accessible' ||
                'wheelchair' => 'Доступно для маломобильных посетителей',
                false || 'not_accessible' => 'Есть ограничения доступности',
                final String value when value.isNotEmpty => value,
                _ => 'Доступность пока не проверена',
              }),
              if (room.openingHours?.trim().isNotEmpty ?? false) ...[
                const SizedBox(height: AppSpacing.md),
                Text('Часы работы: ${room.openingHours}'),
              ],
            ],
          ),
        ),
        if (room.menu.isNotEmpty || _isFood(room.kind)) ...[
          const SizedBox(height: AppSpacing.lg),
          _PlaceSection(
            title: menuDate == null
                ? 'Меню'
                : 'Меню · ${_formatDate(menuDate)}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!menuCurrent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppBanner(
                      message: menuDate == null
                          ? 'Дата меню не подтверждена. '
                                'Наличие и цены могут отличаться.'
                          : 'Это меню на другую дату '
                                'или срок его действия истёк.',
                      tone: AppBannerTone.warn,
                    ),
                  ),
                if (room.menu.isEmpty)
                  const Text(
                    'Меню пока не добавлено. '
                    'Поделитесь актуальным меню через исправление.',
                  ),
                for (final item in room.menu)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: AppText.label),
                        if (item.description?.isNotEmpty ?? false)
                          Text(item.description!, style: AppText.subtext),
                        if (item.price != null)
                          Text(
                            '${_formatPrice(item.price!)} '
                            '${item.currency == 'RUB' ? '₽' : item.currency}',
                          ),
                        if (!item.available)
                          Text(
                            'Нет в наличии',
                            style: AppText.subtext.copyWith(
                              color: colors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        _PlaceSection(
          title: 'Расписание',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton.secondary(
                label: '${_formatDate(_date)} · МСК',
                onPressed: _pickDate,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              else if (_failed)
                AppBanner(
                  message: 'Не удалось обновить данные и расписание.',
                  tone: AppBannerTone.warn,
                  actionLabel: 'Повторить',
                  onAction: _load,
                )
              else if (!(_details?.scheduleLinked ?? false))
                const Text(
                  'Аудитория ещё не связана с расписанием. '
                  'Занятость неизвестна.',
                )
              else if (_details!.schedule.isEmpty)
                const Text(
                  'На эту дату занятий в расписании нет. '
                  'Аудитория может быть занята вне расписания.',
                )
              else
                for (final lesson in _details!.schedule)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_clock(lesson.startTime)}–'
                          '${_clock(lesson.endTime)}',
                          style: AppText.label,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(lesson.title, style: AppText.body),
                        if (lesson.groups.isNotEmpty)
                          Text(
                            lesson.groups.join(', '),
                            style: AppText.subtext.copyWith(
                              color: colors.muted,
                            ),
                          ),
                        if (lesson.teachers.isNotEmpty)
                          Text(
                            lesson.teachers.join(', '),
                            style: AppText.subtext.copyWith(
                              color: colors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppListGroup(
          key: const ValueKey('map-place-actions'),
          children: [
            AppDisclosure(
              title: 'Фотографии места',
              leading: const AppIconTile(icon: AppLineIcon.image),
              child: RoomPhotoGallery(
                campus: widget.campus.campus.displayName,
                roomName: room.label,
              ),
            ),
            AppListRow(
              title: 'Предложить исправление',
              titleMaxLines: null,
              leading: const AppIconTile(icon: AppLineIcon.pencil),
              onTap: () => _edit(room),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _verification == null
                    ? 'Подтверждения сообщества не загружены'
                    : 'Подтверждений этой версии: '
                          '${_verification!.confirmationCount}',
                style: AppText.label,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text('Подтверждайте сведения после личной проверки места.'),
              const SizedBox(height: AppSpacing.md),
              AppButton.tonal(
                label: _verification?.confirmedByMe ?? false
                    ? 'Отозвать подтверждение'
                    : 'Подтверждаю сведения',
                expanded: true,
                loading: _verificationBusy,
                onPressed: _verificationBusy || _verification == null
                    ? null
                    : _confirm,
              ),
            ],
          ),
        ),
        if (_actionError != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppBanner(message: _actionError!, tone: AppBannerTone.warn),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          verifiedAt == null
              ? 'Сведения о проверке не указаны'
              : 'Проверено ${_formatDate(verifiedAt)}',
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
        if (updatedAt != null)
          Text(
            'Обновлено ${_formatDate(updatedAt)}',
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Планы этажей: ${widget.campus.sourceLabel}',
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
        AppButton.text(
          label:
              '${Uri.tryParse(widget.campus.sourceUrl)?.host ?? 'Планы'}'
              ' · источник',
          onPressed: _openSource,
        ),
        if (_sourceFailed)
          SelectableText(
            'Источник: ${widget.campus.sourceUrl}',
          ),
      ],
    );
  }
}

class _PlaceSection extends StatelessWidget {
  const _PlaceSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppText.label.copyWith(color: context.colors.ink)),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    ),
  );
}

String mapPlaceKindLabel(String kind) => switch (kind) {
  'room' || 'classroom' || 'lecture_hall' => 'Аудитория',
  'canteen' || 'cafeteria' || 'cafe' || 'food' => 'Питание',
  'atm' => 'Банкомат',
  'toilet' || 'restroom' => 'Туалет',
  'elevator' || 'lift' => 'Лифт',
  'stairs' || 'staircase' => 'Лестница',
  'entrance' || 'exit' => 'Вход / выход',
  'library' => 'Библиотека',
  'vending' || 'vending_machine' => 'Автомат',
  'office' => 'Кабинет',
  'laboratory' || 'lab' => 'Лаборатория',
  'medical' => 'Медпункт',
  _ => 'Место',
};

DateTime _moscowDate() {
  final now = DateTime.now().toUtc().add(const Duration(hours: 3));
  return DateTime(now.year, now.month, now.day);
}

String _formatDate(DateTime date) =>
    DateFormat('d MMMM yyyy', 'ru').format(date);
String _formatPrice(double value) => NumberFormat('0.##', 'ru').format(value);
String _clock(String value) =>
    RegExp(r'^\d{2}:\d{2}').hasMatch(value) ? value.substring(0, 5) : value;
bool _isFood(String kind) =>
    const ['canteen', 'cafeteria', 'cafe', 'food'].contains(kind);
