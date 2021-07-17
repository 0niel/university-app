import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';

abstract class OnBoardingRepository {
  OnBoardingPage getPage(int page);
}
