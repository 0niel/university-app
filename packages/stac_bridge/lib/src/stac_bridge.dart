import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_actions.dart';
import 'package:stac_bridge/src/actions/fetch_action.dart';
import 'package:stac_bridge/src/actions/flow_actions.dart';
import 'package:stac_bridge/src/actions/flow_control_actions.dart';
import 'package:stac_bridge/src/actions/host_actions.dart';
import 'package:stac_bridge/src/actions/material_feedback_actions.dart';
import 'package:stac_bridge/src/actions/state_actions.dart';
import 'package:stac_bridge/src/actions/storage_actions.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';
import 'package:stac_bridge/src/proxy_interceptor.dart';
import 'package:stac_bridge/src/stac_bridge_config.dart';
import 'package:stac_bridge/src/widgets/kit/kit_widget_parsers.dart';
import 'package:stac_bridge/src/widgets/material/material_override_parsers.dart';

export 'stac_bridge_config.dart';

abstract final class StacBridge {
  static bool _initialized = false;

  static const parsers = <StacParser<Object?>>[
    ...kitWidgetParsers,
    ...materialOverrideParsers,
  ];

  static const actionParsers = <StacActionParser<Object?>>[
    StacAddCalendarEventActionParser(),
    StacAuthenticateActionParser(),
    StacCloseMiniAppActionParser(),
    StacConfirmActionParser(),
    StacCopyActionParser(),
    StacDialogKitActionParser(),
    StacFetchActionParser(),
    StacForEachActionParser(),
    StacGetLocationActionParser(),
    StacHapticActionParser(),
    StacModalBottomSheetKitActionParser(),
    StacOpenDeepLinkActionParser(),
    StacOpenMiniAppActionParser(),
    StacOpenPageActionParser(),
    StacOpenSheetActionParser(),
    StacOpenUrlActionParser(),
    StacPickDateTimeActionParser(),
    StacPickFileActionParser(),
    StacPickImageActionParser(),
    StacPopActionParser(),
    StacReadClipboardActionParser(),
    StacReloadActionParser(),
    StacRunIfActionParser(),
    StacScanCodeActionParser(),
    StacScheduleReminderActionParser(),
    StacSetStateActionParser(),
    StacSetStorageActionParser(),
    StacShareActionParser(),
    StacSnackBarKitActionParser(),
    StacToastActionParser(),
  ];

  static Set<String> get widgetTypes => {
    for (final parser in parsers) parser.type,
  };

  static Set<String> get actionTypes => {
    for (final parser in actionParsers) parser.actionType,
  };

  static Future<void> ensureInitialized(StacBridgeConfig config) async {
    if (_initialized) return;
    final dio = Dio()
      ..interceptors.add(MiniAppProxyInterceptor(config: config));
    await Stac.initialize(
      dio: dio,
      parsers: parsers,
      actionParsers: actionParsers,
      override: true,
      showErrorWidgets: false,
    );
    _initialized = true;
  }

  static Widget? render(Map<String, Object?> json, BuildContext context) {
    return Stac.fromJson(wrapScreenForLogic(json), context);
  }
}
