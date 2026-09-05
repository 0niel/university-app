import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_parser.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAppImagePickerParser extends StacParser<KitModel> {
  const StacAppImagePickerParser();

  @override
  String get type => 'appImagePicker';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitImagePicker(
    key: ValueKey('imagePicker:${stringOf(model, 'id', stateKeyOf(model))}'),
    model: model,
  );
}

class KitImagePicker extends StatefulWidget {
  const KitImagePicker({required this.model, super.key});

  final KitModel model;

  @override
  State<KitImagePicker> createState() => _KitImagePickerState();
}

class _KitImagePickerState extends State<KitImagePicker> {
  MiniAppStateStore? _store;
  String _localValue = '';
  bool _removed = false;
  String? _error;
  bool? _pickingFromCamera;

  String get _stateKey => stateKeyOf(widget.model);
  String get _statusKey => stringOf(
    widget.model,
    'statusKey',
    _stateKey.isEmpty ? '' : '${_stateKey}Status',
  );
  String get _errorKey => stringOf(
    widget.model,
    'errorKey',
    _stateKey.isEmpty ? '' : '${_stateKey}Error',
  );
  String get _removedKey => stringOf(
    widget.model,
    'removedKey',
    _stateKey.isEmpty ? '' : '${_stateKey}Removed',
  );
  String get _value => _store == null || _stateKey.isEmpty
      ? _localValue
      : _store?.get(_stateKey)?.toString() ?? '';
  String get _preview => _value.isNotEmpty
      ? _value
      : _removed
      ? ''
      : stringOf(widget.model, 'initialUrl');
  bool get _busy =>
      _pickingFromCamera != null || boolOf(widget.model, 'loading');
  bool get _enabled =>
      !_busy && boolOf(widget.model, 'enabled', fallback: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final store = context
        .dependOnInheritedWidgetOfExactType<MiniAppStateScope>()
        ?.notifier;
    if (identical(_store, store)) return;
    _store?.removeListener(_stateChanged);
    _store = store;
    _pickingFromCamera = null;
    _localValue = '';
    _removed = _store?.get(_removedKey) == true;
    _error = _store?.get(_errorKey)?.toString();
    _store?.addListener(_stateChanged);
  }

  void _stateChanged() {
    if (!mounted) return;
    setState(() {
      _removed = _store?.get(_removedKey) == true;
      _error = _store?.get(_errorKey)?.toString();
    });
  }

  @override
  void dispose() {
    _store?.removeListener(_stateChanged);
    super.dispose();
  }

  void _writeStatus(
    String status, {
    String? value,
    bool? removed,
    String? error,
  }) {
    if (value != null) _localValue = value;
    if (removed != null) _removed = removed;
    _error = error;
    _store?.setAll({
      if (_stateKey.isNotEmpty && value != null) _stateKey: value,
      if (_removedKey.isNotEmpty && removed != null) _removedKey: removed,
      if (_statusKey.isNotEmpty) _statusKey: status,
      if (_errorKey.isNotEmpty) _errorKey: error,
    });
  }

  Future<void> _followUp(
    List<String> names, {
    MiniAppSession? session,
  }) async {
    for (final name in names) {
      final action = widget.model[name];
      if (action is Map<Object?, Object?>) {
        await MiniAppSessionStack.runWith(
          session ?? MiniAppSessionStack.current,
          () => runMiniAppAction(context, action),
        );
        return;
      }
    }
  }

  Future<void> _pick({required bool fromCamera}) async {
    if (!_enabled) return;
    final session = MiniAppSessionStack.current;
    final host = session?.host;
    final store = _store;
    final stateKey = _stateKey;
    final failureText = stringOf(
      widget.model,
      'errorMessage',
      kitText(
        context,
        ru: 'Не удалось загрузить фото. Попробуйте ещё раз.',
        en: 'Could not upload the photo. Try again.',
      ),
    );
    setState(() {
      _pickingFromCamera = fromCamera;
      _writeStatus('picking');
    });
    try {
      if (host == null) throw StateError('Image picker is unavailable');
      final result = await host.pickImage(fromCamera: fromCamera);
      if (!mounted || !identical(store, _store) || stateKey != _stateKey) {
        return;
      }
      if (result == null || result.trim().isEmpty) {
        setState(() {
          _pickingFromCamera = null;
          _writeStatus(
            _removed
                ? 'removed'
                : _value.isEmpty
                ? 'idle'
                : 'ready',
          );
        });
        await _followUp(const ['onCancel'], session: session);
        return;
      }
      final uri = Uri.tryParse(result);
      if (uri == null ||
          !const ['https', 'http'].contains(uri.scheme) ||
          uri.host.isEmpty) {
        throw const FormatException('Invalid image URL');
      }
      setState(() {
        _writeStatus('ready', value: result, removed: false);
        _pickingFromCamera = null;
      });
      await _followUp(const [
        'onChanged',
        'onChange',
        'onResult',
      ], session: session);
    } on Object {
      if (!mounted || !identical(store, _store) || stateKey != _stateKey) {
        return;
      }
      setState(() {
        _pickingFromCamera = null;
        _writeStatus('error', error: failureText);
      });
      try {
        await _followUp(const ['onError'], session: session);
      } on Object {
        return;
      }
    }
  }

  Future<void> _remove() async {
    if (!_enabled) return;
    final removeInitial = boolOf(widget.model, 'allowRemoveInitial');
    setState(() {
      _writeStatus(
        removeInitial ? 'removed' : 'idle',
        value: '',
        removed: removeInitial,
      );
    });
    try {
      await _followUp(const ['onRemoved', 'onChanged', 'onChange']);
    } on Object {
      if (!mounted) return;
      setState(() {
        _writeStatus(
          'error',
          error: kitText(
            context,
            ru: 'Не удалось завершить действие. Попробуйте ещё раз.',
            en: 'Could not complete the action. Try again.',
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final colors = context.colors;
    final preview = _preview;
    final hasPhoto = preview.isNotEmpty;
    final camera = boolOf(
      model,
      'allowCamera',
      fallback: boolOf(model, 'camera', fallback: true),
    );
    final gallery = boolOf(
      model,
      'allowGallery',
      fallback: boolOf(model, 'gallery', fallback: true),
    );
    final label = stringOf(
      model,
      'label',
      kitText(context, ru: 'Фото', en: 'Photo'),
    );
    final selectedLabel = stringOf(
      model,
      'selectedLabel',
      kitText(context, ru: 'Фото выбрано', en: 'Photo selected'),
    );
    final statusText = _busy
        ? stringOf(
            model,
            'loadingLabel',
            kitText(context, ru: 'Загружаем фото…', en: 'Uploading photo…'),
          )
        : hasPhoto
        ? _value.isNotEmpty
              ? selectedLabel
              : stringOf(
                  model,
                  'existingLabel',
                  kitText(context, ru: 'Текущее фото', en: 'Current photo'),
                )
        : stringOf(
            model,
            'emptyLabel',
            kitText(context, ru: 'Добавьте фото', en: 'Add a photo'),
          );
    final helper = stringOf(model, 'helperText');
    final error = _error ?? stringOrNullOf(model, 'errorText');
    final requestedHeight = doubleOr(model, 'height', 240);
    final height = requestedHeight.isFinite
        ? requestedHeight.clamp(120.0, 560.0)
        : 240.0;
    final duration = NinjaMotion.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppText.heading.copyWith(color: colors.ink)),
        const SizedBox(height: 12),
        Semantics(
          image: hasPhoto,
          label: '$label: $statusText',
          child: ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: SizedBox(
                height: height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedSwitcher(
                      duration: duration,
                      child: hasPhoto
                          ? KitNetworkImage(
                              key: ValueKey(preview),
                              src: preview,
                              width: double.infinity,
                              height: height,
                              radius: 0,
                              fit: boxFitOf(stringOrNullOf(model, 'fit')),
                            )
                          : ColoredBox(
                              key: const ValueKey('empty'),
                              color: colors.surface2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: colors.tint,
                                    shape: BoxShape.circle,
                                  ),
                                  child: AppLineIconWidget(
                                    AppLineIcon.image,
                                    size: 36,
                                    color: colors.accent,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    if (_busy)
                      ColoredBox(
                        color: colors.scrim.withValues(alpha: .42),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: AppButtonSpinner(
                              color: colors.accent,
                              trackColor: colors.line,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Semantics(
          liveRegion: true,
          child: Text(
            statusText,
            style: AppText.bodyStrong.copyWith(
              color: hasPhoto && !_busy ? colors.success : colors.ink,
            ),
          ),
        ),
        if (helper.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(helper, style: AppText.subtext.copyWith(color: colors.muted)),
        ],
        if (error != null && error.isNotEmpty) ...[
          const SizedBox(height: 8),
          Semantics(
            liveRegion: true,
            child: Text(
              error,
              style: AppText.subtext.copyWith(color: colors.danger),
            ),
          ),
        ],
        if (camera || gallery) ...[
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 300 ||
                  MediaQuery.textScalerOf(context).scale(14) > 20;
              final buttons = <Widget>[
                if (gallery)
                  AppButton.tonal(
                    label: stringOf(
                      model,
                      'galleryLabel',
                      kitText(context, ru: 'Из галереи', en: 'Gallery'),
                    ),
                    icon: const AppLineIconWidget(AppLineIcon.image),
                    expanded: true,
                    loading: _pickingFromCamera == false,
                    onPressed: _enabled
                        ? () => unawaited(_pick(fromCamera: false))
                        : null,
                  ),
                if (camera)
                  AppButton.secondary(
                    label: stringOf(
                      model,
                      'cameraLabel',
                      kitText(context, ru: 'Снять фото', en: 'Camera'),
                    ),
                    icon: const AppLineIconWidget(AppLineIcon.camera),
                    expanded: true,
                    loading: _pickingFromCamera == true,
                    onPressed: _enabled
                        ? () => unawaited(_pick(fromCamera: true))
                        : null,
                  ),
              ];
              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: buttons,
                );
              }
              return Row(
                spacing: 8,
                children: [
                  for (final button in buttons) Expanded(child: button),
                ],
              );
            },
          ),
        ],
        if (hasPhoto &&
            (_value.isNotEmpty || boolOf(model, 'allowRemoveInitial')) &&
            boolOf(model, 'allowRemove', fallback: true)) ...[
          const SizedBox(height: 8),
          AppButton.text(
            label: stringOf(
              model,
              'removeLabel',
              kitText(context, ru: 'Убрать фото', en: 'Remove photo'),
            ),
            icon: const AppLineIconWidget(AppLineIcon.close),
            expanded: true,
            foregroundColor: colors.danger,
            onPressed: _enabled ? () => unawaited(_remove()) : null,
          ),
        ],
      ],
    );
  }
}
