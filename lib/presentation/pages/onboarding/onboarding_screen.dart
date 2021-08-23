import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/onboarding_cubit/onboarding_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/home/home_navigator_screen.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

import 'widgets/indicator.dart';
import 'widgets/next_button.dart';

/// OnBoarding screen, that greets new users
class OnBoardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final int _numPages = 4;

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
    Image(
      image: AssetImage('assets/images/Saly-5.png'),
      height: 315.0,
      width: 315.0,
    ),
  ];

  static const List titlesTexts = [
    'Добро пожаловать!',
    'Смотри расписание!',
    'Будь в курсе, не надевая штаны!',
    // 'Ставь цели!',
    'Коммуницируй!',
  ];

  /// Bottom text strings
  static const List contentTexts = [
    'Это приложение было создано студентами для студентов',
    'Как же легко оказывается можно смотреть расписание, а главное быстро',
    'Иногда так лень заходить на сайт и искать нужную тебе информацию, мы это исправили',
    // 'Как же много дедлайнов!? Создавать дедлайны теперь как никогда просто и удобно',
    'Слово сложное, но все легко. Общайся и делись материалами с другими группами мгновенно',
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

  /// Build indicators depending on current opened page
  List<Widget> _buildPageIndicators(int _currentPage) {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage
          ? IndicatorPageView(isActive: true)
          : IndicatorPageView(isActive: false));
    }
    return list;
  }

  /// Build block with image and texts
  List<Widget> _buildPageView() {
    return List.generate(_numPages, (index) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                    padding: EdgeInsets.only(top: getImageTopPadding(index)),
                    child: containersImages[index]),
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
                    style: DarkTextTheme.h4,
                  ),
                  SizedBox(height: 8.0),
                  Text(contentTexts[index], style: DarkTextTheme.bodyL),
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
    OnboardingCubit cubit = BlocProvider.of<OnboardingCubit>(context);
    return Scaffold(
      backgroundColor: DarkThemeColors.background01,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: PageView(
                allowImplicitScrolling: true,
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) => cubit.swipe(page),
                children: _buildPageView(),
              ),
            ),
            BlocBuilder<OnboardingCubit, int>(builder: (context, state) {
              bool isLastPage = cubit.state == _numPages - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: 35.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isLastPage
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeNavigatorScreen(isFirstRun: true)),
                              );
                            },
                            child: Text(
                              "Пропустить",
                              style: DarkTextTheme.buttonS,
                            ),
                          ),
                    Row(
                      children: _buildPageIndicators(state),
                    ),
                    NextPageViewButton(
                      isLastPage: isLastPage,
                      onClick: () => _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
