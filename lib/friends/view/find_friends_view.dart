import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/find_friends_cubit.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_discovery.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_my_qr_sheet.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_header.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_results.dart';
import 'package:rtu_mirea_app/friends/view/qr_scan_page.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:share_plus/share_plus.dart';

class FindFriendsView extends StatefulWidget {
  const FindFriendsView({
    this.initialQuery = '',
    this.initialUserId,
    super.key,
  });

  final String initialQuery;
  final String? initialUserId;

  @override
  State<FindFriendsView> createState() => _FindFriendsViewState();
}

class _FindFriendsViewState extends State<FindFriendsView> {
  late final TextEditingController _controller;
  Timer? _debounce;

  String get _myUserId => context.read<AppBloc>().state.user.id;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
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
      const Duration(milliseconds: 350),
      () {
        if (mounted) unawaited(context.read<FindFriendsCubit>().search(query));
      },
    );
  }

  Future<void> _scan() async {
    final userId = await Navigator.of(context).push(QrScanPage.route());
    if (userId == null || !mounted || userId == _myUserId) return;
    final sent = await context.read<FindFriendsCubit>().sendRequest(userId);
    if (!mounted) return;
    if (sent) {
      showNinjaToast(context, message: context.l10n.peopleRequestSent);
    } else {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.error,
      );
    }
  }

  Future<void> _sendRequest(String userId) async {
    final sent = await context.read<FindFriendsCubit>().sendRequest(userId);
    if (mounted && !sent) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.error,
      );
    }
  }

  Future<void> _addWholeGroup() async {
    final allSucceeded = await context.read<FindFriendsCubit>().addWholeGroup();
    if (!mounted) return;
    if (allSucceeded) {
      showNinjaToast(context, message: context.l10n.peopleRequestSent);
    } else {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.error,
      );
    }
  }

  void _showMyQr() {
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.friendsMyQr,
        child: FindFriendsMyQrSheet(userId: _myUserId, onShare: _invite),
      ),
    );
  }

  void _invite() {
    final link = DeepLinks.shareLink('/services/people?add=$_myUserId');
    unawaited(SharePlus.instance.share(ShareParams(text: link.toString())));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            NinjaFindFriendsHeader(
              title: context.l10n.friendsAddTitle,
              closeLabel: context.l10n.friendsClose,
              onClose: () => Navigator.of(context).maybePop(),
            ),
            Padding(
              padding: const .fromLTRB(
                NinjaMetrics.screenPadding,
                8,
                NinjaMetrics.screenPadding,
                14,
              ),
              child: Hero(
                tag: 'find-friends-search',
                child: Material(
                  color: Colors.transparent,
                  child: NinjaInput(
                    controller: _controller,
                    onChanged: _onQueryChanged,
                    placeholder: context.l10n.friendsSearchHint,
                    leadingIcon: AppLineIconWidget(
                      .search,
                      size: 17,
                      color: colors.muted,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<FindFriendsCubit, FindFriendsState>(
                builder: (context, state) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const .only(bottom: 24),
                  child: NinjaStateSwitcher(
                    child: state.hasQuery
                        ? NinjaFindFriendsResults(
                            key: const ValueKey('results'),
                            state: state,
                            selectedUserId: widget.initialUserId,
                          )
                        : FindFriendsDiscovery(
                            key: const ValueKey('discovery'),
                            state: state,
                            onShowQr: _showMyQr,
                            onScan: () => unawaited(_scan()),
                            onSendRequest: (userId) =>
                                unawaited(_sendRequest(userId)),
                            onAddWholeGroup: () => unawaited(_addWholeGroup()),
                            onInvite: _invite,
                            onRetry: () => unawaited(
                              context.read<FindFriendsCubit>().loadInitial(),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animatePageEntrance(),
    );
  }
}
