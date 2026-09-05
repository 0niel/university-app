import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

double _bounded(double? value, double fallback, double min, double max) =>
    value == null || !value.isFinite ? fallback : value.clamp(min, max);

Duration kitMotionDuration(BuildContext context, KitModel model) {
  if (boolOf(model, 'reduceMotion')) return Duration.zero;
  return NinjaMotion.of(
    context,
    Duration(
      milliseconds: _bounded(
        doubleOf(model, 'duration') ?? doubleOf(model, 'durationMs'),
        220,
        0,
        2000,
      ).round(),
    ),
  );
}

Curve kitMotionCurve(KitModel model) => switch (stringOf(model, 'curve')) {
  'linear' => Curves.linear,
  'easeIn' => Curves.easeIn,
  'easeOut' => Curves.easeOut,
  'easeInOut' => Curves.easeInOut,
  'easeInCubic' => Curves.easeInCubic,
  'easeInOutCubic' => Curves.easeInOutCubic,
  'fastOutSlowIn' => Curves.fastOutSlowIn,
  _ => Curves.easeOutCubic,
};

class StacAppAnimatedSwitcherParser extends StacParser<KitModel> {
  const StacAppAnimatedSwitcherParser();

  @override
  String get type => 'appAnimatedSwitcher';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final child = childWidget(context, model['child']);
    final identity = model.containsKey('value')
        ? model['value']
        : const DeepCollectionEquality().hash(model['child']);
    return AnimatedSwitcher(
      duration: kitMotionDuration(context, model),
      switchInCurve: kitMotionCurve(model),
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [
          for (final outgoing in previous)
            ExcludeSemantics(child: IgnorePointer(child: outgoing)),
          ?current,
        ],
      ),
      transitionBuilder: (child, animation) {
        final transition = stringOf(model, 'transition', 'fade');
        final fade = FadeTransition(opacity: animation, child: child);
        return switch (transition) {
          'fadeScale' => ScaleTransition(
            scale: Tween<double>(begin: .96, end: 1).animate(animation),
            child: fade,
          ),
          'slideUp' || 'slideDown' => SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, transition == 'slideUp' ? .08 : -.08),
              end: Offset.zero,
            ).animate(animation),
            child: fade,
          ),
          _ => fade,
        };
      },
      child: child == null
          ? null
          : KeyedSubtree(key: ValueKey(identity), child: child),
    );
  }
}

class StacAppAnimatedContainerParser extends StacParser<KitModel> {
  const StacAppAnimatedContainerParser();

  @override
  String get type => 'appAnimatedContainer';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    double? dimension(String key) {
      final value = doubleOf(model, key);
      return value == null || !value.isFinite ? null : value.clamp(0, 10000);
    }

    EdgeInsets? padding(String key) {
      if (!model.containsKey(key)) return null;
      final value = insetsOf(model, key, 0);
      return EdgeInsets.fromLTRB(
        _bounded(value.left, 0, 0, 1000),
        _bounded(value.top, 0, 0, 1000),
        _bounded(value.right, 0, 0, 1000),
        _bounded(value.bottom, 0, 0, 1000),
      );
    }

    return AnimatedContainer(
      duration: kitMotionDuration(context, model),
      curve: kitMotionCurve(model),
      width: dimension('width'),
      height: dimension('height'),
      padding: padding('padding'),
      margin: padding('margin'),
      alignment: switch (stringOf(model, 'alignment')) {
        'topLeft' => Alignment.topLeft,
        'topCenter' => Alignment.topCenter,
        'topRight' => Alignment.topRight,
        'centerLeft' => Alignment.centerLeft,
        'center' => Alignment.center,
        'centerRight' => Alignment.centerRight,
        'bottomLeft' => Alignment.bottomLeft,
        'bottomCenter' => Alignment.bottomCenter,
        'bottomRight' => Alignment.bottomRight,
        _ => null,
      },
      decoration: BoxDecoration(
        color: colorOf(context, model, 'color'),
        borderRadius: BorderRadius.circular(
          _bounded(doubleOf(model, 'radius'), 0, 0, 1000),
        ),
        border: model.containsKey('borderColor')
            ? Border.all(
                color:
                    colorOf(context, model, 'borderColor') ??
                    context.colors.line,
                width: _bounded(doubleOf(model, 'borderWidth'), 1, 0, 20),
              )
            : null,
      ),
      onEnd: actionOf(context, model, const ['onEnd']),
      child: childWidget(context, model['child']),
    );
  }
}

class StacAppAnimatedOpacityParser extends StacParser<KitModel> {
  const StacAppAnimatedOpacityParser();

  @override
  String get type => 'appAnimatedOpacity';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final opacity = _bounded(doubleOf(model, 'opacity'), 1, 0, 1);
    return IgnorePointer(
      ignoring: opacity == 0 || !boolOf(model, 'enabled', fallback: true),
      child: ExcludeSemantics(
        excluding: opacity == 0,
        child: AnimatedOpacity(
          duration: kitMotionDuration(context, model),
          curve: kitMotionCurve(model),
          opacity: opacity,
          onEnd: actionOf(context, model, const ['onEnd']),
          child: childWidget(context, model['child']),
        ),
      ),
    );
  }
}
