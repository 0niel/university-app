import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rtu_mirea_app/data/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/presentation/bloc/onboarding_cubit.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/home/home_navigator_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  static const int initialPageNum = 0;

  final introdate = GetStorage();
  final int _numPages = 5;

  PageController _pageController = PageController(initialPage: initialPageNum);

  List<Widget> _buildPageIndicator(int _currentPage) {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    // индикатор номера страницы
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 3.75),
      height: isActive ? 15.0 : 11.0,
      width: isActive ? 15.0 : 11.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : LightThemeColors.grey100,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        boxShadow: <BoxShadow>[
          isActive
              ? BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0,
                )
              : BoxShadow(color: Colors.transparent),
        ],
      ),
    );
  }

  Widget _buildNextButton(bool isLastPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 3.75),
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeNavigatorScreen()),
            );
          } else {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          padding: isLastPage
              ? EdgeInsets.symmetric(vertical: 20.0, horizontal: 55.0)
              : EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          child: isLastPage
              ? Text(
                  "Начать!",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 24.0),
                )
              : Icon(Icons.arrow_forward_ios, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPrimary: Colors.black.withOpacity(0.25),
          shadowColor: Colors.black,
          primary: Colors.white,
          elevation: 4.0,
        ),
      ),
    );
  }

  List<Widget> _buildPageView() {
    OnBoardingRepository repository = OnBoardingRepositoryImpl();
    return List.generate(_numPages, (index) {
      OnBoardingPage pageInfo = repository.getPage(index);
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
                    padding: EdgeInsets.only(top: pageInfo.imageTopPadding),
                    child: pageInfo.image),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pageInfo.textWidget,
                  SizedBox(height: 8.0),
                  Text(
                    pageInfo.contentText,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _onBoardingScreen() {
    return BlocBuilder<OnBoardingCubit, OnBoardingPage>(
        builder: (context, pageInfo) {
      // _currentPage = pageNum;
      bool isLastPage = pageInfo.pageNum == _numPages - 1;
      return Scaffold(
        //Все 3 экрана + скип + выхода из приветствия
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            color: pageInfo.backgroundColor,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        //Индикатор страницы
                        context.read<OnBoardingCubit>().swipe(page);
                      },
                      children: _buildPageView(),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 35.0, left: 20.0, right: 20.0),
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
                                            HomeNavigatorScreen()),
                                  );
                                },
                                child: Text(
                                  "Пропустить",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFE5E5E5),
                                      fontSize: 12.0),
                                ),
                              ),
                        Row(
                          children: [..._buildPageIndicator(pageInfo.pageNum)],
                        ),
                        _buildNextButton(isLastPage),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    // builder: (context, pageNum){
  }

  // BlocBuilder<OnBoardingPageCounter,int>(
  // builder: (context, pageNum){
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingCubit(initialPageNum),
      child: _onBoardingScreen(),
    );
  }
}
