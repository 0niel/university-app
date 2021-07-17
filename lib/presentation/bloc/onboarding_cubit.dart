import 'package:flutter_bloc/flutter_bloc.dart';

/// Менеджмент состояния экрана [OnBoardingScreen]
/// в заивисмости от номера просматриваемой страницы
class OnBoardingPageCounter extends Cubit<int>{
  OnBoardingPageCounter([int initialPageNum=0]) : super(initialPageNum);

  void swipe(int pageNum) => emit(pageNum);
}