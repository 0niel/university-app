import 'dart:async';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:nextcloud/dashboard.dart' as dashboard;
import 'package:rxdart/rxdart.dart';

/// Bloc for fetching dashboard widgets and their items.
sealed class DashboardBloc implements InteractiveBloc {
  /// Creates a new Dashboard Bloc instance.
  @internal
  factory DashboardBloc(Account account) => _DashboardBloc(account);

  /// Dashboard widgets that are displayed.
  BehaviorSubject<Result<Map<dashboard.Widget, dashboard.WidgetItems?>>> get widgets;
}

/// Implementation of [DashboardBloc].
///
/// Automatically starts fetching the widgets and their items and refreshes everything every 30 seconds.
class _DashboardBloc extends InteractiveBloc implements DashboardBloc {
  _DashboardBloc(this.account) {
    unawaited(refresh());

    timer = TimerBloc().registerTimer(const Duration(seconds: 30), refresh);
  }

  final Account account;
  late final NeonTimer timer;
  static const int maxItems = 7;

  @override
  BehaviorSubject<Result<Map<dashboard.Widget, dashboard.WidgetItems?>>> widgets = BehaviorSubject();

  @override
  void dispose() {
    timer.cancel();
    unawaited(widgets.close());
    super.dispose();
  }

  @override
  Future<void> refresh() async {
    widgets.add(widgets.valueOrNull?.asLoading() ?? Result.loading());

    try {
      final widgets = <String, dashboard.WidgetItems?>{};
      final v1WidgetIDs = ListBuilder<String>();
      final v2WidgetIDs = ListBuilder<String>();

      final response = await account.client.dashboard.dashboardApi.getWidgets();

      for (final widget in response.body.ocs.data.values) {
        final itemApiVersions = widget.itemApiVersions;
        if (itemApiVersions != null && itemApiVersions.contains(2)) {
          v2WidgetIDs.add(widget.id);
        } else if (itemApiVersions == null || itemApiVersions.contains(1)) {
          // If the field isn't present the server only supports v1
          v1WidgetIDs.add(widget.id);
        } else {
          debugPrint('Widget supports none of the API versions: ${widget.id}');
        }
      }

      if (v1WidgetIDs.isNotEmpty) {
        final widgetsIDs = v1WidgetIDs.build();
        debugPrint('Loading v1 widgets: ${widgetsIDs.join(', ')}');

        final response = await account.client.dashboard.dashboardApi.getWidgetItems(
          widgets: widgetsIDs,
          limit: maxItems,
        );
        for (final entry in response.body.ocs.data.entries) {
          widgets[entry.key] = dashboard.WidgetItems(
            (b) => b
              ..items = entry.value.sublist(0, min(entry.value.length, maxItems)).toBuilder()
              ..emptyContentMessage = ''
              ..halfEmptyContentMessage = '',
          );
        }
      }

      if (v2WidgetIDs.isNotEmpty) {
        final widgetsIDs = v2WidgetIDs.build();
        debugPrint('Loading v2 widgets: ${widgetsIDs.join(', ')}');

        final response = await account.client.dashboard.dashboardApi.getWidgetItemsV2(
          widgets: widgetsIDs,
          limit: maxItems,
        );
        widgets.addEntries(
          response.body.ocs.data.entries.map(
            (entry) => MapEntry(
              entry.key,
              entry.value.rebuild((b) {
                if (b.items.length > maxItems) {
                  b.items.removeRange(maxItems, b.items.length);
                }
              }),
            ),
          ),
        );
      }

      this.widgets.add(
            Result.success(
              widgets.map(
                (id, items) => MapEntry(
                  response.body.ocs.data.values.firstWhere((widget) => widget.id == id),
                  items,
                ),
              ),
            ),
          );
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());

      widgets.add(Result.error(e));
      return;
    }
  }
}
