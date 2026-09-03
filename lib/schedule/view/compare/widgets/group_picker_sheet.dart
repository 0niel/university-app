part of '../compare_page.dart';

class _GroupPickerSheet extends StatefulWidget {
  const _GroupPickerSheet({required this.repository});

  final ScheduleRepository repository;

  @override
  State<_GroupPickerSheet> createState() => _GroupPickerSheetState();
}

class _GroupPickerSheetState extends State<_GroupPickerSheet> {
  final _controller = TextEditingController();
  List<Group> _results = const [];
  bool _searching = false;
  bool _error = false;
  int _revision = 0;
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final revision = ++_revision;
    if (query.trim().isEmpty) {
      setState(() {
        _results = const [];
        _searching = false;
        _error = false;
      });
      return;
    }
    setState(() {
      _searching = true;
      _error = false;
    });
    try {
      final response = await widget.repository.searchGroups(
        query: query.trim(),
      );
      if (!mounted || revision != _revision) return;
      setState(() {
        _results = response.results;
        _searching = false;
      });
    } on Exception catch (_) {
      if (!mounted || revision != _revision) return;
      setState(() {
        _searching = false;
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: 4, bottom: 8),
      child: Column(
        mainAxisSize: .min,
        spacing: AppSpacing.md,
        children: [
          AppInputField(
            controller: _controller,
            autofocus: true,
            placeholder: context.l10n.comparePickerHint,
            leading: AppLineIconWidget(
              .search,
              size: 17,
              color: context.colors.muted,
            ),
            onChanged: (query) {
              _debounce?.cancel();
              _revision++;
              if (query.trim().isEmpty) {
                unawaited(_search(query));
              } else {
                setState(() {
                  _searching = true;
                  _error = false;
                });
                _debounce = Timer(
                  const Duration(milliseconds: 250),
                  () => unawaited(_search(query)),
                );
              }
            },
          ),
          if (_searching)
            const _GroupPickerResultsSkeleton()
          else if (_error)
            AppErrorState(
              title: context.l10n.loadingError,
              message: context.l10n.tryAgain,
              primaryLabel: context.l10n.retry,
              onPrimary: () => _search(_controller.text),
              footnote: null,
            )
          else if (_controller.text.trim().isNotEmpty && _results.isEmpty)
            AppEmptyState(
              title: context.l10n.pickerNothingFound,
              subtitle: context.l10n.comparePickerDescription,
            )
          else
            for (final group in _results)
              AppListRow(
                title: group.name,
                onTap: () => Navigator.of(context).pop(group),
              ),
        ],
      ),
    );
  }
}
