import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';
import 'package:rtu_mirea_app/data/repositories/onboarding_repository.dart';

class GetOnBoardingPages
    extends UseCase<List<OnBoardingPage>, GetOnBoardingPagesParams> {
  /// Repository for pages
  final OnBoardingRepository _repository = OnBoardingRepositoryImpl();

  @override
  Future<List<OnBoardingPage>> call(GetOnBoardingPagesParams params) async {
    List<OnBoardingPage> res = [];
    for (int i = 0; i < params.pagesCount; ++i) {
      res.add(_repository.getPage(i));
    }
    return res;
  }

  int getPagesCount() {
    return OnBoardingRepository.pagesNum;
  }

  /// First onboard page
  static const firstPage = const OnBoardingPage(
    pageNum: 0,
    textWidget: Text(
      'Добро пожаловать!',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30.0),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
    contentText: 'Это приложение было создано студентами для студентов',
    backgroundColor: Color.fromRGBO(30, 144, 255, 0.5),
    imageTopPadding: 18.0,
    image: const Image(
      image: AssetImage('assets/images/Saly-1.png'),
      height: 375.0,
      width: 375.0,
    ),
  );
}

class GetOnBoardingPagesParams extends Equatable {
  final int pagesCount;

  GetOnBoardingPagesParams({required this.pagesCount});

  @override
  List<Object?> get props => [pagesCount];
}
