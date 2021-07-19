import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/data/datasources/onboarding_data.dart';
import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/domain/repositories/onboarding_repository.dart';

/// Repository to get onboarding page info
class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingDataSource dataSource;

  OnBoardingRepositoryImpl({required this.dataSource});

  @override
  OnBoardingPage getPage(int index) {
    return OnBoardingPage(
      pageNum: index,
      textWidget: dataSource.getMainText(index),
      contentText: dataSource.getBottomText(index),
      backgroundColor: dataSource.getbackgroundColor(index),
      imageTopPadding: dataSource.getImageTopPadding(index),
      image: dataSource.getMainImage(index),
    );
  }

  @override
  int getPagesNum() {
    return dataSource.getPagesNum();
  }
}
