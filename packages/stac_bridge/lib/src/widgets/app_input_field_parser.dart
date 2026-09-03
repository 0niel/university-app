import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAppInputFieldParser extends StacParser<Map<String, dynamic>> {
  const StacAppInputFieldParser();

  @override
  String get type => 'appInputField';

  @override
  Map<String, dynamic> getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, Map<String, dynamic> model) {
    final id = stringOf(model, 'id');
    return _InputField(
      key: id.isEmpty ? null : ValueKey(id),
      model: model,
    );
  }
}

class _InputField extends StatefulWidget {
  const _InputField({required this.model, super.key});

  final Map<String, dynamic> model;

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  final _controller = TextEditingController();
  StacFormScope? _scope;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = context.dependOnInheritedWidgetOfExactType<StacFormScope>();
    if (_initialized && identical(scope, _scope)) return;
    _initialized = true;
    _scope = scope;
    final id = stringOf(widget.model, 'id');
    _controller.text =
        scope?.formData[id]?.toString() ??
        stringOf(widget.model, 'initialValue');
    if (id.isNotEmpty) scope?.formData[id] = _controller.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final model = widget.model;
    final text = value ?? '';
    final min = model['minLength'];
    final max = model['maxLength'];
    final invalid =
        (boolOf(model, 'required') && text.trim().isEmpty) ||
        (min is num && text.characters.length < min) ||
        (max is num && text.characters.length > max) ||
        (boolOf(model, 'email') &&
            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text));
    if (!invalid) return null;
    return stringOf(
      model,
      'validationMessage',
      Localizations.localeOf(context).languageCode == 'ru'
          ? 'Проверьте значение'
          : 'Check this value',
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final maxLines = model['maxLines'];
    final obscure = boolOf(model, 'obscureText');
    return AppInputField(
      controller: _controller,
      label: model['label'] as String?,
      placeholder: model['placeholder'] as String?,
      helperText: model['helperText'] as String?,
      enabled: boolOf(model, 'enabled', fallback: true),
      readOnly: boolOf(model, 'readOnly'),
      obscureText: obscure,
      showPasswordToggle: obscure,
      maxLines: obscure
          ? 1
          : maxLines is num
          ? maxLines.toInt().clamp(1, 20)
          : 1,
      keyboardType: boolOf(model, 'email') ? TextInputType.emailAddress : null,
      validator: _validate,
      onChanged: (value) {
        final id = stringOf(model, 'id');
        if (id.isNotEmpty) _scope?.formData[id] = value;
      },
    );
  }
}
