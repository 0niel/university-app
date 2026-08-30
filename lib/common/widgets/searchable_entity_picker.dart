import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'searchable_entity_picker_skeleton.dart';

class SearchableEntityPicker<T> extends StatefulWidget {
  const SearchableEntityPicker({
    required this.onSearch,
    required this.titleBuilder,
    required this.onManualCreate,
    required this.icon,
    this.subtitleBuilder,
    this.searchHint,
    super.key,
  });

  final Future<List<T>> Function(String query) onSearch;

  final String Function(T item) titleBuilder;

  final String? Function(T item)? subtitleBuilder;

  final T Function(String name) onManualCreate;

  final AppLineIcon icon;

  final String? searchHint;

  @override
  State<SearchableEntityPicker<T>> createState() =>
      _SearchableEntityPickerState<T>();
}

class _SearchableEntityPickerState<T> extends State<SearchableEntityPicker<T>> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<T> _results = const [];
  bool _loading = false;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    setState(() => _query = value.trim());
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => unawaited(_search(value.trim())),
    );
  }

  Future<void> _search(String query) async {
    if (!mounted) return;
    if (query.length < 2) {
      setState(() {
        _results = const [];
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    try {
      final results = await widget.onSearch(query);
      if (!mounted || _query != query) return;
      setState(() => _results = results);
    } on Exception catch (error, stackTrace) {
      log(
        'Entity search failed',
        error: error,
        stackTrace: stackTrace,
        name: 'SearchableEntityPicker',
      );
      if (mounted && _query == query) setState(() => _results = const []);
    } finally {
      if (mounted && _query == query) setState(() => _loading = false);
    }
  }

  void _pick(T item) => Navigator.of(context, rootNavigator: true).pop(item);

  void _addManually() {
    final name = _query.trim();
    if (name.isEmpty) return;
    Navigator.of(
      context,
      rootNavigator: true,
    ).pop<T>(widget.onManualCreate(name));
  }

  bool get _showManual {
    if (_query.isEmpty) return false;
    final lower = _query.toLowerCase();
    return !_results.any(
      (result) => widget.titleBuilder(result).toLowerCase() == lower,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        NinjaInput(
          controller: _controller,
          autofocus: true,
          placeholder: widget.searchHint ?? l10n.pickerSearchHint,
          onChanged: _onQueryChanged,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: _loading && _results.isEmpty
              ? const _SearchableEntityPickerSkeleton()
              : ListView(
                  children: [
                    if (_showManual)
                      NinjaListCell(
                        title: l10n.pickerAddManually(_query),
                        onTap: _addManually,
                      ),
                    for (final item in _results)
                      NinjaListCell(
                        title: widget.titleBuilder(item),
                        subtitle: widget.subtitleBuilder?.call(item),
                        onTap: () => _pick(item),
                      ),
                    if (_query.length >= 2 &&
                        _results.isEmpty &&
                        !_loading &&
                        !_showManual)
                      NinjaEmptyState.screen(
                        title: l10n.pickerNothingFound,
                        icon: NinjaGlyphIcon(
                          NinjaGlyph.search,
                          color: colors.brandInk,
                        ),
                      ).animateEmptyState(),
                  ],
                ),
        ),
      ],
    );
  }
}
