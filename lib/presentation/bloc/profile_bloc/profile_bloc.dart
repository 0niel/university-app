import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/contributor.dart';
import 'package:rtu_mirea_app/domain/usecases/get_contributors.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.getContributors}) : super(ProfileInitial());

  final GetContributors getContributors;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileGetContributors) {
      yield ProfileContributorsLoading();
      final contributors = await getContributors();
      yield contributors.fold((failure) => ProfileContributorsLoadError(),
          (r) => ProfileContributorsLoaded(contributors: r));
    }
  }
}
