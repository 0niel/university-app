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
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final user = await getUserData();
    user.fold((failure) => emit(ProfileUnauthenticated()),
        (r) => emit(ProfileAuthenticated(user: r)));
  }
}
