import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_segmented_control.freezed.dart';
part 'stac_app_segmented_control.g.dart';

@freezed
abstract class StacAppSegmentedControl with _$StacAppSegmentedControl {
  const factory StacAppSegmentedControl({
    @JsonKey(fromJson: mapListOrEmpty)
    required List<Map<String, Object?>> options,
    @JsonKey(fromJson: intOrZero) @Default(0) int selectedIndex,
  }) = _StacAppSegmentedControl;

  factory StacAppSegmentedControl.fromJson(Map<String, dynamic> json) =>
      _$StacAppSegmentedControlFromJson(json);
}

class StacAppSegmentedControlParser
    extends StacParser<StacAppSegmentedControl> {
  const StacAppSegmentedControlParser();

  @override
  String get type => 'appSegmentedControl';

  @override
  StacAppSegmentedControl getModel(Map<String, dynamic> json) =>
      .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppSegmentedControl model) {
    if (model.options.isEmpty) return const SizedBox.shrink();
    return _SegmentedControl(model: model);
  }
}

class _SegmentedControl extends StatefulWidget {
  const _SegmentedControl({required this.model});

  final StacAppSegmentedControl model;

  @override
  State<_SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<_SegmentedControl> {
  late int _index;

  @override
  void initState() {
    super.initState();
    final options = widget.model.options;
    _index = options.isEmpty
        ? 0
        : widget.model.selectedIndex.clamp(0, options.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.model.options;
    if (options.isEmpty) return const SizedBox.shrink();
    final child = options.elementAtOrNull(_index)?['child'];
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        AppSegmentedControl<int>(
          value: _index,
          options: [
            for (final (index, option) in options.indexed)
              AppSegmentedOption(
                value: index,
                label: stringOf(option, 'label'),
              ),
          ],
          onChanged: (index) {
            if (index != _index) setState(() => _index = index);
            actionCallback(
              context,
              options.elementAtOrNull(index)?['onSelected'],
            )?.call();
          },
        ),
        if (child is Map) ...[
          const SizedBox(height: 12),
          childWidget(context, child) ?? const SizedBox.shrink(),
        ],
      ],
    );
  }
}
