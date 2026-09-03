import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_validation_rules.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

TextInputType? keyboardTypeOf(String? name) => switch (name) {
  'email' || 'emailAddress' => TextInputType.emailAddress,
  'number' || 'numeric' => TextInputType.number,
  'phone' => TextInputType.phone,
  'url' => TextInputType.url,
  'multiline' => TextInputType.multiline,
  'text' => TextInputType.text,
  _ => null,
};

class StacAppInputFieldParser extends StacParser<KitModel> {
  const StacAppInputFieldParser();

  @override
  String get type => 'appInputField';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      KitInputField(model: model);
}

class KitInputField extends StatefulWidget {
  KitInputField({required this.model}) : super(key: _keyFor(model));

  final KitModel model;

  static Key? _keyFor(KitModel model) {
    final id = stringOf(model, 'id');
    final stateKey = stateKeyOf(model);
    if (id.isNotEmpty) return ValueKey('input:$id');
    return stateKey.isEmpty ? null : ValueKey('input:state:$stateKey');
  }

  @override
  State<KitInputField> createState() => _KitInputFieldState();
}

class _KitInputFieldState extends State<KitInputField> {
  final _controller = TextEditingController();
  StacFormScope? _scope;
  bool _initialized = false;

  String get _id => stringOf(widget.model, 'id');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = context.dependOnInheritedWidgetOfExactType<StacFormScope>();
    if (_initialized && identical(scope, _scope)) return;
    _initialized = true;
    _scope = scope;
    final fromState = stateValueOf(context, widget.model);
    _controller.text =
        scope?.formData[_id]?.toString() ??
        fromState?.toString() ??
        stringOf(widget.model, 'initialValue');
    if (_id.isNotEmpty) scope?.formData[_id] = _controller.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final model = widget.model;
    final text = value ?? '';
    final fallback = stringOf(
      model,
      'validationMessage',
      kitText(context, ru: 'Проверьте значение', en: 'Check this value'),
    );
    final length = text.characters.length;
    final min = intOf(model, 'minLength');
    final max = intOf(model, 'maxLength');
    if ((boolOf(model, 'required') && text.trim().isEmpty) ||
        (min != null && length < min) ||
        (max != null && length > max) ||
        (boolOf(model, 'email') && !isValidEmail(text))) {
      return fallback;
    }
    for (final rule in mapListOf(model, 'rules')) {
      final options = rule['options'];
      final passed = validateRule(
        stringOf(rule, 'rule'),
        text,
        options: options is Map<Object?, Object?>
            ? Map<String, Object?>.from(options)
            : null,
      );
      if (!passed) return stringOf(rule, 'message', fallback);
    }
    return null;
  }

  void _onChanged(String value) {
    if (_id.isNotEmpty) _scope?.formData[_id] = value;
    writeStateValue(context, widget.model, value);
    actionOf(context, widget.model, const ['onChanged', 'onChange'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final enabled = boolOf(model, 'enabled', fallback: true);
    final readOnly = boolOf(model, 'readOnly');
    final errorText = stringOrNullOf(model, 'errorText');
    final helperText = stringOrNullOf(model, 'helperText');
    final label = stringOrNullOf(model, 'label');
    final placeholder = stringOrNullOf(model, 'placeholder');
    final maxLength = intOf(model, 'maxLength');
    if (boolOf(model, 'multiline')) {
      return AppInputField.multiline(
        controller: _controller,
        label: label,
        placeholder: placeholder,
        helperText: helperText,
        errorText: errorText,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: boolOf(model, 'autofocus'),
        maxLines: intOf(model, 'maxLines') ?? 6,
        minLines: intOf(model, 'minLines') ?? 3,
        maxLength: maxLength,
        showCounter: boolOf(model, 'showCounter', fallback: true),
        validator: _validate,
        onChanged: _onChanged,
      );
    }
    final obscure = boolOf(model, 'obscureText');
    final maxLines = intOf(model, 'maxLines') ?? 1;
    return AppInputField(
      controller: _controller,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      success: boolOf(model, 'success'),
      enabled: enabled,
      readOnly: readOnly,
      autofocus: boolOf(model, 'autofocus'),
      obscureText: obscure,
      showPasswordToggle: obscure,
      leadingIcon: iconOf(model, 'leadingIcon'),
      maxLines: obscure ? 1 : maxLines.clamp(1, 20),
      maxLength: maxLength,
      showCounter: boolOf(model, 'showCounter'),
      keyboardType:
          keyboardTypeOf(stringOrNullOf(model, 'keyboardType')) ??
          (boolOf(model, 'email') ? TextInputType.emailAddress : null),
      validator: _validate,
      onChanged: _onChanged,
      onSubmitted: (_) =>
          actionOf(context, model, const ['onSubmitted', 'onSubmit'])?.call(),
    );
  }
}

class StacAppSearchFieldParser extends StacParser<KitModel> {
  const StacAppSearchFieldParser();

  @override
  String get type => 'appSearchField';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final stateKey = stateKeyOf(model);
    return _SearchField(
      key: stateKey.isEmpty ? null : ValueKey('search:$stateKey'),
      model: model,
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({required this.model, super.key});

  final KitModel model;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text:
          stateValueOf(context, widget.model)?.toString() ??
          stringOf(widget.model, 'initialValue'),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    writeStateValue(context, widget.model, value);
    actionOf(context, widget.model, const ['onChanged', 'onChange'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return AppSearchField(
      controller: _controller,
      hintText:
          stringOrNullOf(model, 'placeholder') ??
          stringOrNullOf(model, 'hintText'),
      autofocus: boolOf(model, 'autofocus'),
      onCanvas: boolOf(model, 'onCanvas'),
      trailingIcon: iconOf(model, 'trailingIcon'),
      onTrailingTap: actionOf(context, model, const ['onTrailingTap']),
      onChanged: _onChanged,
      onClear: () => _onChanged(''),
      onSubmitted: (_) =>
          actionOf(context, model, const ['onSubmitted', 'onSubmit'])?.call(),
    );
  }
}
