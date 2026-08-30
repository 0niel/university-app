import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/community_page_header.dart';

class NinjaCommunityHeader extends StatelessWidget {
  const NinjaCommunityHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CommunityPageHeader(
        title: title,
        subtitle: subtitle,
        actions: [?trailing],
      ),
    );
  }
}
