import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

part 'service_catalog_cubit.freezed.dart';
part 'service_catalog_state.dart';

class ServiceCatalogCubit extends Cubit<ServiceCatalogState> {
  ServiceCatalogCubit(this._repository) : super(const ServiceCatalogState());

  final ServiceCatalogRepository _repository;
  var _requestId = 0;

  Future<void> load({required String locale}) async {
    final requestId = ++_requestId;
    final coldLoad = state.catalog == null;
    emit(
      state.copyWith(
        isLoading: coldLoad,
        isRefreshing: !coldLoad,
      ),
    );
    try {
      final catalog = await _repository.getCatalog(locale: locale);
      if (isClosed || requestId != _requestId) return;
      emit(
        state.copyWith(
          catalog: catalog,
          isLoading: false,
          isRefreshing: false,
        ),
      );
    } on Object catch (error, stackTrace) {
      if (isClosed || requestId != _requestId) return;
      addError(error, stackTrace);
      emit(state.copyWith(isLoading: false, isRefreshing: false));
    }
  }
}
