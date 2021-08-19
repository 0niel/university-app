import 'package:flutter/material.dart';
import 'package:news_page/presentation/colors.dart';

class DarkTextTheme {
  static const headline = TextStyle(
    color: Colors.white,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const inter = TextStyle(
    color: Colors.white,
    fontFamily: 'Inter',
    letterSpacing: 0,
  );

  static final h0 = headline.copyWith(fontSize: 60);
  static final h1 = headline.copyWith(fontSize: 48);
  static final h2 = headline.copyWith(fontSize: 40);
  static final h3 = headline.copyWith(fontSize: 36);
  static final h4 = headline.copyWith(fontSize: 32);
  static final h5 = headline.copyWith(fontSize: 24);
  static final h6 = headline.copyWith(fontSize: 20);
  static final title = headline.copyWith(fontSize: 18);

  static final titleM =
      inter.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final titleS =
      inter.copyWith(fontSize: 14, fontWeight: FontWeight.w600);
  static final buttonL =
      inter.copyWith(fontSize: 16, fontWeight: FontWeight.w700);
  static final buttonS =
      inter.copyWith(fontSize: 14, fontWeight: FontWeight.w700);
  static final tab = inter.copyWith(fontSize: 14, fontWeight: FontWeight.w600);
  static final bodyL =
      inter.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final body = inter.copyWith(fontSize: 13, fontWeight: FontWeight.w500);
  static final bodyBold =
      inter.copyWith(fontSize: 14, fontWeight: FontWeight.w700);
  static final bodyRegular = inter.copyWith(fontSize: 13);
  static final captionL =
      inter.copyWith(fontSize: 12, fontWeight: FontWeight.w500);
  static final captionS =
      inter.copyWith(fontSize: 11, fontWeight: FontWeight.w500);
  static final chip = inter.copyWith(
      fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.50);
}

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: DarkThemeColors.background01,
  backgroundColor: DarkThemeColors.background01,
  appBarTheme: AppBarTheme(
    titleSpacing: 24,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    titleTextStyle: DarkTextTheme.title,
  ),
  bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
        backgroundColor: DarkThemeColors.background03,
        selectedItemColor: DarkThemeColors.active,
        unselectedItemColor: DarkThemeColors.deactive,
        selectedLabelStyle: DarkTextTheme.captionL,
        unselectedLabelStyle: DarkTextTheme.captionS,
      ),
);

final lightTheme = darkTheme;
