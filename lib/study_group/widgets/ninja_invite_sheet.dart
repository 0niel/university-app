import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:share_plus/share_plus.dart';

part 'invite_circle_action.dart';
part 'ninja_invite_search_result_card.dart';
part 'ninja_invite_search_results_skeleton.dart';

class NinjaInviteSheet extends StatefulWidget {
  const NinjaInviteSheet({
    required this.groupName,
    required this.joinCode,
    required this.onSearch,
    required this.onInvite,
    super.key,
  });

  final String groupName;

  final String joinCode;

  final Future<List<UserSearchResult>> Function(String query) onSearch;

  final Future<bool> Function(String userId) onInvite;

  @override
  State<NinjaInviteSheet> createState() => _NinjaInviteSheetState();
}

class _NinjaInviteSheetState extends State<NinjaInviteSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<UserSearchResult> _results = const [];
  final _invited = <String>{};
  bool _searching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Uri get _link =>
      DeepLinks.shareLink('/services/people?joinGroup=${widget.joinCode}');

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => unawaited(_search(query.trim())),
    );
  }

  Future<void> _search(String query) async {
    if (!mounted || query.length < 2) {
      if (mounted) setState(() => _results = const []);
      return;
    }
    setState(() => _searching = true);
    try {
      final results = await widget.onSearch(query);
      if (mounted) setState(() => _results = results);
    } on Exception catch (error, stackTrace) {
      log(
        'User search failed',
        error: error,
        stackTrace: stackTrace,
        name: 'NinjaInviteSheet',
      );
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _invite(String userId) async {
    setState(() => _invited.add(userId));
    final ok = await widget.onInvite(userId);
    if (!ok && mounted) {
      setState(() => _invited.remove(userId));
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.studyGroupInviteError,
      );
    }
  }

  void _copyCode() => unawaited(_copyCodeToClipboard());

  Future<void> _copyCodeToClipboard() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.joinCode));
    } on Exception catch (error, stackTrace) {
      log(
        'Study group code copy failed',
        error: error,
        stackTrace: stackTrace,
        name: 'NinjaInviteSheet',
      );
      return;
    }
    if (!mounted) return;
    showNinjaToast(
      context,
      message: context.l10n.studyGroupCodeCopied,
    );
  }

  void _shareLink() => unawaited(_shareLinkWithSystem());

  Future<void> _shareLinkWithSystem() async {
    final text = context.l10n.studyGroupShareCodeText(
      widget.groupName,
      widget.joinCode,
      _link.toString(),
    );
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } on Exception catch (error, stackTrace) {
      log(
        'Study group link share failed',
        error: error,
        stackTrace: stackTrace,
        name: 'NinjaInviteSheet',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final hasQuery = _controller.text.trim().length >= 2;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Container(
          padding: const .all(16),
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: .circular(AppRadius.card),
          ),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: AppPressable(
                  onTap: _copyCode,
                  semanticsLabel:
                      '${l10n.studyGroupShareCode} '
                      '${widget.joinCode}',
                  semanticsButton: true,
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        l10n.studyGroupShareCode,
                        style: AppText.captionSmall.copyWith(
                          color: colors.muted,
                        ),
                      ),
                      Text(
                        widget.joinCode,
                        style: AppText.tabular(
                          AppText.title.copyWith(color: colors.ink),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InviteCircleAction(
                icon: .share,
                tooltip: l10n.share,
                onTap: _shareLink,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.studyGroupInviteByLink,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
        const SizedBox(height: 28),
        NinjaInput(
          controller: _controller,
          onChanged: _onQueryChanged,
          placeholder: l10n.studyGroupInviteSearchHint,
          leadingIcon: AppLineIconWidget(
            .search,
            size: 17,
            color: colors.muted,
          ),
        ),
        const SizedBox(height: 14),
        NinjaStateSwitcher(
          child: _resultsSection(context, hasQuery: hasQuery),
        ),
      ],
    );
  }

  Widget _resultsSection(BuildContext context, {required bool hasQuery}) {
    if (_searching) {
      return const _NinjaInviteSearchResultsSkeleton(key: ValueKey('loading'));
    }
    if (!hasQuery) return const SizedBox.shrink(key: ValueKey('idle'));
    if (_results.isEmpty) {
      final colors = context.colors;
      final l10n = context.l10n;
      return NinjaEmptyState(
        icon: AppLineIconWidget(
          AppLineIcon.search,
          size: 20,
          color: colors.muted,
        ),
        title: l10n.studyGroupInviteNoneFound,
        message: l10n.studyGroupInviteNoneFoundSub,
      ).animateEmptyState(key: const ValueKey('empty'));
    }
    return ConstrainedBox(
      key: const ValueKey('results'),
      constraints: const BoxConstraints(maxHeight: 320),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final user = _results[index];
          final group = user.group;
          return NinjaInviteSearchResultCard(
            name: user.fullName,
            subtitle: [
              if (user.handle != null) '@${user.handle}',
              ?group,
            ].join(' · '),
            invited: _invited.contains(user.userId),
            onInvite: () => _invite(user.userId),
          ).animateListItem(index: index);
        },
      ),
    );
  }
}
