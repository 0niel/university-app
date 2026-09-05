import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_results.dart';
import 'package:rtu_mirea_app/search/view/search_zero_state.dart';
import 'package:rtu_mirea_app/search/widgets/widgets.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, this.query});

  final String? query;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _scrollKey = GlobalKey<NestedScrollViewState>();
  late final TextEditingController _controller = TextEditingController(
    text: widget.query,
  );
  late final VoidCallback _onQueryChanged;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = _controller.text;
    _onQueryChanged = () {
      context.read<SearchBloc>().add(
        SearchQueryChanged(searchQuery: _controller.text),
      );
      setState(() => _query = _controller.text);
      final scroll = _scrollKey.currentState;
      if (scroll?.outerController.hasClients ?? false) {
        scroll!.outerController.jumpTo(0);
      }
    };
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    _controller
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.status == .failure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            NinjaToastHost.maybeOf(context)?.show(
              NinjaToastData(message: l10n.searchFailed, showCheck: false),
            );
          });
        }
      },
      builder: (context, state) {
        return NestedScrollView(
          key: _scrollKey,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  math.max(
                    AppSpacing.screenTop,
                    MediaQuery.paddingOf(context).top + AppSpacing.md,
                  ),
                  AppSpacing.screen,
                  AppSpacing.lg,
                ),
                child: _SearchControls(
                  controller: _controller,
                  autofocus: (widget.query ?? '').isEmpty,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.lg),
                child: SearchModeSelect(),
              ),
            ),
          ],
          body: NinjaStateSwitcher(
            child: _query.trim().isEmpty
                ? SearchZeroState(
                    key: const ValueKey('search-zero'),
                    state: state,
                    onQuerySelected: _setQuery,
                  )
                : SearchResults(
                    key: const ValueKey('search-results'),
                    state: state,
                    query: _query.trim(),
                    onQuerySelected: _setQuery,
                  ),
          ),
        );
      },
    );
  }
}

class _SearchControls extends StatelessWidget {
  const _SearchControls({required this.controller, required this.autofocus});

  static const double _minFieldWidth = 160;

  final TextEditingController controller;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.cancel;
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: label, style: AppButtonSize.small.textStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          locale: Localizations.maybeLocaleOf(context),
          maxLines: 1,
        )..layout();
        final cancelWidth =
            painter.width + AppButtonSize.small.horizontalPadding * 2;
        painter.dispose();
        final stacked =
            constraints.maxWidth - cancelWidth - AppSpacing.sm < _minFieldWidth;
        final field = SearchTextField(
          key: const Key('searchPage_searchTextField'),
          controller: controller,
          autofocus: autofocus,
        );
        final cancel = AppButton.text(
          label: label,
          size: AppButtonSize.small,
          onPressed: () => Navigator.of(context).maybePop(),
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              field,
              const SizedBox(height: AppSpacing.sm),
              Align(alignment: AlignmentDirectional.centerEnd, child: cancel),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: field),
            const SizedBox(width: AppSpacing.sm),
            cancel,
          ],
        );
      },
    );
  }
}
