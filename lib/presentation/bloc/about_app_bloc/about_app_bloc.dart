import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/contributor.dart';
import 'package:rtu_mirea_app/domain/entities/forum_member.dart';
import 'package:rtu_mirea_app/domain/usecases/get_contributors.dart';
import 'package:rtu_mirea_app/domain/usecases/get_patrons.dart';

part 'about_app_event.dart';
part 'about_app_state.dart';

class AboutAppBloc extends Bloc<AboutAppEvent, AboutAppState> {
  AboutAppBloc({required this.getContributors, required this.getForumPatrons})
      : super(AboutAppInitial());

  final GetContributors getContributors;
  final GetForumPatrons getForumPatrons;

  @override
  Stream<AboutAppState> mapEventToState(
    AboutAppEvent event,
  ) async* {
    if (event is AboutAppGetContributors) {
      yield AboutAppContributorsLoading();
      final contributors = await getContributors();
      yield contributors.fold((failure) => AboutAppContributorsLoadError(),
          (r) => AboutAppContributorsLoaded(contributors: r));
    } else if (event is AboutAppGetPatrons) {
      print('true');
      yield AboutAppPatronsLoading();
      final patrons = await getForumPatrons();
      yield patrons.fold((failure) {
        print('failure');
        return AboutAppPatronsLoadError();
      }, (r) {
        print(r);
        return AboutAppPatronsLoaded(patrons: r);
      });
    }
  }
}
