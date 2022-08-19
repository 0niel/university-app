import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/usecases/get_stories.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final GetStories getStories;

  StoriesBloc({required this.getStories}) : super(StoriesInitial()) {
    on<StoriesEvent>((event, emit) async {
      if (event is LoadStories) {
        emit(StoriesLoading());

        final stories = await getStories();
        stories.fold((failure) => emit(StoriesLoadError()),
            (r) => emit(StoriesLoaded(stories: r)));
      }
    });
  }
}
