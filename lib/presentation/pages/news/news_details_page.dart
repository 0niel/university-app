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
              leading: IconButton(
                icon: SvgPicture.asset(
                  color: Colors.white,
                  'assets/icons/appbar_back.svg',
                  width: 14,
                  height: 14,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              expandedHeight: 340,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground, // zoom effect
                  StretchMode.fadeTitle, // fade effect
                ],
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: [
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
                    const _BottomGradientShadow(),
                    const _BottomRoundedContainer(),
                    _BottomPageIndicators(controller: _controller, count: 3)
                  ],
                ),
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
                      _NextButton(onPressed: () {}, isEvent: isEvent),
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

class _BottomPageIndicators extends StatelessWidget {
  const _BottomPageIndicators(
      {Key? key, required this.controller, required this.count})
      : super(key: key);

  final PageController controller;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: 43,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SmoothPageIndicator(
          controller: controller,
          count: count,
          effect: ScrollingDotsEffect(
            dotWidth: 7.0,
            dotHeight: 7.0,
            dotColor: Colors.white.withOpacity(0.6),
            activeDotColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _BottomRoundedContainer extends StatelessWidget {
  const _BottomRoundedContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -1,
      left: 0,
      right: 0,
      child: Container(
        height: 23,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.white,
            width: 0,
          ),
        ),
      ),
    );
  }
}

class _BottomGradientShadow extends StatelessWidget {
  const _BottomGradientShadow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({Key? key, required this.onPressed, required this.isEvent})
      : super(key: key);

  final VoidCallback onPressed;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    return NinjaButton(
      backgroundColor: Theme.of(context).colorScheme.background,
      splashColor: Colors.transparent,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NinjaText.bodySmall(
            isEvent ? "Следующее мероприятие" : "Следующая новость",
            fontWeight: 500,
          ),
          SvgPicture.asset(
            'assets/icons/arrow_right.svg',
          ),
        ],
      ),
    );
  }
}
