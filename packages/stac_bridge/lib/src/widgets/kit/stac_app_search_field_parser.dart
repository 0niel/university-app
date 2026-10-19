import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

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
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final value = stateValueOf(context, widget.model)?.toString();
    if (value != null && value != _controller.text) {
      _controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
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
      isOnCanvas: boolOf(model, 'onCanvas'),
      trailingIcon: iconOf(model, 'trailingIcon'),
      onTrailingTap: actionOf(context, model, const ['onTrailingTap']),
      onChanged: _onChanged,
      onClear: () => _onChanged(''),
      onSubmitted: (_) =>
          actionOf(context, model, const ['onSubmitted', 'onSubmit'])?.call(),
    );
  }
}
