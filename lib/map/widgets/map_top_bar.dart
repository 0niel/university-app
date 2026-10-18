import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

class MapTopBar extends StatefulWidget {
  const MapTopBar({
    required this.controller,
    required this.campuses,
    required this.selectedCampus,
    required this.onQueryChanged,
    required this.onCampusSelected,
    required this.onFriends,
    this.onSearchClosed,
    this.compact = false,
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
  final bool compact;
  final bool showCampusSelector;

  @override
  State<MapTopBar> createState() => _MapTopBarState();
}

class _MapTopBarState extends State<MapTopBar> {
  final _focus = FocusNode();
  late bool _searching;

  @override
  void initState() {
    super.initState();
    _searching = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_syncQuery);
  }

  @override
  void didUpdateWidget(covariant MapTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncQuery);
      widget.controller.addListener(_syncQuery);
      _searching = widget.controller.text.isNotEmpty;
    }
  }

  void _syncQuery() {
    final hasQuery = widget.controller.text.isNotEmpty;
    if (hasQuery && !_searching) {
      setState(() => _searching = true);
    } else if (!hasQuery && _searching && !_focus.hasFocus) {
      setState(() => _searching = false);
    }
  }

  void _openSearch() {
    setState(() => _searching = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _searching) _focus.requestFocus();
    });
  }

  void _closeSearch() {
    if (!_searching) return;
    _focus.unfocus();
    final hadQuery = widget.controller.text.isNotEmpty;
    widget.controller.clear();
    if (hadQuery) widget.onQueryChanged('');
    setState(() => _searching = false);
    widget.onSearchClosed?.call();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncQuery);
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
            MediaQuery.paddingOf(context).top +
                (widget.compact ? AppSpacing.xs : AppSpacing.sm),
            AppSpacing.lg,
            0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => AnimatedSwitcher(
              duration: NinjaMotion.of(context, NinjaMotion.slow),
              reverseDuration: NinjaMotion.of(context, NinjaMotion.fast),
              switchInCurve: NinjaMotion.enter,
              switchOutCurve: NinjaMotion.exit,
              transitionBuilder: (child, animation) => ClipRect(
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  alignment: AlignmentDirectional.topStart,
                  child: FadeTransition(opacity: animation, child: child),
                ),
              ),
              layoutBuilder: (current, previous) => Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  for (final child in previous)
                    ExcludeSemantics(child: IgnorePointer(child: child)),
                  ?current,
                ],
              ),
              child: SizedBox(
                key: ValueKey(_searching),
                width: constraints.maxWidth,
                child: _searching
                    ? Row(
                        children: [
                          AppIconButton(
                            icon: const AppLineIconWidget(AppLineIcon.chevronL),
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).backButtonTooltip,
                            tone: AppIconButtonTone.surface,
                            shape: AppIconButtonShape.circle,
                            onPressed: _closeSearch,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppSearchField(
                              controller: widget.controller,
                              focusNode: _focus,
                              height: searchHeight,
                              hintText: l10n.mapSearchPlaceholder,
                              onCanvas: true,
                              onChanged: widget.onQueryChanged,
                              onSubmitted: (_) => _focus.unfocus(),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          AppIconButton(
                            icon: const AppLineIconWidget(AppLineIcon.search),
                            tooltip: l10n.mapSearchPlaceholder,
                            tone: AppIconButtonTone.surface,
                            shape: AppIconButtonShape.circle,
                            onPressed: _openSearch,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: widget.showCampusSelector
                                ? Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: AppButton.secondary(
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
                                          : _chooseCampus,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          AppIconButton(
                            icon: const AppLineIconWidget(AppLineIcon.people),
                            tooltip: l10n.mapFriendsToggle,
                            tone: AppIconButtonTone.surface,
                            shape: AppIconButtonShape.circle,
                            onPressed: widget.onFriends,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
