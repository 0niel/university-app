import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_search_transition.dart';

class MapTopBar extends StatefulWidget {
  const MapTopBar({
    required this.controller,
    required this.campuses,
    required this.selectedCampus,
    required this.onQueryChanged,
    required this.onCampusSelected,
    required this.onFriends,
    this.onSearchClosed,
    this.showCampusSelector = true,
    super.key,
  });

  final TextEditingController controller;
  final List<CampusModel> campuses;
  final CampusModel? selectedCampus;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CampusModel> onCampusSelected;
  final VoidCallback onFriends;
  final VoidCallback? onSearchClosed;
  final bool showCampusSelector;

  @override
  State<MapTopBar> createState() => _MapTopBarState();
}

class _MapTopBarState extends State<MapTopBar>
    with SingleTickerProviderStateMixin {
  final _focus = FocusNode();
  late final AnimationController _motion;
  late final CurvedAnimation _expansion;
  late bool _searching;

  @override
  void initState() {
    super.initState();
    _searching = widget.controller.text.isNotEmpty;
    _motion = AnimationController(vsync: this, value: _searching ? 1 : 0);
    _expansion = CurvedAnimation(
      parent: _motion,
      curve: NinjaMotion.enter,
      reverseCurve: NinjaMotion.exit,
    );
    widget.controller.addListener(_syncQuery);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = NinjaMotion.of(context, NinjaMotion.slow);
    _motion.duration = duration;
    if (duration == Duration.zero) _motion.value = _searching ? 1 : 0;
  }

  @override
  void didUpdateWidget(covariant MapTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncQuery);
      widget.controller.addListener(_syncQuery);
      _searching = widget.controller.text.isNotEmpty;
      _motion.value = _searching ? 1 : 0;
    }
  }

  void _syncQuery() {
    final hasQuery = widget.controller.text.isNotEmpty;
    if (hasQuery && !_searching) {
      setState(() => _searching = true);
      unawaited(_motion.forward());
    } else if (!hasQuery && _searching && !_focus.hasFocus) {
      setState(() => _searching = false);
      unawaited(_motion.reverse());
    }
  }

  Future<void> _openSearch() async {
    setState(() => _searching = true);
    try {
      await _motion.forward().orCancel;
    } on TickerCanceled {
      if (!mounted || !_searching || !_motion.isCompleted) return;
    }
    if (!mounted || !_searching) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _searching && _motion.isCompleted) _focus.requestFocus();
    });
  }

  void _closeSearch() {
    if (!_searching) return;
    setState(() => _searching = false);
    _focus.unfocus();
    final hadQuery = widget.controller.text.isNotEmpty;
    widget.controller.clear();
    if (hadQuery) widget.onQueryChanged('');
    unawaited(_motion.reverse());
    widget.onSearchClosed?.call();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncQuery);
    _expansion.dispose();
    _motion.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _chooseCampus() => showAppSheet<void>(
    context,
    title: context.l10n.mapCampusesTitle,
    child: AppListGroup(
      children: [
        for (final campus in widget.campuses)
          AppListRow(
            title: campus.displayName,
            leading: const AppIconTile(icon: AppLineIcon.school),
            trailing: campus.id == widget.selectedCampus?.id
                ? const AppLineIconWidget(AppLineIcon.check)
                : null,
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              if (campus.id != widget.selectedCampus?.id) {
                widget.onCampusSelected(campus);
              }
            },
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchHeight =
        50.0 +
        (MediaQuery.textScalerOf(context).scale(18) - 18).clamp(0.0, 30.0);
    return PopScope(
      canPop: !_searching,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _searching) _closeSearch();
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): _closeSearch,
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            MediaQuery.paddingOf(context).top + AppSpacing.sm,
            AppSpacing.lg,
            0,
          ),
          child: AppGlassBatch(
            child: MapSearchTransition(
              animation: _expansion,
              searching: _searching,
              height: searchHeight,
              tooltip: _searching
                  ? MaterialLocalizations.of(context).backButtonTooltip
                  : l10n.mapSearchPlaceholder,
              onToggle: _searching ? _closeSearch : _openSearch,
              search: AppGlassBatch.exclude(
                child: AppSearchField(
                  controller: widget.controller,
                  tone: AppSearchFieldTone.glass,
                  leading: const SizedBox.square(dimension: AppIconSize.md),
                  focusNode: _focus,
                  height: searchHeight,
                  hintText: l10n.mapSearchPlaceholder,
                  isOnCanvas: true,
                  onChanged: widget.onQueryChanged,
                  onSubmitted: (_) => _focus.unfocus(),
                ),
              ),
              actions: Row(
                children: [
                  Expanded(
                    child: widget.showCampusSelector
                        ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: AppButton.glass(
                              label:
                                  widget.selectedCampus?.displayName ??
                                  l10n.mapCampusFilter,
                              trailingIcon: const AppLineIconWidget(
                                AppLineIcon.chevronD,
                                size: 16,
                              ),
                              size: AppButtonSize.small,
                              onPressed: widget.campuses.isEmpty
                                  ? null
                                  : () => unawaited(_chooseCampus()),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppIconButton(
                    icon: const AppLineIconWidget(AppLineIcon.people),
                    tooltip: l10n.mapFriendsToggle,
                    tone: AppIconButtonTone.glass,
                    shape: AppIconButtonShape.circle,
                    onPressed: widget.onFriends,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
