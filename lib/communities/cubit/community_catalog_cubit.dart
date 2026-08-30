import 'package:bloc/bloc.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/communities/cubit/community_catalog_status.dart';

part 'community_catalog_cubit.freezed.dart';
part 'community_catalog_state.dart';

class CommunityCatalogCubit extends Cubit<CommunityCatalogState> {
  CommunityCatalogCubit({required CommunityCatalogRepository repository})
    : this._(repository);

  CommunityCatalogCubit._(this._repository)
    : super(const CommunityCatalogState());

  final CommunityCatalogRepository _repository;
  var _requestId = 0;

  Future<void> load({required String locale}) async {
    final requestId = ++_requestId;
    final coldLoad = state.catalog == null;
    emit(
      state.copyWith(
        status: coldLoad ? .loading : state.status,
        isRefreshing: !coldLoad,
      ),
    );
    try {
      final catalog = await _repository.getCatalog(locale: locale);
      if (isClosed || requestId != _requestId) return;
      emit(
        state.copyWith(
          status: .success,
          catalog: catalog,
          isRefreshing: false,
        ),
      );
    } on Object catch (error, stackTrace) {
      if (isClosed || requestId != _requestId) return;
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: coldLoad ? .failure : state.status,
          isRefreshing: false,
        ),
      );
    }
  }

  void queryChanged(String query) => emit(state.copyWith(query: query));

  void sectionSelected(String? sectionKey) =>
      emit(state.copyWith(selectedSectionKey: sectionKey));
}
