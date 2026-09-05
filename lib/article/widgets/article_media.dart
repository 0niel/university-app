import 'package:flutter_html/flutter_html.dart';
import 'package:news_blocks/news_blocks.dart';

Uri? articleLinkUri(String? value, {Uri? sourceUri}) {
  final raw = value?.trim();
  if (raw == null || raw.isEmpty) return null;
  final parsed = Uri.tryParse(raw);
  if (parsed == null) return null;
  final uri = parsed.hasScheme ? parsed : sourceUri?.resolveUri(parsed);
  if (uri == null) return null;
  return switch (uri.scheme.toLowerCase()) {
    'https' || 'http' when uri.host.isNotEmpty => uri,
    'mailto' || 'tel' when uri.path.isNotEmpty => uri,
    _ => null,
  };
}

String? articleImageUrl(String? value, {Uri? sourceUri}) {
  final uri = articleLinkUri(value, sourceUri: sourceUri);
  return uri != null && {'http', 'https'}.contains(uri.scheme)
      ? uri.toString()
      : null;
}

String? articleLightboxImageUrl(
  String? href, {
  Iterable<String> classes = const [],
  Uri? sourceUri,
}) {
  final url = articleImageUrl(href, sourceUri: sourceUri);
  if (url == null) return null;
  final path = Uri.parse(url).path;
  return classes.contains('lightbox') ||
          RegExp(
            r'\.(jpe?g|png|webp|gif|avif|heic|heif|bmp|tiff?)$',
            caseSensitive: false,
          ).hasMatch(path)
      ? url
      : null;
}

List<String> articleHtmlImages(String content, {Uri? sourceUri}) {
  final images = <String>[];
  for (final element in HtmlParser.parseHTML(content).querySelectorAll('img')) {
    var anchor = element.parent;
    while (anchor != null && anchor.localName != 'a') {
      anchor = anchor.parent;
    }
    final url =
        articleLightboxImageUrl(
          anchor?.attributes['href'],
          classes: anchor?.classes ?? const [],
          sourceUri: sourceUri,
        ) ??
        articleImageUrl(
          element.attributes['src'] ?? element.attributes['data-src'],
          sourceUri: sourceUri,
        );
    if (url != null) images.add(url);
  }
  return images;
}

List<String> articleGallery({
  required String? cover,
  required List<NewsBlock> blocks,
  Uri? sourceUri,
}) {
  final urls = <String>{};
  void add(String? value) {
    final url = articleImageUrl(value, sourceUri: sourceUri);
    if (url != null) urls.add(url);
  }

  add(cover);
  for (final block in blocks) {
    switch (block) {
      case ImageBlock(:final imageUrl):
        add(imageUrl);
      case SlideBlock(:final imageUrl):
        add(imageUrl);
      case SlideshowBlock(:final slides):
        for (final slide in slides) {
          add(slide.imageUrl);
        }
      case HtmlBlock(:final content):
        urls.addAll(articleHtmlImages(content, sourceUri: sourceUri));
      default:
        break;
    }
  }
  return urls.toList(growable: false);
}
