import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

String stateKeyOf(KitModel model) => stringOf(model, 'stateKey');

Object? stateValueOf(BuildContext context, KitModel model) {
  final key = stateKeyOf(model);
  if (key.isEmpty) return null;
  return MiniAppStateScope.of(context)?.get(key);
}

bool writeStateValue(BuildContext context, KitModel model, Object? value) {
  final key = stateKeyOf(model);
  final store = MiniAppStateScope.of(context);
  if (key.isEmpty || store == null) return false;
  store.set(key, value);
  return true;
}

bool boolStateOf(BuildContext context, KitModel model, String key) {
  if (model.containsKey(key)) return boolOf(model, key);
  final value = stateValueOf(context, model);
  if (value is bool) return value;
  return value is String && value == 'true';
}

String stringStateOf(BuildContext context, KitModel model, String key) {
  if (model.containsKey(key)) {
    final value = model[key];
    return value?.toString() ?? '';
  }
  return stateValueOf(context, model)?.toString() ?? '';
}

int intStateOf(BuildContext context, KitModel model, String key, int fallback) {
  if (model.containsKey(key)) return intOf(model, key) ?? fallback;
  final value = stateValueOf(context, model);
  if (value is num) return value.toInt();
  return value is String ? int.tryParse(value) ?? fallback : fallback;
}
