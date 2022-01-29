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
      : super(AboutAppInitial()) {
    on<AboutAppGetMembers>(_onAboutAppGetMembers);
  }

  final GetContributors getContributors;
  final GetForumPatrons getForumPatrons;

  void _onAboutAppGetMembers(
    AboutAppGetMembers event,
    Emitter<AboutAppState> emit,
  ) async {
    bool contributorsLoadError = false;
    bool patronsLoadError = false;

    List<Contributor> contributorsList = [];
    List<ForumMember> patronsList = [];

    emit(AboutAppMembersLoading());
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

    if (contributorsLoadError && patronsLoadError) {
      emit(const AboutAppMembersLoadError(
          contributorsLoadError: true, patronsLoadError: true));
    } else {
      emit(AboutAppMembersLoadError(
          contributorsLoadError: contributorsLoadError,
          patronsLoadError: patronsLoadError));
      emit(AboutAppMembersLoaded(
          patrons: patronsList, contributors: contributorsList));
    }
  }
}
