import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/data/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/onboarding/get_page.dart';

/// [OnBoardingScreen] state management
/// Depends on page number
class OnBoardingCubit extends Cubit<OnBoardingPage> {
  final GetOnBoardingPages getPages = GetOnBoardingPages();
  final List<OnBoardingPage> _pages = [];

  OnBoardingCubit() : super(GetOnBoardingPages.firstPage) {
    _fillPages();
  }

  Future<void> _fillPages() async {
    var params = GetOnBoardingPagesParams(pagesCount: getPages.getPagesCount());
    _pages.addAll(await getPages.call(params));
  }

  /// Get another page when swipe
  void swipe(int pageNum) => emit(_pages[pageNum]);
}
