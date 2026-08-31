import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tools/config/tools_links_config.dart';
import 'package:rtu_mirea_app/tools/view/widgets/avatar_stack.dart';
import 'package:rtu_mirea_app/tools/view/widgets/avatar_stack_skeleton.dart';
import 'package:rtu_mirea_app/tools/view/widgets/become_contributor_button.dart';

part 'contributors_shell.dart';

class ContributorsCard extends StatelessWidget {
  const ContributorsCard({required this.onBecomeContributor, super.key});

  final ValueChanged<String> onBecomeContributor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ContributorsBloc, ContributorsState>(
      builder: (context, state) {
        final isLoading = state.status == .loading || state.status == .initial;
        final contributors = state.contributors.contributors;
        final Widget child;
        if (state.status == .failure) {
          child = KeyedSubtree(
            key: const ValueKey('contributors-error'),
            child: NinjaErrorCard(
              title: l10n.errorLoadingContributors,
              message: l10n.tryAgain,
              actionLabel: l10n.retry,
              onAction: () => context.read<ContributorsBloc>().add(
                const ContributorsRequested(),
              ),
            ).animateEmptyState(),
          );
        } else if (isLoading) {
          child = const KeyedSubtree(
            key: ValueKey('contributors-loading'),
            child: _ContributorsShell(loading: true, contributors: []),
          );
        } else if (contributors.isEmpty) {
          child = KeyedSubtree(
            key: const ValueKey('contributors-empty'),
            child: NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.people),
              title: l10n.toolsCommunitySection,
              message: l10n.toolsCommunitySectionSubtitle,
              actionLabel: l10n.toolsBecomeContributor,
              onAction: () => onBecomeContributor(ToolsLinksConfig.repoUrl),
            ).animateEmptyState(),
          );
        } else {
          child = KeyedSubtree(
            key: const ValueKey('contributors-ready'),
            child: _ContributorsShell(
              loading: false,
              contributors: contributors,
              onBecomeContributor: onBecomeContributor,
            ),
          );
        }
        return NinjaStateSwitcher(child: child);
      },
    );
  }
}
