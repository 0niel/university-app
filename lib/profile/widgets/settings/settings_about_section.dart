import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/about_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({
    required this.version,
    required this.onOpenRepository,
    super.key,
  });

  final String? version;
  final VoidCallback onOpenRepository;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      label: context.l10n.aboutApp,
      children: [
        AboutSection(
          appName: context.read<UniversityConfig>().appName,
          version: version,
          onOpenRepository: onOpenRepository,
          onTap: () => unawaited(context.push('/profile/about')),
        ),
      ],
    );
  }
}
