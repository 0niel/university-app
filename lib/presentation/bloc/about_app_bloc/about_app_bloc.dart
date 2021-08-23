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
    if (event is AboutAppGetMembers) {
      bool contributorsLoadError = false;
      bool patronsLoadError = false;

      List<Contributor> contributorsList = [];
      List<ForumMember> patronsList = [];

      yield AboutAppMembersLoading();
      final contributors = await getContributors();
      contributors.fold((failure) {
        contributorsLoadError = true;
      }, (r) {
        contributorsList = r;
      });

      final patrons = await getForumPatrons();
      patrons.fold((failure) {
        patronsLoadError = true;
      }, (r) {
        patronsList = r;
      });

      if (contributorsLoadError && patronsLoadError)
        yield AboutAppMembersLoadError(
            contributorsLoadError: true, patronsLoadError: true);
      else {
        yield AboutAppMembersLoadError(
            contributorsLoadError: contributorsLoadError,
            patronsLoadError: patronsLoadError);
        yield AboutAppMembersLoaded(
            patrons: patronsList, contributors: contributorsList);
      }
    }
  }
}
