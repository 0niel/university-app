import 'package:stac_bridge/src/widgets/parse_utils.dart';

export 'stac_app_select_field_parser.dart';
export 'stac_app_stepper_parser.dart';

typedef KitOption = ({String value, String label});

List<KitOption> optionsOf(KitModel model, String key) {
  final raw = model[key];
  if (raw is! List<Object?>) return const [];
  return [
    for (final item in raw)
      if (item is Map<Object?, Object?>)
        (
          value: item['value']?.toString() ?? '',
          label: item['label']?.toString() ?? item['value']?.toString() ?? '',
        )
      else if (item != null)
        (value: item.toString(), label: item.toString()),
  ];
}
