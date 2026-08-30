import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_list_row.freezed.dart';
part 'stac_app_list_row.g.dart';

@freezed
abstract class StacAppListRow with _$StacAppListRow {
  const factory StacAppListRow({
    @JsonKey(fromJson: stringOrEmpty) required String title,
    @JsonKey(fromJson: stringOrNull) String? subtitle,
    @JsonKey(fromJson: stringOrNull) String? emoji,
    @JsonKey(fromJson: stringOrNull) String? emojiColor,
    @JsonKey(fromJson: boolOrFalse) @Default(false) bool isFirst,
    @JsonKey(fromJson: boolOrFalse) @Default(false) bool dense,
    Object? trailing,
    @JsonKey(name: 'onTap') Object? actionJson,
  }) = _StacAppListRow;

  factory StacAppListRow.fromJson(Map<String, dynamic> json) =>
      _$StacAppListRowFromJson(json);
}

class StacAppListRowParser extends StacParser<StacAppListRow> {
  const StacAppListRowParser();

  @override
  String get type => 'appListRow';

  @override
  StacAppListRow getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppListRow model) {
    return AppListRow(
      title: model.title,
      subtitle: model.subtitle,
      isFirst: model.isFirst,
      dense: model.dense,
      leading: model.emoji == null
          ? null
          : AppIconAvatar(
              emoji: model.emoji,
              color:
                  parseHexColor(model.emojiColor) ??
                  Theme.of(context).colors.primary,
            ),
      trailing: childWidget(context, model.trailing),
      onTap: actionCallback(context, model.actionJson),
    );
  }
}
