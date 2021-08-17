import 'package:bloc/bloc.dart';

/// Cubit that controls the [MapScreen],
/// [int] is the floor number map shows
class MapCubit extends Cubit<int> {
  /// Number of the floor we show when screen opens
  static int initialFloor = 1;
  /// Number of the last floor we are able to show
  static int maxFloor = 4;

  /// The current floor that we show to the user
  int state = initialFloor;

  MapCubit() : super(initialFloor);

  /// Open the upper floor
  void goUp() {
    if (state < maxFloor) {
      ++state;
      emit(state);
    }
  }

  /// Open the lower floor
  void goDown() {
    if (state > 0) {
      --state;
      emit(state);
    }
  }
}
