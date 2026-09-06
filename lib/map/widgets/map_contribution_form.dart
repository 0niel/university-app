import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/widgets/map_community_sheet.dart';

class MapContributionForm extends StatefulWidget {
  const MapContributionForm({
    required this.repository,
    required this.campus,
    required this.onSubmitted,
    this.room,
    this.floorId,
    super.key,
  });

  final MapDataRepository repository;
  final CampusMapData campus;
  final MapPlaceData? room;
  final String? floorId;
  final VoidCallback onSubmitted;

  @override
  State<MapContributionForm> createState() => _MapContributionFormState();
}

class _MapContributionFormState extends State<MapContributionForm> {
  final _value = TextEditingController();
  final _reason = TextEditingController();
  final _source = TextEditingController();
  final _menu = <_MenuDraft>[];
  late String _field = widget.room == null ? 'report' : 'description';
  String _category = 'plan';
  String _accessibility = 'accessible';
  late DateTime _menuDate = _today();
  Map<String, Object?>? _preview;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _fillField();
    for (final item in widget.room?.menu ?? <MapMenuItem>[]) {
      _menu.add(
        _MenuDraft(
          name: item.name,
          price: item.price?.toString() ?? '',
          available: item.available,
        ),
      );
    }
    if (_menu.isEmpty) _menu.add(_MenuDraft());
  }

  @override
  void dispose() {
    _value.dispose();
    _reason.dispose();
    _source.dispose();
    for (final item in _menu) {
      item.dispose();
    }
    super.dispose();
  }

  void _fillField() {
    final room = widget.room;
    _value.text = switch (_field) {
      'label' => room?.label ?? '',
      'description' => room?.description ?? '',
      'equipment' => room?.equipment.join(', ') ?? '',
      'opening_hours' => room?.openingHours ?? '',
      'capacity' => room?.capacity?.toString() ?? '',
      _ => '',
    };
  }

  void _selectField(String field) {
    setState(() {
      _field = field;
      _preview = null;
      _error = null;
      _fillField();
    });
  }

  Map<String, Object?> _buildPatch() {
    final value = _value.text.trim();
    final reason = _reason.text.trim();
    if (reason.length < 10) {
      throw const FormatException('Объясните изменение: не менее 10 символов.');
    }
    final sourceText = _source.text.trim();
    if (sourceText.isNotEmpty) {
      final source = Uri.tryParse(sourceText);
      if (source == null ||
          source.scheme != 'https' ||
          source.host.isEmpty ||
          source.userInfo.isNotEmpty) {
        throw const FormatException(
          'Укажите полную ссылку, начинающуюся с https://.',
        );
      }
    }
    final patch = <String, Object?>{};
    if (_field == 'report') {
      if (value.length < 10) {
        throw const FormatException(
          'Опишите место и проблему: не менее 10 символов.',
        );
      }
      patch.addAll({'category': _category, 'details': value});
    } else if (_field == 'menu') {
      final entries = <Map<String, Object?>>[];
      for (final item in _menu) {
        final name = item.name.text.trim();
        final priceText = item.price.text.trim();
        if (name.isEmpty && priceText.isEmpty) continue;
        if (name.isEmpty) {
          throw const FormatException('Укажите название каждого блюда.');
        }
        final price = priceText.isEmpty
            ? null
            : double.tryParse(priceText.replaceAll(',', '.'));
        if (priceText.isNotEmpty &&
            (price == null || !price.isFinite || price < 0)) {
          throw const FormatException(
            'Цена должна быть числом от 0. Например, 150 или 99,50.',
          );
        }
        entries.add({
          'name': name,
          'price': ?price,
          'currency': 'RUB',
          'available': item.available,
        });
      }
      if (entries.isEmpty) {
        throw const FormatException('Добавьте хотя бы одно блюдо.');
      }
      if (_menuDate.isBefore(_today())) {
        throw const FormatException(
          'Для нового меню выберите сегодняшнюю или будущую дату.',
        );
      }
      patch.addAll({
        'menu': entries,
        'menu_date': DateFormat('yyyy-MM-dd').format(_menuDate),
        'expires_at': DateTime.utc(
          _menuDate.year,
          _menuDate.month,
          _menuDate.day + 1,
        ).subtract(const Duration(hours: 3)).toIso8601String(),
      });
    } else if (_field == 'capacity') {
      final capacity = int.tryParse(value);
      if (capacity == null || capacity < 1 || capacity > 10000) {
        throw const FormatException('Укажите число мест от 1 до 10 000.');
      }
      patch['capacity'] = capacity;
    } else if (_field == 'accessibility') {
      patch['accessibility'] = _accessibility;
    } else if (_field == 'equipment') {
      if (value.isEmpty) {
        throw const FormatException('Перечислите оснащение через запятую.');
      }
      patch['equipment'] = value
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList();
    } else {
      if (value.isEmpty) {
        throw const FormatException('Заполните новое значение.');
      }
      patch[_field] = value;
    }
    if (sourceText.isNotEmpty && _field == 'report') {
      patch['source_url'] = sourceText;
    }
    return patch;
  }

  void _prepare() {
    FocusScope.of(context).unfocus();
    try {
      final patch = _buildPatch();
      setState(() {
        _preview = patch;
        _error = null;
      });
    } on FormatException catch (error) {
      setState(() => _error = error.message);
    }
  }

  Future<void> _submit() async {
    final patch = _preview;
    if (_busy || patch == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.submitProposal(
        campusId: widget.campus.campus.id,
        baseRevision: widget.campus.revision,
        entityType: _field == 'report' ? 'report' : 'room',
        entityId: _field == 'report'
            ? widget.room?.id ?? widget.floorId ?? widget.campus.campus.id
            : widget.room!.id,
        patch: patch,
        reason:
            _reason.text.trim() +
            (_field != 'report' && _source.text.trim().isNotEmpty
                ? '\nИсточник: ${_source.text.trim()}'
                : ''),
      );
      if (mounted) {
        setState(() => _busy = false);
        widget.onSubmitted();
      }
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = mapContributionError(error);
      });
    }
  }

  Future<void> _selectMenuDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _menuDate,
      firstDate: _today(),
      lastDate: _today().add(const Duration(days: 30)),
      helpText: 'На какой день это меню?',
    );
    if (date != null && mounted) setState(() => _menuDate = date);
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (!widget.repository.isAuthenticated) ...[
        const AppBanner(
          message:
              'Войдите в аккаунт, чтобы отправлять исправления '
              'и видеть результат проверки.',
          tone: AppBannerTone.warn,
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
      if (_preview != null) ...[
        MapPatchPreview(patch: _preview!),
        const SizedBox(height: AppSpacing.lg),
        Text(_reason.text.trim(), style: AppText.body),
        if (_source.text.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SelectableText('Источник: ${_source.text.trim()}'),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: 'Отправить на проверку',
          expanded: true,
          loading: _busy,
          onPressed: _busy || !widget.repository.isAuthenticated
              ? null
              : _submit,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton.secondary(
          label: 'Вернуться к правке',
          expanded: true,
          onPressed: _busy ? null : () => setState(() => _preview = null),
        ),
      ] else ...[
        Text('Что нужно изменить?', style: AppText.label),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (widget.room != null)
              for (final field in const [
                'label',
                'description',
                'equipment',
                'capacity',
                'accessibility',
                'opening_hours',
                'menu',
              ])
                AppChip(
                  label: mapPatchFieldLabel(field),
                  selected: _field == field,
                  onTap: () => _selectField(field),
                ),
            AppChip(
              label: 'План или маршрут',
              selected: _field == 'report',
              onTap: () => _selectField('report'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (_field == 'report') ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final entry in const {
                'plan': 'Ошибка плана',
                'route': 'Проход / маршрут',
                'accessibility': 'Доступность',
                'other': 'Другое',
              }.entries)
                AppChip(
                  label: entry.value,
                  selected: _category == entry.key,
                  onTap: () => setState(() => _category = entry.key),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const AppBanner(
            message:
                'Укажите этаж, ближайшую аудиторию '
                'и что не совпадает с реальностью. '
                'Проверяющий сможет уточнить план.',
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (_field == 'menu')
          _buildMenu()
        else if (_field == 'accessibility')
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppChip(
                label: 'Доступно',
                selected: _accessibility == 'accessible',
                onTap: () => setState(() => _accessibility = 'accessible'),
              ),
              AppChip(
                label: 'Есть ограничения',
                selected: _accessibility == 'not_accessible',
                onTap: () => setState(() => _accessibility = 'not_accessible'),
              ),
            ],
          )
        else if (_field == 'capacity' || _field == 'label')
          AppInputField(
            controller: _value,
            label: mapPatchFieldLabel(_field),
            keyboardType: _field == 'capacity'
                ? TextInputType.number
                : TextInputType.text,
            maxLength: _field == 'capacity' ? 5 : 160,
          )
        else
          AppInputField.multiline(
            controller: _value,
            label: _field == 'report'
                ? 'Где и что нужно проверить'
                : mapPatchFieldLabel(_field),
            helperText: _field == 'equipment'
                ? 'Например: проектор, розетки, компьютеры'
                : _field == 'opening_hours'
                ? 'Например: пн–пт 09:00–18:00, перерыв 13:00–14:00'
                : null,
            maxLength: _field == 'report' ? 3000 : 4000,
          ),
        const SizedBox(height: AppSpacing.lg),
        AppInputField.multiline(
          controller: _reason,
          label: 'Почему данные нужно изменить',
          helperText: 'Когда проверили лично или на какой источник опираетесь.',
          maxLength: 2000,
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppInputField(
          controller: _source,
          label: 'Ссылка на источник, если есть',
          placeholder: 'https://',
          keyboardType: TextInputType.url,
          maxLength: 900,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: 'Проверить предложение',
          expanded: true,
          onPressed: _prepare,
        ),
      ],
      if (_error != null) ...[
        const SizedBox(height: AppSpacing.lg),
        AppBanner(message: _error!, tone: AppBannerTone.warn),
      ],
    ],
  );

  Widget _buildMenu() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppButton.secondary(
        label: 'Меню на ${DateFormat('dd.MM.yyyy').format(_menuDate)}',
        onPressed: _selectMenuDate,
      ),
      const SizedBox(height: AppSpacing.md),
      const Text(
        'Цены в рублях. Меню действует до конца выбранного дня '
        'по московскому времени.',
      ),
      const SizedBox(height: AppSpacing.md),
      for (final item in _menu)
        Padding(
          key: ObjectKey(item),
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInputField(
                  controller: item.name,
                  label: 'Название блюда',
                  maxLength: 160,
                ),
                const SizedBox(height: AppSpacing.md),
                AppInputField(
                  controller: item.price,
                  label: 'Цена, ₽',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  maxLength: 12,
                ),
                AppSwitch(
                  label: 'Есть в наличии',
                  value: item.available,
                  onChanged: (available) =>
                      setState(() => item.available = available),
                ),
                if (_menu.length > 1)
                  AppButton.text(
                    label: 'Убрать блюдо',
                    onPressed: () => setState(() {
                      _menu.remove(item);
                      item.dispose();
                    }),
                  ),
              ],
            ),
          ),
        ),
      if (_menu.length < 50)
        AppButton.secondary(
          label: 'Добавить блюдо',
          expanded: true,
          onPressed: () => setState(() => _menu.add(_MenuDraft())),
        ),
    ],
  );
}

class _MenuDraft {
  _MenuDraft({String name = '', String price = '', this.available = true})
    : name = TextEditingController(text: name),
      price = TextEditingController(text: price);

  final TextEditingController name;
  final TextEditingController price;
  bool available;

  void dispose() {
    name.dispose();
    price.dispose();
  }
}

DateTime _today() {
  final now = DateTime.now().toUtc().add(const Duration(hours: 3));
  return DateTime(now.year, now.month, now.day);
}
