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
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final modeBarHeight = (60 + (textScale - 1) * 18).clamp(60, 80).toDouble();
    final toolbarHeight = (68 + (textScale - 1) * 20).clamp(68, 88).toDouble();

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
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              toolbarHeight: toolbarHeight,
              titleSpacing: NinjaMetrics.screenPadding,
              backgroundColor: context.ninja.canvas,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              scrolledUnderElevation: 0,
              title: Row(
                children: [
                  Expanded(
                    child: SearchTextField(
                      key: const Key('searchPage_searchTextField'),
                      controller: _controller,
                      autofocus: (widget.query ?? '').isEmpty,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  NinjaButton.text(
                    label: l10n.cancel,
                    size: NinjaButtonSize.small,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(modeBarHeight),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.lg),
                  child: SearchModeSelect(),
                ),
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
