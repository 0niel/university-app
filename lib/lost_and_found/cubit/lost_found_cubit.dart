import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_state.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_status.dart';
import 'package:rtu_mirea_app/lost_and_found/models/models.dart';

export 'lost_found_state.dart';
export 'lost_found_status.dart';

class LostFoundCubit extends Cubit<LostFoundState> {
  LostFoundCubit({required LostFoundRepository lostFoundRepository})
    : _repository = lostFoundRepository,
      super(const LostFoundState());

  final LostFoundRepository _repository;
  int _revision = 0;

  LostFoundStatus get _stableStatus => state.items.isEmpty ? .initial : .ready;

  Future<bool> load() async {
    if (state.isBusy) return false;
    final revision = ++_revision;
    emit(state.copyWith(status: .loading));
    try {
      final items = await _repository.getItems(limit: 100);
      if (revision != _revision || isClosed) return false;
      emit(state.copyWith(status: .ready, items: items));
      return true;
    } on Object catch (error, stackTrace) {
      if (revision != _revision || isClosed) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  void tabChanged(LostFoundItemStatus tab) => emit(state.copyWith(tab: tab));

  void categoryChanged(String category) =>
      emit(state.copyWith(category: category.trim()));

  void queryChanged(String query) => emit(state.copyWith(query: query));

  void searchToggled() {
    final isSearching = !state.isSearching;
    emit(
      state.copyWith(
        isSearching: isSearching,
        query: isSearching ? state.query : '',
      ),
    );
  }

  Future<bool> create(LostFoundReportDraft draft) async {
    if (!draft.isValid || state.isCreating) return false;
    _revision++;
    emit(state.copyWith(status: _stableStatus, isCreating: true));
    try {
      final item = await _repository.createItem(
        title: draft.title.trim(),
        status: draft.status,
        category: draft.category.trim(),
        description: draft.description.trim(),
        telegram: draft.telegram.trim(),
        phoneNumber: draft.phoneNumber.trim(),
        location: draft.location.trim(),
        showContact: draft.showContact,
        images: draft.images,
      );
      if (isClosed) return false;
      emit(
        state.copyWith(
          status: .ready,
          items: [item, ...state.items.where((entry) => entry.id != item.id)],
          isCreating: false,
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) emit(state.copyWith(isCreating: false));
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> toggleItemStatus(LostFoundItem requestedItem) async {
    final id = requestedItem.id;
    if (state.pendingStatusIds.contains(id) ||
        state.pendingDeleteIds.contains(id)) {
      return false;
    }
    final item = state.items.firstWhereOrNull((entry) => entry.id == id);
    if (item == null) return false;
    final newStatus = item.status == .lost
        ? LostFoundItemStatus.found
        : LostFoundItemStatus.lost;
    _revision++;
    emit(
      state.copyWith(
        status: .ready,
        items: [
          for (final entry in state.items)
            if (entry.id == id) entry.copyWith(status: newStatus) else entry,
        ],
        pendingStatusIds: {...state.pendingStatusIds, id},
      ),
    );
    try {
      await _repository.updateItemStatus(itemId: id, newStatus: newStatus);
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingStatusIds: {...state.pendingStatusIds}..remove(id),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            items: [
              for (final entry in state.items)
                if (entry.id == id)
                  entry.copyWith(status: item.status)
                else
                  entry,
            ],
            pendingStatusIds: {...state.pendingStatusIds}..remove(id),
          ),
        );
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> deleteItem(LostFoundItem requestedItem) async {
    final id = requestedItem.id;
    if (state.pendingDeleteIds.contains(id) ||
        state.pendingStatusIds.contains(id)) {
      return false;
    }
    final index = state.items.indexWhere((entry) => entry.id == id);
    final item = state.items.elementAtOrNull(index);
    if (item == null) return false;
    _revision++;
    emit(
      state.copyWith(
        status: .ready,
        items: [...state.items]..removeAt(index),
        pendingDeleteIds: {...state.pendingDeleteIds, id},
      ),
    );
    try {
      final result = await _repository.deleteItem(itemId: id);
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingDeleteIds: {...state.pendingDeleteIds}..remove(id),
          cleanupWarningRevision:
              state.cleanupWarningRevision + (result.hasCleanupFailure ? 1 : 0),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        final restored = [...state.items];
        restored.insert(index.clamp(0, restored.length), item);
        emit(
          state.copyWith(
            items: restored,
            pendingDeleteIds: {...state.pendingDeleteIds}..remove(id),
          ),
        );
      }
      addError(error, stackTrace);
      return false;
    }
  }
}
