import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/services/data/favorite_services_repository.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';

class FavoriteServicesCubit extends Cubit<FavoriteServicesState> {
  FavoriteServicesCubit({FavoriteServicesRepository? repository})
    : _repository = repository ?? const FavoriteServicesRepository(),
      super(FavoriteServicesState());

  final FavoriteServicesRepository _repository;
  Future<void>? _loadOperation;
  Future<void> _saveOperation = Future.value();

  Future<void> load() => _loadOperation ??= _load();

  Future<void> _load() async {
    final ids = await _repository.load();
    if (isClosed) return;
    emit(FavoriteServicesState(ids: ids, loaded: true));
  }

  Future<void> toggle(ServiceModel service) async {
    await load();
    if (isClosed) return;
    final id = FavoriteServicesRepository.idOf(
      routePath: service.routePath,
      url: service.url,
    );
    if (id == null) return;
    final ids = {...state.ids};
    if (!ids.remove(id)) ids.add(id);
    emit(FavoriteServicesState(ids: ids, loaded: true));
    final snapshot = Set.of(ids);
    final save = _saveOperation.then((_) => _repository.save(snapshot));
    _saveOperation = save;
    await save;
  }
}

class FavoriteServicesState {
  FavoriteServicesState({Set<String> ids = const {}, this.loaded = false})
    : ids = UnmodifiableSetView(ids);

  final Set<String> ids;
  final bool loaded;

  bool contains(ServiceModel service) {
    final id = FavoriteServicesRepository.idOf(
      routePath: service.routePath,
      url: service.url,
    );
    return id != null && ids.contains(id);
  }
}
