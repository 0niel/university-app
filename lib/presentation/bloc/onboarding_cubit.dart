import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/data/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';

/// Менеджмент состояния экрана [OnBoardingScreen]
/// в заивисмости от номера просматриваемой страницы
class OnBoardingCubit extends Cubit<OnBoardingPage> {
  OnBoardingCubit([int initialPageNum = 0,]) : super(OnBoardingRepositoryImpl.firstPage);

  final OnBoardingRepository _repository = OnBoardingRepositoryImpl();

  void swipe(int pageNum) => emit(_repository.getPage(pageNum));
}
