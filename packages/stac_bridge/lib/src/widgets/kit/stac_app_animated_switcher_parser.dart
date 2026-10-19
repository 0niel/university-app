import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_motion_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

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
      transitionBuilder: (transitionChild, animation) {
        final transition = stringOf(model, 'transition', 'fade');
        final fade = FadeTransition(opacity: animation, child: transitionChild);
        final Animatable<double> scaleTween = Tween(begin: .96, end: 1);
        return switch (transition) {
          'fadeScale' => ScaleTransition(
            scale: scaleTween.animate(animation),
            child: fade,
          ),
          'slideUp' || 'slideDown' => SlideTransition(
            position: Tween(
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
