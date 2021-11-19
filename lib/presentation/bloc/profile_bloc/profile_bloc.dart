import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserData getUserData;

  ProfileBloc({required this.getUserData}) : super(ProfileInitial()) {
    on<ProfileGetUserData>(_onProfileGetUserData);
  }

  void _onProfileGetUserData(
    ProfileGetUserData event,
    Emitter<ProfileState> emit,
  ) async {
    // To get profile data only once
    if (state.runtimeType != ProfileLoaded) {
      emit(ProfileLoading());
      final user = await getUserData(GetUserDataParams(event.token));
      user.fold((failure) => emit(ProfileInitial()),
          (r) => emit(ProfileLoaded(user: r)));
    }
  }
}
