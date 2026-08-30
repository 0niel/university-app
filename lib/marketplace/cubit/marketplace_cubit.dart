import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_status.dart';
import 'package:rtu_mirea_app/marketplace/models/models.dart';

part 'marketplace_state.dart';
part 'marketplace_cubit.freezed.dart';

class MarketplaceCubit extends Cubit<MarketplaceState> {
  MarketplaceCubit(this._repository) : super(const MarketplaceState());

  final CampusRepository _repository;
  var _loadRevision = 0;

  Future<bool> load() async {
    if (state.pendingSoldIds.isNotEmpty ||
        state.pendingDeleteIds.isNotEmpty ||
        state.isCreating) {
      return false;
    }
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final items = await _repository.getListings();
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .ready, items: items));
      return true;
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  void filterChanged(String filterKey) {
    if (filterKey == state.filterKey) return;
    emit(state.copyWith(filterKey: filterKey));
  }

  Future<bool> toggleSold(MarketListing item) async {
    if (state.pendingSoldIds.contains(item.id)) return false;
    final current = state.items.firstWhereOrNull(
      (candidate) => candidate.id == item.id,
    );
    if (current == null) return false;
    final fallbackStatus = _stableStatus;
    _loadRevision++;
    emit(
      state.copyWith(
        status: fallbackStatus,
        items: _replace(current.copyWith(isSold: !current.isSold)),
        pendingSoldIds: {...state.pendingSoldIds, item.id},
      ),
    );
    try {
      await _repository.setListingSold(id: item.id, sold: !current.isSold);
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingSoldIds: {...state.pendingSoldIds}..remove(item.id),
        ),
      );
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: fallbackStatus,
            items: _replace(current),
            pendingSoldIds: {...state.pendingSoldIds}..remove(item.id),
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> delete(MarketListing item) async {
    if (state.pendingDeleteIds.contains(item.id)) return false;
    final current = state.items.firstWhereOrNull(
      (candidate) => candidate.id == item.id,
    );
    if (current == null) return false;
    final fallbackStatus = _stableStatus;
    final index = state.items.indexWhere(
      (candidate) => candidate.id == item.id,
    );
    if (index < 0) return false;
    _loadRevision++;
    emit(
      state.copyWith(
        status: fallbackStatus,
        items: state.items
            .where((candidate) => candidate.id != item.id)
            .toList(growable: false),
        pendingDeleteIds: {...state.pendingDeleteIds, item.id},
      ),
    );
    try {
      await _repository.deleteListing(item.id);
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingDeleteIds: {...state.pendingDeleteIds}..remove(item.id),
        ),
      );
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: fallbackStatus,
            items: _insert(current, index),
            pendingDeleteIds: {...state.pendingDeleteIds}..remove(item.id),
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> create(MarketListingDraft draft) async {
    if (state.isCreating || !draft.isValid) return false;
    final fallbackStatus = _stableStatus;
    _loadRevision++;
    emit(state.copyWith(status: fallbackStatus, isCreating: true));
    try {
      await _repository.createListing(
        title: draft.title.trim(),
        price: draft.price,
        category: draft.category.trim(),
        description: draft.description.trim(),
        showContact: draft.showContact,
      );
      if (isClosed) return false;
      emit(state.copyWith(isCreating: false));
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(status: fallbackStatus, isCreating: false),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  bool _isCurrent(int revision) => !isClosed && revision == _loadRevision;

  MarketplaceStatus get _stableStatus => state.status == .loading
      ? state.items.isEmpty
            ? .initial
            : .ready
      : state.status;

  List<MarketListing> _replace(MarketListing replacement) => [
    for (final item in state.items)
      if (item.id == replacement.id) replacement else item,
  ];

  List<MarketListing> _insert(MarketListing item, int index) {
    if (state.items.any((candidate) => candidate.id == item.id)) {
      return state.items;
    }
    final items = [...state.items];
    items.insert(index.clamp(0, items.length), item);
    return items;
  }
}
