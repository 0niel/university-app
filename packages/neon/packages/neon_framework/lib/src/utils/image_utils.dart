import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

/// Utilities for working with images.
class ImageUtils {
  const ImageUtils._();

  /// Rewrites percent dimensions in SVGs to be absolute.
  ///
  /// This is required because the `flutter_svg` package can not handle percent dimensions.
  static String rewriteSvgDimensions(String data) {
    final document = XmlDocument.parse(data);

    final viewBoxAttribute =
        (document.xpath('/svg/@viewBox').firstOrNull ?? document.xpath('/svg/@viewbox').firstOrNull)! as XmlAttribute;
    final viewBoxValues = viewBoxAttribute.value.split(' ');
    final viewBox = <String, String>{
      'width': viewBoxValues[2],
      'height': viewBoxValues[3],
    };

    for (final dimension in ['width', 'height']) {
      final rootDimensionAttribute = document.xpath('/svg/@$dimension').firstOrNull as XmlAttribute?;
      final rootDimension = double.parse(
        rootDimensionAttribute != null ? rootDimensionAttribute.value : viewBox[dimension]!,
      );

      for (final element in document.descendantElements) {
        final elementDimensionString = element.getAttribute(dimension);
        if (elementDimensionString != null && elementDimensionString.endsWith('%')) {
          final elementDimension = double.parse(elementDimensionString.substring(0, elementDimensionString.length - 1));
          element.setAttribute(dimension, (rootDimension * (elementDimension / 100)).toString());
        }
      }
    }

    return document.toXmlString();
  }
}
