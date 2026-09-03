import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/community/widgets/accent_header_action.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/models/models.dart';
import 'package:rtu_mirea_app/lost_and_found/utils/utils.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/widgets.dart';

class LostFoundView extends StatefulWidget {
  const LostFoundView({
    super.key,
    this.contactLauncher = const UrlLostFoundContactLauncher(),
  });

  final LostFoundContactLauncher contactLauncher;

  @override
  State<LostFoundView> createState() => _LostFoundViewState();
}

class _LostFoundViewState extends State<LostFoundView> {
  LostFoundTab _tab = LostFoundTab.all;

  Future<void> _report() {
    final cubit = context.read<LostFoundCubit>();
    return showAppSheet<void>(
      context,
      title: context.l10n.lostFoundReportTitle,
      subtitle: context.l10n.lostFoundReportSub,
      child: BlocProvider.value(
        value: cubit,
        child: const LostFoundReportSheet(),
      ),
    );
  }

  Future<void> _openItem(LostFoundItem item) {
    final cubit = context.read<LostFoundCubit>();
    return showAppSheet<void>(
      context,
      child: BlocProvider.value(
        value: cubit,
        child: LostFoundItemSheet(
          item: item,
          contactLauncher: widget.contactLauncher,
        ),
      ),
    );
  }

  Future<void> _contact(LostFoundItem item) async {
    final telegram = item.telegramContactInfo ?? '';
    final phone = item.phoneNumberContactInfo ?? '';
    if (item.isMine || (telegram.isEmpty && phone.isEmpty)) {
      return _openItem(item);
    }
    final opened = telegram.isNotEmpty
        ? await widget.contactLauncher.openTelegram(telegram)
        : await widget.contactLauncher(phone);
    if (!opened && mounted) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lostFoundContactOpenError,
      );
    }
  }

  void _onStateChanged(BuildContext context, LostFoundState state) {
    final message = state.status == .failure
        ? context.l10n.lostFoundLoadError
        : context.l10n.lostFoundCleanupWarning;
    showNinjaToast(context, showCheck: false, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return BlocConsumer<LostFoundCubit, LostFoundState>(
      listenWhen: (previous, current) =>
          (previous.status != current.status &&
              current.status == .failure &&
              current.items.isNotEmpty) ||
          previous.cleanupWarningRevision != current.cleanupWarningRevision,
      listener: _onStateChanged,
      builder: (context, state) {
        final cubit = context.read<LostFoundCubit>();
        return Scaffold(
          backgroundColor: colors.canvas,
          body: RefreshIndicator(
            color: colors.accent,
            backgroundColor: colors.surface,
            onRefresh: cubit.load,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: AppInnerHeader(
                    title: l10n.lostFoundTitle,
                    onBack: () => Navigator.of(context).maybePop(),
                    backSemanticsLabel: l10n.back,
                    actions: [
                      accentHeaderAction(
                        onTap: state.isCreating
                            ? null
                            : () => unawaited(_report()),
                        semanticsLabel: l10n.lostFoundReport,
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.screen,
                    AppSpacing.screen,
                    AppSpacing.xxlg,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppSegmentedControl<LostFoundTab>(
                          value: _tab,
                          onCanvas: true,
                          onChanged: (value) => setState(() => _tab = value),
                          options: [
                            AppSegmentedOption(
                              value: LostFoundTab.all,
                              label: l10n.lostFoundTabAll,
                            ),
                            AppSegmentedOption(
                              value: LostFoundTab.found,
                              label: l10n.lostFoundTabFoundShort,
                            ),
                            AppSegmentedOption(
                              value: LostFoundTab.lost,
                              label: l10n.lostFoundTabLostShort,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),
                        LostFoundBody(
                          state: state,
                          tab: _tab,
                          onItemTap: (item) => unawaited(_openItem(item)),
                          onContact: (item) => unawaited(_contact(item)),
                          onRetry: () => unawaited(cubit.load()),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),
                        const LostFoundSecurityCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
