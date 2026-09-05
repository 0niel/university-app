import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/widgets/article_content_model.dart';
import 'package:rtu_mirea_app/article/widgets/article_media.dart';

void main() {
  final source = Uri.parse('https://mirea.example/news/article');

  test('resolves relative links and retains fragments, mail and telephone', () {
    expect(
      articleLinkUri('../other?q=1#section', sourceUri: source),
      Uri.parse('https://mirea.example/other?q=1#section'),
    );
    expect(
      articleLinkUri('//cdn.example/image.png', sourceUri: source),
      Uri.parse('https://cdn.example/image.png'),
    );
    expect(
      articleLinkUri('#section', sourceUri: source),
      Uri.parse('https://mirea.example/news/article#section'),
    );
    expect(
      articleLinkUri('mailto:help@example.com'),
      Uri.parse('mailto:help@example.com'),
    );
    expect(articleLinkUri('tel:+74951234567'), Uri.parse('tel:+74951234567'));
    expect(articleLinkUri('/relative-without-source'), isNull);
    for (final value in [
      'javascript:alert(1)',
      'data:text/html,test',
      'file:///tmp/a',
      'https://',
    ]) {
      expect(articleLinkUri(value, sourceUri: source), isNull);
    }
  });

  test('gallery includes HTML and slide images without duplicates', () {
    final model = ArticleContentModel.fromBlocks(const [
      SlideshowIntroductionBlock(title: 'Gallery', coverImageUrl: '/cover.png'),
      HtmlBlock(
        content:
            '<img src="/cover.png"><img src="../photo.png?a=1&amp;b=2"><img src="javascript:alert(1)">',
      ),
      SlideshowBlock(
        title: 'Slides',
        slides: [
          SlideBlock(
            caption: 'Caption',
            description: '',
            photoCredit: '',
            imageUrl: '/slide.png',
          ),
        ],
      ),
    ]);
    expect(model.title, 'Gallery');
    expect(model.body.whereType<SlideshowBlock>(), hasLength(1));
    expect(
      articleGallery(
        cover: model.imageUrl,
        blocks: model.body,
        sourceUri: source,
      ),
      [
        'https://mirea.example/cover.png',
        'https://mirea.example/photo.png?a=1&b=2',
        'https://mirea.example/slide.png',
      ],
    );
  });
}
