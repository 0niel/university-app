import 'dart:async';
import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/widgets/map_contribution_form.dart';

Future<void> showMapCommunitySheet(
  BuildContext context, {
  required MapDataRepository repository,
  required CampusMapData campus,
  MapPlaceData? room,
  String? floorId,
}) => showAppSheet<void>(
  context,
  title: 'Улучшаем карту вместе',
  subtitle: room?.label ?? campus.campus.displayName,
  maxHeightFraction: .94,
  child: MapCommunitySheet(
    repository: repository,
    campus: campus,
    room: room,
    floorId: floorId,
  ),
);

class MapCommunitySheet extends StatefulWidget {
  const MapCommunitySheet({
    required this.repository,
    required this.campus,
    this.room,
    this.floorId,
    super.key,
  });

  final MapDataRepository repository;
  final CampusMapData campus;
  final MapPlaceData? room;
  final String? floorId;

  @override
  State<MapCommunitySheet> createState() => _MapCommunitySheetState();
}

class _MapCommunitySheetState extends State<MapCommunitySheet> {
  bool _showHistory = false;
  bool _loading = false;
  bool _failed = false;
  String _status = 'pending';
  String? _notice;
  MapProposalList? _proposals;
  int _generation = 0;

  Future<void> _load() async {
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final proposals = await widget.repository.getProposals(
        widget.campus.campus.id,
        status: _status,
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        _proposals = proposals;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _loading = false;
        _failed = true;
        _notice = mapContributionError(error);
      });
    }
  }

  Future<void> _review(MapProposal proposal) async {
    final changed = await showAppSheet<bool>(
      context,
      title: 'Проверка предложения',
      subtitle: _targetLabel(proposal),
      maxHeightFraction: .94,
      child: MapProposalReview(
        repository: widget.repository,
        proposal: proposal,
      ),
    );
    if (changed != true || !mounted) return;
    setState(
      () => _notice =
          'Решение сохранено. Обновите карту, '
          'чтобы увидеть опубликованные изменения.',
    );
    await _load();
  }

  String _targetLabel(MapProposal proposal) {
    final place = widget.campus.placeForId(proposal.entityId);
    if (place != null) return place.label;
    final floor = widget.campus.floorForId(proposal.entityId);
    if (floor != null) return '${floor.floor.number} этаж';
    return widget.campus.campus.displayName;
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const AppBanner(
        message:
            'Исправления появляются на карте после проверки. '
            'Укажите, что изменилось и откуда это известно.',
      ),
      const SizedBox(height: AppSpacing.lg),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          AppChip(
            label: 'Предложить',
            selected: !_showHistory,
            onTap: () => setState(() => _showHistory = false),
          ),
          AppChip(
            label: 'Предложения',
            selected: _showHistory,
            onTap: () {
              setState(() => _showHistory = true);
              unawaited(_load());
            },
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      if (!_showHistory)
        MapContributionForm(
          repository: widget.repository,
          campus: widget.campus,
          room: widget.room,
          floorId: widget.floorId,
          onSubmitted: () {
            setState(() {
              _showHistory = true;
              _status = 'pending';
              _notice = 'Предложение отправлено на проверку.';
            });
            unawaited(_load());
          },
        )
      else ...[
        Text(
          _proposals?.canModerate ?? widget.campus.canModerate
              ? 'Очередь проверки и ваши предложения'
              : 'Ваши предложения',
          style: AppText.label,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final entry in const {
              'pending': 'На проверке',
              'approved': 'Приняты',
              'rejected': 'Отклонены',
            }.entries)
              AppChip(
                label: entry.value,
                selected: _status == entry.key,
                onTap: () {
                  setState(() {
                    _status = entry.key;
                    _notice = null;
                  });
                  unawaited(_load());
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (_notice != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: AppBanner(
              message: _notice!,
              tone: _failed ? AppBannerTone.warn : AppBannerTone.success,
            ),
          ),
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        else if (_failed)
          AppButton.secondary(label: 'Повторить загрузку', onPressed: _load)
        else if (_proposals?.proposals.isEmpty ?? true)
          const AppCard(
            child: Text('Здесь пока нет предложений с таким статусом.'),
          )
        else ...[
          for (final proposal in _proposals!.proposals)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ProposalCard(
                proposal: proposal,
                targetLabel: _targetLabel(proposal),
                onReview: () => _review(proposal),
              ),
            ),
          if (_proposals!.proposals.length >= 50)
            const Text(
              'Показаны последние 50 предложений. '
              'Остальные доступны после обработки очереди.',
            ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppButton.text(
          label: 'Обновить список',
          onPressed: _loading ? null : _load,
        ),
      ],
    ],
  );
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.proposal,
    required this.targetLabel,
    required this.onReview,
  });

  final MapProposal proposal;
  final String targetLabel;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppChip(label: _statusLabel(proposal)),
            if (proposal.isMine) const AppChip(label: 'Ваше'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(proposal.reason, style: AppText.label),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${_entityLabel(proposal.entityType)} · $targetLabel',
          style: AppText.subtext,
        ),
        if (proposal.createdAt != null)
          Text(
            '${_reviewDate(proposal.createdAt!)} МСК',
            style: AppText.subtext,
          ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Изменения: '
          '${proposal.patchKeys.map(mapPatchFieldLabel).join(', ')}',
          style: AppText.subtext,
        ),
        if (proposal.reviewNote?.isNotEmpty ?? false) ...[
          const SizedBox(height: AppSpacing.md),
          Text('Проверяющий: ${proposal.reviewNote}'),
        ],
        const SizedBox(height: AppSpacing.md),
        AppButton.secondary(
          label: proposal.canReview && proposal.status == 'pending'
              ? 'Проверить'
              : 'Подробнее',
          onPressed: onReview,
          expanded: true,
        ),
      ],
    ),
  );
}

class MapProposalReview extends StatefulWidget {
  const MapProposalReview({
    required this.repository,
    required this.proposal,
    super.key,
  });

  final MapDataRepository repository;
  final MapProposal proposal;

  @override
  State<MapProposalReview> createState() => _MapProposalReviewState();
}

class _MapProposalReviewState extends State<MapProposalReview> {
  final _note = TextEditingController();
  bool _busy = false;
  bool _loading = false;
  MapProposal? _proposal;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.proposal.hasFullPatch) {
      _proposal = widget.proposal;
    } else {
      unawaited(_loadDetails());
    }
  }

  Future<void> _loadDetails() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final proposal = await widget.repository.getProposal(widget.proposal.id);
      if (!mounted) return;
      if (proposal.id != widget.proposal.id || !proposal.hasFullPatch) {
        throw const FormatException('Incomplete map proposal details');
      }
      setState(() {
        _proposal = proposal;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = mapContributionError(error);
      });
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _review({required bool approve}) async {
    final proposal = _proposal;
    if (_busy ||
        _loading ||
        proposal == null ||
        !proposal.hasFullPatch ||
        !proposal.canReview ||
        proposal.isMine ||
        proposal.status != 'pending') {
      return;
    }
    final note = _note.text.trim();
    if (!approve && note.length < 5) {
      setState(
        () => _error = 'Укажите причину отклонения: не менее 5 символов.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.reviewProposal(
        proposal.id,
        approve: approve,
        note: note.isEmpty ? null : note,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = mapContributionError(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final proposal = _proposal ?? widget.proposal;
    final canReview =
        !_loading &&
        _proposal != null &&
        proposal.hasFullPatch &&
        proposal.canReview &&
        !proposal.isMine &&
        proposal.status == 'pending';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppChip(label: _statusLabel(proposal)),
        const SizedBox(height: AppSpacing.lg),
        Text(proposal.reason, style: AppText.body),
        const SizedBox(height: AppSpacing.lg),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else if (_proposal == null)
          AppButton.secondary(
            label: 'Повторить загрузку изменений',
            onPressed: _loadDetails,
          )
        else
          MapPatchPreview(patch: proposal.patch),
        const SizedBox(height: AppSpacing.lg),
        if (proposal.entityType == 'report')
          const AppBanner(
            message:
                'Принятие отмечает сообщение как проверенное. '
                'Геометрия и маршруты от этого не меняются.',
          ),
        if (proposal.isMine && proposal.status == 'pending')
          const AppBanner(
            message: 'Ваше предложение должен проверить другой модератор.',
          ),
        if (proposal.reviewNote?.isNotEmpty ?? false)
          AppBanner(message: 'Результат проверки: ${proposal.reviewNote}'),
        if (canReview) ...[
          const SizedBox(height: AppSpacing.lg),
          AppInputField.multiline(
            controller: _note,
            label: 'Комментарий к решению',
            helperText:
                'При отклонении обязательно объясните, что нужно уточнить.',
            maxLength: 2000,
            enabled: !_busy,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            label: proposal.entityType == 'report'
                ? 'Отметить проверенным'
                : 'Принять и опубликовать',
            expanded: true,
            loading: _busy,
            onPressed: _busy ? null : () => _review(approve: true),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton.secondary(
            label: 'Отклонить',
            expanded: true,
            onPressed: _busy ? null : () => _review(approve: false),
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.lg),
          AppBanner(message: _error!, tone: AppBannerTone.warn),
        ],
      ],
    );
  }
}

class MapPatchPreview extends StatelessWidget {
  const MapPatchPreview({required this.patch, super.key});

  final Map<String, Object?> patch;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Предлагаемые изменения', style: AppText.label),
        for (final entry in patch.entries) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            mapPatchFieldLabel(entry.key),
            style: AppText.subtext.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: AppSpacing.xs),
          SelectableText(_displayPatchValue(entry.key, entry.value)),
        ],
      ],
    ),
  );
}

String mapPatchFieldLabel(String field) => switch (field) {
  'label' => 'Название',
  'description' => 'Описание',
  'equipment' => 'Оснащение',
  'opening_hours' => 'Часы работы',
  'capacity' => 'Вместимость',
  'accessibility' => 'Доступность',
  'menu' => 'Меню',
  'menu_date' => 'Дата меню',
  'expires_at' => 'Срок актуальности',
  'category' => 'Категория сообщения',
  'details' => 'Что нужно проверить',
  'source_url' => 'Источник',
  'nodes' => 'Точки маршрутов',
  'edges' => 'Проходы',
  'svg' => 'План этажа',
  _ => field,
};

String _displayPatchValue(String key, Object? value) {
  if ((key == 'nodes' || key == 'edges') && value is List) {
    final count = NumberFormat.decimalPattern('ru').format(value.length);
    return key == 'nodes'
        ? 'Точек в схеме: $count'
        : 'Проходов в схеме: $count';
  }
  if (key == 'svg' && value is String) {
    return 'Обновлён векторный план этажа · ${value.length} символов';
  }
  return _displayValue(value);
}

String _displayValue(Object? value) {
  if (value == null || value == '') return 'Не указано';
  if (value is List && value.every((item) => item is String)) {
    return value.join(', ');
  }
  if (value is List && value.every((item) => item is Map)) {
    return value
        .map((item) {
          final row = item as Map;
          if (row['name'] is! String) return jsonEncode(row);
          final price = row['price'];
          final currency = row['currency'] == 'RUB'
              ? '₽'
              : row['currency'] ?? '';
          return '${row['name']}'
              '${price == null ? '' : ' · $price $currency'}'
              '${row['available'] == false ? ' · нет в наличии' : ''}';
        })
        .join('\n');
  }
  if (value is Map || value is List) {
    return const JsonEncoder.withIndent('  ').convert(value);
  }
  return value.toString();
}

String _reviewDate(DateTime date) => DateFormat(
  'dd.MM.yyyy HH:mm',
).format(date.toUtc().add(const Duration(hours: 3)));

String _entityLabel(String entity) => switch (entity) {
  'room' => 'Сведения о месте',
  'floor' => 'План этажа',
  'graph' => 'Маршруты',
  'report' => 'Сообщение о проблеме',
  _ => 'Карта кампуса',
};

String _statusLabel(MapProposal proposal) => switch (proposal.status) {
  'approved' => proposal.entityType == 'report' ? 'Проверено' : 'Опубликовано',
  'rejected' => 'Отклонено',
  'pending' => 'На проверке',
  _ => 'Статус уточняется',
};

String mapContributionError(Object error) {
  final code = error is MapDataException ? error.code : null;
  if (code == '40001') {
    return 'Карта уже изменилась. Закройте предложение, обновите карту '
        'и сравните исправление с новой версией. Решение не сохранено.';
  }
  if (const ['42501', '401', 'PGRST301', 'PGRST303'].contains(code)) {
    return 'Для этого действия войдите в аккаунт. '
        'Проверка чужих предложений доступна модераторам.';
  }
  return 'Не удалось выполнить действие. Проверьте подключение и повторите. '
      'Подтверждение от сервера не получено.';
}
