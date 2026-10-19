import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';

class StacInsetScrollViewParser extends StacParser<Map<String, dynamic>> {
  const StacInsetScrollViewParser();

  @override
  String get type => 'appInsetScrollView';

  @override
  Map<String, dynamic> getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, Map<String, dynamic> model) {
    final scrollType = model['scrollViewType'];
    if (scrollType != 'listView' &&
        scrollType != 'gridView' &&
        scrollType != 'singleChildScrollView') {
      return const SizedBox.shrink();
    }
    final screen = {...model, 'type': scrollType}..remove('scrollViewType');
    if (model['scrollDirection'] == 'horizontal') {
      return SafeArea(
        top: false,
        left: false,
        right: false,
        child: Builder(
          builder: (context) =>
              Stac.fromJson(screen, context) ?? const SizedBox.shrink(),
        ),
      );
    }
    final safePadding = MediaQuery.paddingOf(context);
    final padding = model['padding'] == null
        ? scrollType == 'singleChildScrollView'
              ? EdgeInsets.zero
              : EdgeInsets.only(top: safePadding.top)
        : StacEdgeInsets.fromJson(model['padding']).parse;
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Builder(
        builder: (context) =>
            Stac.fromJson({
              ...screen,
              'padding': {
                'left': padding.left,
                'top': padding.top,
                'right': padding.right,
                'bottom': padding.bottom + safePadding.bottom,
              },
            }, context) ??
            const SizedBox.shrink(),
      ),
    );
  }
}
