import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';

class MapSavedPlacesSheet extends StatefulWidget {
  const MapSavedPlacesSheet({
    required this.repository,
    required this.onOpen,
    super.key,
  });

  final MapDataRepository repository;
  final ValueChanged<MapBookmark> onOpen;

  @override
  State<MapSavedPlacesSheet> createState() => _MapSavedPlacesSheetState();
}

class _MapSavedPlacesSheetState extends State<MapSavedPlacesSheet> {
  List<MapBookmark> _bookmarks = const [];
  final _removing = <(String, String)>{};
  final _search = TextEditingController();
  String _query = '';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.repository.isAuthenticated) unawaited(_load());
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_loading || _removing.isNotEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final bookmarks = await widget.repository.getBookmarks();
      if (!mounted) return;
      setState(() => _bookmarks = bookmarks);
    } on Object {
      if (!mounted) return;
      setState(
        () => _error =
            'Не удалось загрузить сохранённые места. '
            'Проверьте подключение и повторите.',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _remove(MapBookmark bookmark) async {
    final key = (bookmark.campusId, bookmark.roomId);
    if (_loading || _removing.contains(key)) return;
    setState(() {
      _removing.add(key);
      _error = null;
    });
    try {
      final saved = await widget.repository.setBookmark(
        bookmark.campusId,
        bookmark.roomId,
        saved: false,
      );
      if (!mounted) return;
      if (saved) {
        setState(
          () => _error =
              'Сервер не подтвердил удаление. '
              'Место остаётся в сохранённых.',
        );
        return;
      }
      setState(() {
        _bookmarks = _bookmarks
            .where(
              (item) =>
                  item.campusId != bookmark.campusId ||
                  item.roomId != bookmark.roomId,
            )
            .toList();
      });
    } on Object {
      if (!mounted) return;
      setState(
        () => _error =
            'Не удалось убрать место. '
            'Оно остаётся в сохранённых — попробуйте ещё раз.',
      );
    } finally {
      if (mounted) setState(() => _removing.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.repository.isAuthenticated) {
      return const AppBanner(
        message:
            'Войдите в аккаунт, чтобы открыть сохранённые места. '
            'Они синхронизируются между вашими устройствами.',
        tone: AppBannerTone.warn,
      );
    }
    final matches = _bookmarks.where((bookmark) {
      final text = roomKey('${bookmark.roomLabel} ${bookmark.campusTitle}');
      return _query.isEmpty || text.contains(_query);
    }).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_bookmarks.length > 5 || _query.isNotEmpty) ...[
          AppSearchField(
            controller: _search,
            hintText: 'Найти сохранённое место',
            onChanged: (value) => setState(() => _query = roomKey(value)),
            onClear: () => setState(() => _query = ''),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (_error != null) ...[
          AppBanner(message: _error!, tone: AppBannerTone.warn),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.sectionGap),
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        else if (_bookmarks.isEmpty && _error == null)
          const AppEmptyState(
            title: 'Пока нет сохранённых мест',
            icon: Icon(Icons.bookmark_border_rounded),
            subtitle: 'Откройте место на карте и нажмите «Сохранить».',
          )
        else if (matches.isEmpty && _error == null)
          const AppEmptyState.compact(
            title: 'Ничего не найдено',
            subtitle: 'Попробуйте номер аудитории или название корпуса.',
          )
        else
          for (final bookmark in matches) ...[
            _SavedPlaceCard(
              bookmark: bookmark,
              removing: _removing.contains((
                bookmark.campusId,
                bookmark.roomId,
              )),
              onOpen: () => widget.onOpen(bookmark),
              onRemove: () => _remove(bookmark),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        const SizedBox(height: AppSpacing.md),
        AppButton.secondary(
          label: _error == null ? 'Обновить список' : 'Повторить',
          expanded: true,
          onPressed: _loading || _removing.isNotEmpty ? null : _load,
        ),
      ],
    );
  }
}

class _SavedPlaceCard extends StatelessWidget {
  const _SavedPlaceCard({
    required this.bookmark,
    required this.removing,
    required this.onOpen,
    required this.onRemove,
  });

  final MapBookmark bookmark;
  final bool removing;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: EdgeInsets.zero,
    child: AppListRow(
      title: bookmark.roomLabel.isEmpty ? 'Место на карте' : bookmark.roomLabel,
      titleMaxLines: 2,
      subtitle: bookmark.campusTitle.isEmpty ? null : bookmark.campusTitle,
      strong: true,
      onTap: removing ? null : onOpen,
      trailing: removing
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : AppIconButton(
              tooltip: 'Убрать из сохранённых',
              icon: const Icon(Icons.bookmark_remove_outlined),
              onPressed: onRemove,
            ),
    ),
  );
}
