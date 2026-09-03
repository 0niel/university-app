import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

BoxFit boxFitOf(String? name) => switch (name) {
  'contain' => BoxFit.contain,
  'fill' => BoxFit.fill,
  'fitWidth' => BoxFit.fitWidth,
  'fitHeight' => BoxFit.fitHeight,
  'none' => BoxFit.none,
  'scaleDown' => BoxFit.scaleDown,
  _ => BoxFit.cover,
};

class KitNetworkImage extends StatelessWidget {
  const KitNetworkImage({
    required this.src,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = AppRadius.field,
    this.aspectRatio,
    this.semanticLabel,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final double? aspectRatio;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    Widget placeholder() => ImagePlaceholder(
      width: width,
      height: height ?? (aspectRatio == null ? 160 : null),
      borderRadius: borderRadius,
    );
    final uri = Uri.tryParse(src);
    if (src.isEmpty || uri == null || !uri.hasScheme) {
      return _framed(placeholder());
    }
    final image = Image.network(
      src,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      errorBuilder: (_, _, _) => placeholder(),
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : placeholder(),
    );
    return _framed(ClipRRect(borderRadius: borderRadius, child: image));
  }

  Widget _framed(Widget child) {
    final ratio = aspectRatio;
    if (ratio == null) return child;
    return AspectRatio(aspectRatio: ratio, child: child);
  }
}

class StacAppImageParser extends StacParser<KitModel> {
  const StacAppImageParser();

  @override
  String get type => 'appImage';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitNetworkImage(
    src: stringOf(model, 'src', stringOf(model, 'url')),
    width: doubleOf(model, 'width'),
    height: doubleOf(model, 'height'),
    fit: boxFitOf(stringOrNullOf(model, 'fit')),
    radius: doubleOr(model, 'radius', AppRadius.field),
    aspectRatio: doubleOf(model, 'aspectRatio'),
    semanticLabel: stringOrNullOf(model, 'semanticLabel'),
  );
}
