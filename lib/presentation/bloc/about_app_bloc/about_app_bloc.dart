import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/contributor.dart';
import 'package:rtu_mirea_app/domain/usecases/get_contributors.dart';

part 'about_app_event.dart';
part 'about_app_state.dart';

class AboutAppBloc extends Bloc<AboutAppEvent, AboutAppState> {
  AboutAppBloc({required this.getContributors}) : super(AboutAppInitial());

  final GetContributors getContributors;

  @override
  Stream<AboutAppState> mapEventToState(
    AboutAppEvent event,
  ) async* {
    if (event is AboutAppGetContributors) {
      yield AboutAppContributorsLoading();
      final contributors = await getContributors();
      yield contributors.fold((failure) => AboutAppContributorsLoadError(),
          (r) => AboutAppContributorsLoaded(contributors: r));
    }
  }
}
