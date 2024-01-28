import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neon_dashboard/l10n/localizations.dart';
import 'package:neon_dashboard/src/blocs/dashboard.dart';
import 'package:neon_dashboard/src/widgets/dry_intrinsic_height.dart';
import 'package:neon_dashboard/src/widgets/widget.dart';
import 'package:neon_dashboard/src/widgets/widget_button.dart';
import 'package:neon_dashboard/src/widgets/widget_item.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/dashboard.dart' as dashboard;

/// Displays the whole dashboard page layout.
class DashboardMainPage extends StatelessWidget {
  /// Creates a new dashboard main page.
  const DashboardMainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = NeonProvider.of<DashboardBloc>(context);

    return NeonCustomBackground(
      child: ResultBuilder.behaviorSubject(
        subject: bloc.widgets,
        builder: (context, snapshot) {
          Widget? child;
          if (snapshot.hasData) {
            var minHeight = 504.0;

            final children = <Widget>[];
            for (final widget in snapshot.requireData.entries) {
              final items = buildWidgetItems(
                context: context,
                widget: widget.key,
                items: widget.value,
              ).toList();

              final height = items.map((i) => i.height!).reduce((a, b) => a + b);
              minHeight = max(minHeight, height);

              children.add(
                DashboardWidget(
                  widget: widget.key,
                  children: items,
                ),
              );
            }

            child = Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: children
                  .map(
                    (widget) => SizedBox(
                      width: 320,
                      height: minHeight + 24,
                      child: widget,
                    ),
                  )
                  .toList(),
            );
          }

          return Center(
            child: NeonListView.custom(
              scrollKey: 'dashboard',
              isLoading: snapshot.isLoading,
              error: snapshot.error,
              onRefresh: bloc.refresh,
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the list of messages, [items] and buttons for a [widget].
  @visibleForTesting
  static Iterable<SizedBox> buildWidgetItems({
    required BuildContext context,
    required dashboard.Widget widget,
    required dashboard.WidgetItems? items,
  }) sync* {
    yield SizedBox(
      height: 64,
      child: DryIntrinsicHeight(
        child: ListTile(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: SizedBox.square(
            dimension: largeIconSize,
            child: _buildWidgetIcon(
              context: context,
              widget: widget,
            ),
          ),
        ),
      ),
    );

    yield const SizedBox(
      height: 20,
    );

    final halfEmptyContentMessage = _buildMessage(items?.halfEmptyContentMessage);
    final emptyContentMessage = _buildMessage(items?.emptyContentMessage);
    if (halfEmptyContentMessage != null) {
      yield halfEmptyContentMessage;
    }
    if (emptyContentMessage != null) {
      yield emptyContentMessage;
    }
    if (halfEmptyContentMessage == null && emptyContentMessage == null && (items?.items.isEmpty ?? true)) {
      yield _buildMessage(DashboardLocalizations.of(context).noEntries)!;
    }

    if (items?.items != null) {
      for (final item in items!.items) {
        yield SizedBox(
          height: 64,
          child: DryIntrinsicHeight(
            child: DashboardWidgetItem(
              item: item,
              roundIcon: widget.itemIconsRound,
            ),
          ),
        );
      }
    }

    yield const SizedBox(
      height: 20,
    );

    if (widget.buttons != null) {
      for (final button in widget.buttons!) {
        yield SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: DashboardWidgetButton(
              button: button,
            ),
          ),
        );
      }
    }
  }

  static Widget _buildWidgetIcon({
    required BuildContext context,
    required dashboard.Widget widget,
  }) {
    final colorFilter = ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn);

    if (widget.iconUrl.isNotEmpty) {
      return NeonUrlImage(
        uri: Uri.parse(widget.iconUrl),
        svgColorFilter: colorFilter,
        size: const Size.square(largeIconSize),
      );
    }

    if (widget.iconClass.isNotEmpty) {
      return NeonServerIcon(
        icon: widget.iconClass,
        colorFilter: colorFilter,
        size: largeIconSize,
      );
    }

    return Icon(
      Icons.question_mark,
      color: Theme.of(context).colorScheme.primary,
      size: largeIconSize,
    );
  }

  static SizedBox? _buildMessage(String? message) {
    if (message == null || message.isEmpty) {
      return null;
    }

    return SizedBox(
      height: 60,
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.check,
              size: largeIconSize,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
