import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/data/datasources/onboarding_data.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  @override
  OnBoardingPage getPage(int index) {
    return OnBoardingPage(
      pageNum: index,
      textWidget: OnBoardingData.textWidgets[index],
      contentText: OnBoardingData.contentTexts[index],
      backgroundColor: OnBoardingData.backgroundColors[index],
      imageTopPadding: OnBoardingData.getImageTopPadding(index),
      image: OnBoardingData.containersImages[index],
    );
  }

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
