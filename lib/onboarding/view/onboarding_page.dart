import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/onboarding/widgets/widgets.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

/// OnBoarding screen that greets new users
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final int _numPages = 3;

  /// Main images
  static const List<Image> containersImages = [
    Image(
      image: AssetImage('assets/images/Saly-1.png'),
      height: 375.0,
      width: 375.0,
    ),
    Image(
      image: AssetImage('assets/images/Saly-2.png'),
      height: 324.0,
      width: 328.0,
    ),
    Image(
      image: AssetImage('assets/images/Saly-3.png'),
      height: 315.0,
      width: 315.0,
    ),
    // Image(
    //   image: AssetImage('assets/images/Saly-4.png'),
    //   height: 375.0,
    //   width: 315.0,
    // ),
    // Image(
    //   image: AssetImage('assets/images/Saly-5.png'),
    //   height: 315.0,
    //   width: 315.0,
    // ),
  ];

  static const List titlesTexts = [
    'Добро пожаловать!',
    'Смотри расписание!',
    'Будь в курсе в любой момент!',
    // 'Ставь цели!',
    //'Коммуницируй!',
  ];

  /// Bottom text strings
  static const List contentTexts = [
    'Это приложение было создано студентами для студентов',
    'Как же легко, оказывается, можно смотреть расписание, а главное – быстро',
    'Иногда так лень заходить на сайт и искать нужную тебе информацию, мы это исправили',
    // 'Как же много дедлайнов!? Создавать дедлайны теперь как никогда просто и удобно',
    //'Слово сложное, но на деле всё легко. Общайся и делись материалами с другими группами мгновенно',
  ];

  /// Top padding for every image
  double getImageTopPadding(int page) {
    switch (page) {
      case 0:
        return 18.0;
      case 1:
        return 70.0;
      case 2:
        return 73.0;
      case 3:
        return 30.0;
      case 4:
        return 91.0;
      default:
        return 0.0;
    }
  }

  /// Page controller, that will execute Cubit method
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  /// Build block with image and texts
  List<Widget> _buildPageView() {
    return List.generate(_numPages, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child:
                    Padding(padding: EdgeInsets.only(top: getImageTopPadding(index)), child: containersImages[index]),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titlesTexts[index],
                    style: AppTextStyle.h4,
                  ),
                  const SizedBox(height: 8.0),
                  Text(contentTexts[index], style: AppTextStyle.bodyL),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<_PageIndicatorsState> pageStateKey = GlobalKey();

    final Widget pageIndicator = PageIndicators(
      key: pageStateKey,
      onClick: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
      dotsNum: _numPages,
    );

    return Scaffold(
      backgroundColor: AppTheme.colorsOf(context).background01,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: PageView(
                allowImplicitScrolling: true,
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  _currentPage = page;
                  pageStateKey.currentState!.updateWith(_currentPage);
                },
                children: _buildPageView(),
              ),
            ),
            pageIndicator,
          ],
        ),
      ),
    );
  }
}

class PageIndicators extends StatefulWidget {
  const PageIndicators({
    Key? key,
    required this.onClick,
    required this.dotsNum,
  }) : super(key: key);

  final VoidCallback onClick;
  final int dotsNum;

  @override
  State<PageIndicators> createState() => _PageIndicatorsState();
}

class _PageIndicatorsState extends State<PageIndicators> {
  /// Build indicators depending on current opened page
  List<Widget> _buildPageIndicators(int currentPage) {
    List<Widget> list = [];
    for (int i = 0; i < widget.dotsNum; i++) {
      list.add(i == currentPage ? const PageViewIndicator(isActive: true) : const PageViewIndicator(isActive: false));
    }
    return list;
  }

  int _currentPage = 0;

  void updateWith(int value) {
    setState(() {
      _currentPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.dotsNum - 1 == _currentPage
              ? Container()
              : TextButton(
                  onPressed: () {
                    context.read<HomeCubit>().closeOnboarding();
                    context.go('/schedule');
                  },
                  child: Text(
                    "Пропустить",
                    style: AppTextStyle.buttonS.copyWith(
                      color: AppTheme.colorsOf(context).active,
                    ),
                  ),
                ),
          Row(
            children: _buildPageIndicators(_currentPage),
          ),
          NextButton(
            isLastPage: widget.dotsNum - 1 == _currentPage,
            onClick: widget.onClick,
          ),
        ],
      ),
    );
  }
}
