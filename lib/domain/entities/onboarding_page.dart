import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/pages/onboarding/onboarding_screen.dart';

/// Data class with info about onBoarding page
/// we see in [OnBoardingScreen]
class OnBoardingPage extends Equatable {
  final int pageNum;
  final Text textWidget;
  final String contentText;
  final Color backgroundColor;
  final double imageTopPadding;
  final Image image;

  const OnBoardingPage(
      {required this.pageNum,
      required this.textWidget,
      required this.contentText,
      required this.backgroundColor,
      required this.imageTopPadding,
      required this.image});

  @override
  List<Object?> get props => [
        pageNum,
        textWidget,
        contentText,
        backgroundColor,
        imageTopPadding,
        image
      ];
}
