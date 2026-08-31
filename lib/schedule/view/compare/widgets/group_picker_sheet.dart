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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    setState(() => _searching = true);
    try {
      final response = await widget.repository.searchGroups(query: query);
      if (!mounted) return;
      setState(() {
        _results = response.results;
        _searching = false;
      });
    } on Exception catch (_) {
      if (!mounted) return;
      setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: 4, bottom: 8),
      child: Column(
        mainAxisSize: .min,
        spacing: 12,
        children: [
          NinjaInput(
            controller: _controller,
            autofocus: true,
            placeholder: context.l10n.comparePickerHint,
            leadingIcon: AppLineIconWidget(
              .search,
              size: 17,
              color: context.ninja.muted,
            ),
            onChanged: (query) => unawaited(_search(query)),
          ),
          if (_searching)
            const _GroupPickerResultsSkeleton()
          else
            for (final group in _results.take(8))
              NinjaListCell(
                title: group.name,
                horizontalPadding: 0,
                onTap: () => Navigator.of(context).pop(group),
              ),
        ],
      ),
    );
  }
}
