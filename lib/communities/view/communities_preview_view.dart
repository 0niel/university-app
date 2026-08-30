import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CommunitiesPreviewView extends StatelessWidget {
  const CommunitiesPreviewView({super.key});

  Future<void> _retry(BuildContext context) =>
      context.read<CommunityCatalogCubit>().load(
        locale: Localizations.localeOf(context).toLanguageTag(),
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      children: [
        Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            0,
            NinjaMetrics.screenPadding,
            4,
          ),
          child: Row(
            crossAxisAlignment: .baseline,
            textBaseline: .alphabetic,
            children: [
              Expanded(
                child: Text(
                  context.l10n.communitiesTitle,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.title.copyWith(color: colors.ink),
                ),
              ),
              const SizedBox(width: 10),
              AppPressable(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AllCommunitiesPage(),
                  ),
                ),
                semanticsLabel: context.l10n.communitiesAll,
                semanticsButton: true,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: NinjaMetrics.minTouchTarget,
                  ),
                  alignment: .center,
                  padding: const .symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: .circular(NinjaRadius.pill),
                  ),
                  child: Text(
                    context.l10n.communitiesAll,
                    style: NinjaText.buttonSmall.copyWith(color: colors.ink),
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<CommunityCatalogCubit, CommunityCatalogState>(
          builder: (context, state) => NinjaStateSwitcher(
            child: switch (state.status) {
              .initial || .loading => const NinjaCommunityCatalogSkeleton(
                key: ValueKey('preview-loading'),
                compact: true,
              ),
              .failure => NinjaCommunityCatalogError(
                key: const ValueKey('preview-failure'),
                onRetry: () => unawaited(_retry(context)),
              ),
              .success => CommunitiesPreviewContent(
                key: const ValueKey('preview-content'),
                state: state,
              ),
            },
          ),
        ),
      ],
    );
  }
}
