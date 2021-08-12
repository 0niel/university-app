import 'package:bloc/bloc.dart';

/// Cubit that controls the [OnBoardingScreen],
/// [int] states this is the current PageView page
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  /// Swipe PageView.
  void swipe(int page) => emit(page);
}
