import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rtu_mirea_app/constants.dart';
import 'package:rtu_mirea_app/screens/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introdate = GetStorage();

  final int _numPages = 3;
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    //индикатор номера страницы
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : LightThemeColors.grey200,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Все 3 экрана + скип + выхода из приветствия
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                    // Основной цвет экранов в градиенте
                    0.1,
                    0.4,
                    0.7,
                  ],
                      colors: [
                    Theme.of(context).primaryColorDark,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorLight,
                  ])),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              },
                              child: Text(
                                'Пропустить',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ))), //Пропуск обучения
                      Expanded(
                        child: PageView(
                          physics: ClampingScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            //Индикатор страницы
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: <Widget>[
                            //Одинаковые слои, меняются картинки/текст
                            Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                        child: Image(
                                      image: AssetImage(
                                        'assets/images/Book1.png',
                                      ),
                                      height: 300.0,
                                      width: 300.0,
                                    )),
                                    SizedBox(
                                        height: 30.0,
                                        child: Center(
                                          child: Text(
                                            'Расписание',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: 25.0),
                                          ),
                                        )),
                                    SizedBox(height: 15.0),
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                            'Здесь вы можете увидеть актуальное расписание для своей группы',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                            )))
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                        child: Image(
                                      image: AssetImage(
                                        'assets/images/TeachSchedule.png',
                                      ),
                                      height: 300.0,
                                      width: 300.0,
                                    )),
                                    SizedBox(
                                        height: 38.0,
                                        child: Center(
                                          child: Text(
                                            'Поиск преподавателей',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25.0),
                                          ),
                                        )),
                                    SizedBox(height: 15.0),
                                    Text(
                                        'Расписание преподователей для поиска в университете',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ))
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: Image(
                                      image: AssetImage(
                                        'assets/images/Doge.png',
                                      ),
                                      height: 300.0,
                                      width: 300.0,
                                    )),
                                    SizedBox(
                                        height: 30.0,
                                        child: Center(
                                          child: Text(
                                            'Карта вуза',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25.0),
                                          ),
                                        )),
                                    SizedBox(height: 15.0),
                                    Text('Ну тут и так все понятно',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                        ))
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                      _currentPage != _numPages - 1
                          ? Container(
                              child: Align(
                              alignment: FractionalOffset.bottomRight,
                              child: TextButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.ease);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Далее',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0),
                                      ),
                                      SizedBox(height: 10.0, width: 10.0),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 30.0,
                                      )
                                    ],
                                  )),
                            ))
                          : Text('')
                    ],
                  )))),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Theme.of(context).primaryColorLight,
              child: GestureDetector(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Начать',
                      style: TextStyle(
                        color: LightThemeColors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                  introdate.write("displayed", true);
                },
              ),
            )
          : Text(''),
    );
  }
}
