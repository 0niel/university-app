import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GroupSpaceMembersSection extends StatelessWidget {
  const GroupSpaceMembersSection({
    required this.members,
    required this.onOpenMember,
    super.key,
  });

  final List<GroupSpaceMember> members;
  final ValueChanged<GroupSpaceMember> onOpenMember;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Wrap(
        spacing: 14,
        runSpacing: 12,
        children: [
          for (final member in members)
            AppPressable(
              onTap: () => onOpenMember(member),
              semanticsLabel: member.fullName,
              child: SizedBox(
                width: 68,
                child: Column(
                  children: [
                    AppAvatar(name: member.fullName, size: 52),
                    const SizedBox(height: 6),
                    Text(
                      member.isMe
                          ? context.l10n.studyGroupYouTag
                          : member.fullName.split(' ').first,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppText.captionSmall.copyWith(
                        color: context.colors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (member.isOwner)
                      Text(
                        context.l10n.studyGroupOwnerTag,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.microBold.copyWith(
                          color: context.colors.accent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
