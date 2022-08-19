import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/tag.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unicons/unicons.dart';

class NewsDetailsPage extends StatelessWidget {
  NewsDetailsPage({Key? key, required this.isEvent}) : super(key: key);

  final bool isEvent;

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 340,
              actionsIconTheme: const IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: [
                  // PageView with images
                  SizedBox(
                    width: double.infinity,
                    height: 340,
                    child: PageView(
                      controller: _controller,
                      children: [
                        Image.network(
                          'https://picsum.photos/375/340',
                          fit: BoxFit.cover,
                        ),
                        Image.network(
                          'https://picsum.photos/375/340',
                          fit: BoxFit.cover,
                        ),
                        Image.network(
                          'https://picsum.photos/375/340',
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),

                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 23,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 43),
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: 3,
                          effect: ScrollingDotsEffect(
                            dotWidth: 7.0,
                            dotHeight: 7.0,
                            dotColor: Colors.white.withOpacity(0.6),
                            activeDotColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const NinjaText.bodySmall(
                        "7 мая 2022",
                        color: NinjaConstant.grey400,
                      ),
                      const SizedBox(height: 22),
                      const NinjaText.h4(
                          "Эксперт РТУ МИРЭА разъяснил правила использования пластиковой посуды"),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        children: const [
                          Tag("#Студентам"),
                          Tag("#Праздники"),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const NinjaText.bodyMedium(
                          """Майские праздники — время пикников и шашлыков. С собой на природу очень удобно брать пластиковую посуду. 

Но насколько она безопасна? «При необходимости любую одноразовую посуду можно использовать повторно, не только пищевые контейнеры для хранения продуктов, но и любые тарелки, одноразовые стаканы. Никакого вреда они не приносят», — сказал кандидат химических наук, доцент кафедры неорганической химии в МИРЭА – Российского технологического университета Андрей Дорохов. Подробности — в материале."""),
                      const Spacer(),
                      const Divider(thickness: 1, height: 24),
                      NinjaButton(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const NinjaText.bodySmall(
                              "Следующая новость",
                              fontWeight: 500,
                            ),
                            SvgPicture.asset(
                              'assets/icons/arrow_right.svg',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
