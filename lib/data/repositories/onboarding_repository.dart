import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/data/datasources/onboarding_data.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';

/// Repository to get onboarding page info
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
}
