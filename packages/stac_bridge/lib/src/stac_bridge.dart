import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_actions.dart';
import 'package:stac_bridge/src/actions/fetch_action.dart';
import 'package:stac_bridge/src/actions/flow_actions.dart';
import 'package:stac_bridge/src/actions/flow_control_actions.dart';
import 'package:stac_bridge/src/actions/host_actions.dart';
import 'package:stac_bridge/src/actions/state_actions.dart';
import 'package:stac_bridge/src/actions/storage_actions.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';
import 'package:stac_bridge/src/proxy_interceptor.dart';
import 'package:stac_bridge/src/stac_bridge_config.dart';
import 'package:stac_bridge/src/widgets/app_badge_parsers.dart';
import 'package:stac_bridge/src/widgets/app_button_parser.dart';
import 'package:stac_bridge/src/widgets/app_card_parser.dart';
import 'package:stac_bridge/src/widgets/app_chip_parser.dart';
import 'package:stac_bridge/src/widgets/app_control_parsers.dart';
import 'package:stac_bridge/src/widgets/app_data_parsers.dart';
import 'package:stac_bridge/src/widgets/app_empty_state_parser.dart';
import 'package:stac_bridge/src/widgets/app_icon_parsers.dart';
import 'package:stac_bridge/src/widgets/app_input_field_parser.dart';
import 'package:stac_bridge/src/widgets/app_list_row_parser.dart';
import 'package:stac_bridge/src/widgets/app_meta_pill_parser.dart';
import 'package:stac_bridge/src/widgets/app_section_title_parser.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';
import 'package:stac_bridge/src/widgets/app_text_parser.dart';

export 'stac_bridge_config.dart';

/// {@template stac_bridge}
/// One-time initializer of the Stac runtime used by all mini apps:
///
///  * registers the app_ui widget parsers (`appButton`, `appCard`, …);
///  * registers host actions (`openDeepLink`, `openPage`, `share`, …);
///  * injects a Dio instance whose interceptor routes every
///    `networkRequest` through the secure Supabase proxy.
/// {@endtemplate}
abstract final class StacBridge {
  static bool _initialized = false;

  /// All custom widget parsers exposed to mini apps.
  static const parsers = <StacParser<Object?>>[
    StacAppAvatarParser(),
    StacAppAvatarStackParser(),
    StacAppButtonParser(),
    StacAppCardParser(),
    StacAppChipParser(),
    StacAppEmptyStateParser(),
    StacAppErrorStateParser(),
    StacAppIconButtonParser(),
    StacAppInputFieldParser(),
    StacAppLineIconParser(),
    StacAppListRowParser(),
    StacAppLiveBadgeParser(),
    StacAppMetaPillParser(),
    StacAppProgressRingParser(),
    StacAppSectionTitleParser(),
    StacAppSegmentedControlParser(),
    StacAppServiceTileParser(),
    StacAppStateScopeParser(),
    StacAppSmartChipParser(),
    StacAppTagParser(),
    StacAppTextParser(),
    StacAppToggleParser(),
  ];

  /// All custom action parsers exposed to mini apps.
  static const actionParsers = <StacActionParser<Object?>>[
    StacAddCalendarEventActionParser(),
    StacAuthenticateActionParser(),
    StacCloseMiniAppActionParser(),
    StacConfirmActionParser(),
    StacCopyActionParser(),
    StacFetchActionParser(),
    StacForEachActionParser(),
    StacGetLocationActionParser(),
    StacHapticActionParser(),
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
    StacToastActionParser(),
  ];

  /// Initializes the Stac runtime once; safe to call repeatedly.
  static Future<void> ensureInitialized(StacBridgeConfig config) async {
    if (_initialized) return;
    final dio = Dio()
      ..interceptors.add(MiniAppProxyInterceptor(config: config));
    await Stac.initialize(
      dio: dio,
      parsers: parsers,
      actionParsers: actionParsers,
      showErrorWidgets: false,
    );
    _initialized = true;
  }

  /// Renders a screen JSON, null when the tree cannot be parsed. The screen is
  /// wrapped in an implicit `appStateScope` so the logic layer (`{{ }}`,
  /// `appIf`/`appForEach`, `setState`/`fetch`) works at the root without
  /// author boilerplate; already-scoped screens are left as-is.
  static Widget? render(Map<String, Object?> json, BuildContext context) {
    return Stac.fromJson(wrapScreenForLogic(json), context);
  }
}
