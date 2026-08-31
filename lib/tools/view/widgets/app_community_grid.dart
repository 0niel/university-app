import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tools/config/tools_links_config.dart';
import 'package:rtu_mirea_app/tools/view/widgets/app_community_card.dart';
import 'package:unicons/unicons.dart';

class AppCommunityGrid extends StatelessWidget {
  const AppCommunityGrid({
    required this.chatUrl,
    required this.onOpen,
    super.key,
  });

  final String? chatUrl;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cards = [
      AppCommunityCard(
        icon: const Icon(UniconsLine.github),
        title: 'GitHub',
        subtitle: l10n.toolsCardGithubSubtitle,
        onTap: () => onOpen(ToolsLinksConfig.repoUrl),
      ),
      if (chatUrl case final String value)
        AppCommunityCard(
          icon: const Icon(UniconsLine.telegram),
          title: l10n.toolsCardChatTitle,
          subtitle: l10n.toolsCardChatSubtitle,
          onTap: () => onOpen(value),
        ),
      AppCommunityCard(
        icon: const AppLineIconWidget(.spark),
        title: l10n.toolsCardRoadmapTitle,
        subtitle: l10n.toolsCardRoadmapSubtitle,
        onTap: () => onOpen(ToolsLinksConfig.roadmapUrl),
      ),
      AppCommunityCard(
        icon: const AppLineIconWidget(.bolt),
        title: l10n.toolsCardBugTitle,
        subtitle: l10n.toolsCardBugSubtitle,
        onTap: () => onOpen(ToolsLinksConfig.issuesUrl),
      ),
    ];

    return Column(
      spacing: 10,
      children: cards,
    );
  }
}
