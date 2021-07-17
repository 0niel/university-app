import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/data/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';

/// [OnBoardingScreen] state management
/// Depends on page number
class OnBoardingCubit extends Cubit<OnBoardingPage> {
  OnBoardingCubit() : super(OnBoardingRepositoryImpl.firstPage);

  /// Repository for pages
  final OnBoardingRepository _repository = OnBoardingRepositoryImpl();

  /// Get another page when swipe
  void swipe(int pageNum) => emit(_repository.getPage(pageNum));
}
