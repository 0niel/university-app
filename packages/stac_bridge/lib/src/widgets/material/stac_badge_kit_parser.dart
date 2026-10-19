import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacBadgeKitParser extends StacParser<KitModel> {
  const StacBadgeKitParser();

  @override
  String get type => 'badge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final count = intOf(model, 'count');
    final label = labelOf(model['label']);
    final visible = boolOf(model, 'isLabelVisible', fallback: true);
    final Widget badge = count != null
        ? AppCountBadge(count, max: intOf(model, 'maxCount') ?? 999)
        : label.isNotEmpty
        ? AppBadge(label: label, tone: .exam)
        : AppDot(size: 8, color: colorOf(context, model, 'backgroundColor'));
    final child = childWidget(context, model['child']);
    if (child == null) return visible ? badge : const SizedBox.shrink();
    return Stack(
      clipBehavior: .none,
      children: [
        child,
        if (visible) Positioned(top: -4, right: -4, child: badge),
      ],
    );
  }
}
