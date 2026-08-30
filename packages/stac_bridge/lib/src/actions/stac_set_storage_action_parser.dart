import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

const kStoragePlaceholderPrefix = 'storage.';
final _activeStorageKeys = <String>{};
Object? _activeStorageOwner;

typedef StorageActionModel = Map<String, Object?>;

void primeMiniAppStorage(
  Map<String, Object?> values, {
  required Object owner,
}) {
  clearMiniAppStorage();
  _activeStorageOwner = owner;
  for (final entry in values.entries) {
    _setStorageValue(entry.key, entry.value);
  }
}

void clearMiniAppStorage({Object? owner}) {
  if (owner != null && !identical(owner, _activeStorageOwner)) return;
  _activeStorageKeys
    ..forEach(StacRegistry.instance.removeValue)
    ..clear();
  _activeStorageOwner = null;
}

void _setStorageValue(String key, Object? value) {
  final registryKey = '$kStoragePlaceholderPrefix$key';
  StacRegistry.instance.setValue(registryKey, value);
  if (value == null) {
    _activeStorageKeys.remove(registryKey);
  } else {
    _activeStorageKeys.add(registryKey);
  }
}

class StacSetStorageActionParser
    implements StacActionParser<StorageActionModel> {
  const StacSetStorageActionParser();

  @override
  String get actionType => 'setStorage';

  @override
  StorageActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    StorageActionModel model,
  ) async {
    final key = stringOf(model, 'key');
    if (key.isEmpty) return null;
    final value = model['value'];
    _setStorageValue(key, value);
    await MiniAppSessionStack.current?.host.setStorage(key, value);
    return null;
  }
}
