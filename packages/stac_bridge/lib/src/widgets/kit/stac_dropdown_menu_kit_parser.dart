import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_select_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacDropdownMenuKitParser extends StacParser<KitModel> {
  const StacDropdownMenuKitParser();

  @override
  String get type => 'dropdownMenu';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      _KitDropdownMenu(model: model);
}

class _KitDropdownMenu extends StatefulWidget {
  const _KitDropdownMenu({required this.model});

  final KitModel model;

  @override
  State<_KitDropdownMenu> createState() => _KitDropdownMenuState();
}

class _KitDropdownMenuState extends State<_KitDropdownMenu> {
  String? _picked;

  @override
  void didUpdateWidget(covariant _KitDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (stateKeyOf(oldWidget.model) != stateKeyOf(widget.model) ||
        oldWidget.model['initialSelection'] !=
            widget.model['initialSelection']) {
      _picked = null;
    }
  }

  List<KitOption> _entriesOf(KitModel model) {
    final entries = optionsOf(model, 'dropdownMenuEntries');
    return entries.isNotEmpty ? entries : optionsOf(model, 'entries');
  }

  Future<void> _pick(List<KitOption> entries, String current) async {
    final model = widget.model;
    final chosen = await showAppSheet<String>(
      context,
      title: stringOrNullOf(model, 'sheetTitle'),
      child: AppListGroup(
        children: [
          for (final entry in entries)
            Builder(
              builder: (sheetContext) => AppListRow(
                title: entry.label,
                showChevron: false,
                trailing: entry.value == current
                    ? AppLineIconWidget(
                        .check,
                        size: 18,
                        color: sheetContext.colors.accent,
                      )
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(entry.value),
              ),
            ),
        ],
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() => _picked = chosen);
    writeStateValue(context, model, chosen);
    actionOf(context, model, const [
      'onSelected',
      'onChanged',
      'onChange',
    ])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final entries = _entriesOf(model);
    final current =
        _picked ?? stringStateOf(context, model, 'initialSelection');
    var label = '';
    for (final entry in entries) {
      if (entry.value == current) {
        label = entry.label;
        break;
      }
    }
    final labelText = labelOf(model['label']);
    final enabled = boolOf(model, 'enabled', fallback: true);
    final onTap = entries.isEmpty
        ? actionOf(context, model, const ['onTap'])
        : () => _pick(entries, current);
    return AppSelectField(
      value: current.isEmpty ? null : (label.isEmpty ? current : label),
      placeholder: stringOrNullOf(model, 'hintText'),
      label: labelText.isEmpty ? null : labelText,
      helperText:
          stringOrNullOf(model, 'errorText') ??
          stringOrNullOf(model, 'helperText'),
      enabled: enabled,
      onTap: enabled ? onTap : null,
    );
  }
}
