part of 'in_memory_news_data_source.dart';

/// Источники новостей
const _mireaNewsCategory = Category(
  id: 'mirea_news',
  name: 'Новости РТУ МИРЭА',
);
const _rtuMireaTelegramCategory = Category(
  id: 'rtu_mirea_telegram',
  name: 'RTU MIREA Official Telegram',
);

/// Новости с сайта МИРЭА (mirea.ru/news)
final mireaNewsItems = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: 'd1a2b3c4-d5e6-7890-abcd-ef1234560001',
      categoryId: _mireaNewsCategory.id,
      author: 'RTU МИРЭА',
      publishedAt: DateTime(2025, 6, 10),
      imageUrl:
          'https://www.mirea.ru/upload/news/2025/06/10/iri_top100.png', // при наличии изображения
      title:
          'Проект Института радиоэлектроники и информатики вошёл в топ-100 лучших проектов участников шестого потока «Академии инноваторов»',
      description:
          'Проект Института радиоэлектроники и информатики вошёл в топ-100 лучших проектов участников шестого потока «Академии инноваторов».',
    ),
    content: [
      ArticleIntroductionBlock(
        categoryId: _mireaNewsCategory.id,
        author: 'RTU МИРЭА',
        publishedAt: DateTime(2025, 6, 10),
        title:
            'Проект Института радиоэлектроники и информатики вошёл в топ-100 лучших проектов участников шестого потока «Академии инноваторов»',
        imageUrl: 'https://www.mirea.ru/upload/news/2025/06/10/iri_top100.png',
      ),
    ],
    contentPreview: [],
    url: Uri.parse(
      'https://www.mirea.ru/news/proekt-instituta-radioelektroniki-i-informatiki-voshyel-v-top-100-proektov-academii-innovatorov/',
    ),
  ),
  NewsItem(
    post: PostSmallBlock(
      id: 'd1a2b3c4-d5e6-7890-abcd-ef1234560002',
      categoryId: _mireaNewsCategory.id,
      author: 'RTU МИРЭА',
      publishedAt: DateTime(2025, 6, 6),
      imageUrl: 'https://www.mirea.ru/upload/news/2025/06/06/metal2025.png',
      title:
          'РТУ МИРЭА вошёл в число участников выставки «Металлообработка-2025»',
      description:
          'РТУ МИРЭА в очередной раз принял участие в 25-й юбилейной международной выставке «Металлообработка-2025».',
    ),
    content: [
      ArticleIntroductionBlock(
        categoryId: _mireaNewsCategory.id,
        author: 'RTU МИРЭА',
        publishedAt: DateTime(2025, 6, 6),
        title:
            'РТУ МИРЭА вошёл в число участников выставки «Металлообработка-2025»',
        imageUrl: 'https://www.mirea.ru/upload/news/2025/06/06/metal2025.png',
      ),
    ],
    contentPreview: [],
    url: Uri.parse(
      'https://www.mirea.ru/news/rtu-mirea-voshyel-v-chislo-uchastnikov-vystavki-metalloobrabotka-2025/',
    ),
  ),
  NewsItem(
    post: PostSmallBlock(
      id: 'd1a2b3c4-d5e6-7890-abcd-ef1234560003',
      categoryId: _mireaNewsCategory.id,
      author: 'RTU МИРЭА',
      publishedAt: DateTime(2025, 6, 4),
      imageUrl: 'https://www.mirea.ru/upload/news/2025/06/04/itex2025.png',
      title:
          'Делегация РТУ МИРЭА приняла участие в международной выставке ITEX-2025',
      description:
          'С 29 по 31 мая 2025 года в Куала-Лумпуре прошла международная выставка ITEX-2025.',
    ),
    content: [
      ArticleIntroductionBlock(
        categoryId: _mireaNewsCategory.id,
        author: 'RTU МИРЭА',
        publishedAt: DateTime(2025, 6, 4),
        title:
            'Делегация РТУ МИРЭА приняла участие в международной выставке ITEX-2025',
        imageUrl: 'https://www.mirea.ru/upload/news/2025/06/04/itex2025.png',
      ),
    ],
    contentPreview: [],
    url: Uri.parse(
      'https://www.mirea.ru/news/delegatsiya-rtu-mirea-prinyala-uchastie-v-mezhdunarodnoy-vystavke-itex-2025/',
    ),
  ),
];

/// Новости из официального Telegram-канала РТУ МИРЭА (@rtumirea_official)
final rtuMireaTelegramItems = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: 'd1a2b3c4-d5e6-7890-abcd-ef1234560004',
      categoryId: _rtuMireaTelegramCategory.id,
      author: 'RTU MIREA Official',
      publishedAt: DateTime(2025, 6, 7),
      imageUrl: 'https://static.t.me/rtumirea_official/10031/tax-a-land.png',
      title:
          'ТеДо (компания «Технологии Доверия») запускает новый поток Tax-a-Land',
      description:
          'Это уникальная образовательная программа по налогообложению и праву.\n'
          'Как будут проходить занятия:\n'
          '— 30 июня – 24 июля\n'
          '— понедельник, среда, четверг, 13:00–15:00 (мск)\n'
          '— бесплатно, в онлайн-формате',
    ),
    content: [
      ArticleIntroductionBlock(
        categoryId: _rtuMireaTelegramCategory.id,
        author: 'RTU MIREA Official',
        publishedAt: DateTime(2025, 6, 7),
        title:
            'ТеДо (компания «Технологии Доверия») запускает новый поток Tax-a-Land',
        imageUrl: 'https://static.t.me/rtumirea_official/10031/tax-a-land.png',
      ),
    ],
    contentPreview: [],
    url: Uri.parse('https://t.me/rtumirea_official/10031'),
  ),
];

/// Сборка всех новостей в общую ленту
List<NewsItem> get _newsItems => [
      ...mireaNewsItems,
      ...rtuMireaTelegramItems,
    ];

/// Категории новостей
const _categories = <Category>[
  _mireaNewsCategory,
  _rtuMireaTelegramCategory,
];

/// Популярные статьи (для getPopularArticles)
final popularArticles = <NewsItem>[
  ...mireaNewsItems.take(2), // Берем первые 2 статьи как популярные
  ...rtuMireaTelegramItems.take(1), // И одну из Telegram
];

/// Релевантные статьи (для getRelevantArticles)
final relevantArticles = <NewsItem>[
  ...mireaNewsItems, // Все статьи могут быть релевантными
  ...rtuMireaTelegramItems,
];

/// Популярные темы
const popularTopics = <String>[
  'Академия инноваторов',
  'Металлообработка',
  'ITEX',
  'RTU MIREA',
  'Инновации',
  'Выставки',
  'Международное сотрудничество',
];

/// Релевантные темы (для поиска)
const relevantTopics = <String>[
  'Проекты РТУ МИРЭА',
  'Научные достижения',
  'Студенческие инициативы',
  'Технологии',
  'Образование',
  'Исследования',
  'Конференции',
  'Партнерство',
];

final _newsFeedData = <String, Feed>{
  _mireaNewsCategory.id: Feed(
      blocks: mireaNewsItems.map((n) => n.post).toList(),
      totalBlocks: mireaNewsItems.length),
  _rtuMireaTelegramCategory.id: Feed(
      blocks: rtuMireaTelegramItems.map((n) => n.post).toList(),
      totalBlocks: rtuMireaTelegramItems.length),
};

extension on List<NewsBlock> {
  Feed toFeed() => Feed(blocks: this, totalBlocks: length);
  Article toArticle({required String title, required Uri url}) {
    return Article(
      title: title,
      blocks: this,
      totalBlocks: length,
      url: url,
    );
  }
}
