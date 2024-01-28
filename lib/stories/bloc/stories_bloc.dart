import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/repositories/stories_repository.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final StoriesRepository storiesRepository;

  StoriesBloc({required this.storiesRepository}) : super(StoriesInitial()) {
    on<StoriesEvent>((event, emit) async {
      if (event is LoadStories) {
        emit(StoriesLoading());

        final stories = await storiesRepository.getStories();
        stories.fold((failure) => emit(StoriesLoadError()), (r) => emit(StoriesLoaded(stories: r)));
      }
    });
  }

  static List<Story> getActualStories(List<Story> stories) {
    List<Story> actualStories = [];
    for (final story in stories) {
      if (DateTime.now().compareTo(story.stopShowDate) == -1) {
        actualStories.add(story);
      }
    }

    return actualStories;
  }
}
