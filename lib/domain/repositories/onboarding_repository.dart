import 'package:rtu_mirea_app/domain/entities/onboarding_page.dart';
import 'package:rtu_mirea_app/data/datasources/onboarding_data.dart';

/// Repository for onboarding pages info interface
abstract class OnBoardingRepository {
  final OnBoardingDataSource dataSource;

  OnBoardingRepository({required this.dataSource});

  /// Get page info
  OnBoardingPage getPage(int page);

  /// Get pages count
  int getPagesNum();
}
