import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/study_group/view/ninja_discover_study_group_card.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

part 'discover_placeholder.dart';
part 'ninja_discover_groups_skeleton.dart';

class DiscoverGroupsPage extends StatefulWidget {
  const DiscoverGroupsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const DiscoverGroupsPage());
  }

  @override
  State<DiscoverGroupsPage> createState() => _DiscoverGroupsPageState();
}

class _DiscoverGroupsPageState extends State<DiscoverGroupsPage> {
  late final StudyGroupsRepository _repository = context
      .read<StudyGroupsRepository>();
  final _controller = TextEditingController();
  Timer? _debounce;
  List<StudyGroupSummary> _results = const [];
  final _requested = <String>{};
  bool _loading = true;
  bool _error = false;
  String _lastQuery = '';
  var _searchGeneration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _search(''));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => unawaited(_search(query)),
    );
  }

  Future<void> _search(String query) async {
    final generation = ++_searchGeneration;
    _lastQuery = query;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final results = await _repository.searchGroups(query.trim());
      if (!mounted || generation != _searchGeneration) return;
      setState(() => _results = results);
    } on Exception catch (e, st) {
      log(
        'searchGroups failed',
        error: e,
        stackTrace: st,
        name: 'DiscoverGroupsPage',
      );
      if (!mounted || generation != _searchGeneration) return;
      setState(() {
        _results = const [];
        _error = true;
      });
    } finally {
      if (mounted && generation == _searchGeneration) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _request(StudyGroupSummary group) async {
    setState(() => _requested.add(group.id));
    try {
      await _repository.requestToJoin(group.id);
      if (mounted) {
        showNinjaToast(
          context,
          message: context.l10n.studyGroupRequested,
        );
      }
    } on Exception catch (e, st) {
      log(
        'requestToJoin failed',
        error: e,
        stackTrace: st,
        name: 'DiscoverGroupsPage',
      );
      if (mounted) {
        setState(() => _requested.remove(group.id));
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.studyGroupRequestError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          spacing: 12,
          children: [
            CommunityPageHeader(
              title: l10n.studyGroupDiscoverTitle,
              subtitle: l10n.studyGroupDiscoverSubtitle,
            ),
            Padding(
              padding: const .symmetric(
                horizontal: NinjaMetrics.screenPadding,
              ),
              child: NinjaInput(
                controller: _controller,
                onChanged: _onQueryChanged,
                placeholder: l10n.studyGroupDiscoverSearchHint,
                leadingIcon: AppLineIconWidget(
                  .search,
                  size: 17,
                  color: colors.muted,
                ),
              ),
            ),
            Expanded(child: NinjaStateSwitcher(child: _body(context))),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final l10n = context.l10n;
    if (_loading) {
      return const _NinjaDiscoverGroupsSkeleton(key: ValueKey('loading'));
    }
    if (_error && _results.isEmpty) {
      return _DiscoverPlaceholder(
        key: const ValueKey('error'),
        child: NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () => unawaited(_search(_lastQuery)),
        ),
      );
    }
    if (_results.isEmpty) {
      final colors = context.ninja;
      return _DiscoverPlaceholder(
        key: const ValueKey('empty'),
        child: NinjaEmptyState.screen(
          icon: AppLineIconWidget(
            AppLineIcon.search,
            size: 42,
            color: colors.muted,
          ),
          title: l10n.studyGroupDiscoverEmptyTitle,
          message: l10n.studyGroupDiscoverEmptySubtitle,
        ),
      );
    }
    return ListView.builder(
      key: const ValueKey('results'),
      padding: const .only(bottom: 32),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final group = _results[index];
        return NinjaDiscoverStudyGroupCard(
          group: group,
          requested: group.hasRequested || _requested.contains(group.id),
          onRequest: () => _request(group),
        ).animateListItem(index: index);
      },
    );
  }
}
