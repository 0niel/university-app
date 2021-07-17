import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
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

  int _currentPage = initialPageNum;
  PageController _pageController = PageController(initialPage: initialPageNum);

  List<Widget> _buildPageIndicator() {
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
          if (_currentPage == _numPages - 1) {
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

  final List<Color> _containersColors = [
    Color.fromRGBO(30, 144, 255, 0.5),
    Color.fromRGBO(255, 155, 112, 0.5),
    Color.fromRGBO(255, 165, 2, 0.5),
    Color.fromRGBO(55, 66, 250, 0.5),
    Color.fromRGBO(255, 127, 80, 1.0),
  ];

  final List<Image> _containersImages = [
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
    Image(
      image: AssetImage('assets/images/Saly-4.png'),
      height: 375.0,
      width: 315.0,
    ),
    Image(
      image: AssetImage('assets/images/Saly-5.png'),
      height: 315.0,
      width: 315.0,
    ),
  ];

  final List _containersText = [
    {
      'title_text_widget': Text(
        'Добро пожаловать!',
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30.0),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      'content': 'Это приложение было создано студентами для студентов'
    },
    {
      'title_text_widget': Text(
        'Смотри расписание!',
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFF28080),
            fontSize: 30.0),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      'content':
          'Как же легко оказывается можно смотреть расписание, а главное быстро'
    },
    {
      'title_text_widget': Text(
        'Будь вкурсе не надевая штаны!',
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFE26B96),
            fontSize: 30.0),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      'content':
          'Иногда так лень заходить на сайт и искать нужную тебе информацию, мы это исправил'
    },
    {
      'title_text_widget': Text(
        'Ставь цели!',
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFB059),
            fontSize: 30.0),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      'content':
          'Как же много дедлайнов!? Создавать дедлайны теперь как никогда просто и удобно'
    },
    {
      'title_text_widget': Text(
        'Коммуницируй!',
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFF4356FF),
            fontSize: 30.0),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      'content':
          'Слово сложное, но все легко. Общайся и делись материалами с другими группами мгновенно'
    },
  ];

  double _getImageTopPadding(int page) {
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
                    padding: EdgeInsets.only(top: _getImageTopPadding(index)),
                    child: _containersImages[index]),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _containersText[index]['title_text_widget'],
                  SizedBox(height: 8.0),
                  Text(
                    _containersText[index]['content'],
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
    return BlocBuilder<OnBoardingPageCounter, int>(builder: (context, pageNum) {
      _currentPage = pageNum;
      return Scaffold(
        //Все 3 экрана + скип + выхода из приветствия
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            color: _containersColors[_currentPage],
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
                        context.read<OnBoardingPageCounter>().swipe(page);
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
                        _currentPage == _numPages - 1
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
                          children: [..._buildPageIndicator()],
                        ),
                        _buildNextButton(_currentPage == _numPages - 1),
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
      create: (_) => OnBoardingPageCounter(initialPageNum),
      child: _onBoardingScreen(),
    );
  }
}
