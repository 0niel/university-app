import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/university_modules/app_university_modules.dart';
import 'package:rtu_mirea_app/university_modules/module_account_page.dart';
import 'package:rtu_mirea_app/university_modules/module_unavailable_page.dart';
import 'package:university_modules/university_modules.dart';

class UniversityModulePage extends StatelessWidget {
  const UniversityModulePage({
    required this.moduleId,
    super.key,
    this.registry,
  });

  final String moduleId;
  final ModuleRegistry? registry;

  @override
  Widget build(BuildContext context) {
    final config = context.read<UniversityConfig>();
    final module = (registry ?? AppUniversityModules.registry).find(
      moduleId,
      organizationId: config.organizationId,
    );
    if (module == null) return const ModuleUnavailablePage();
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) =>
          previous.user.id != current.user.id ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.user.id.isEmpty || state.status != .authenticated) {
          return const ModuleUnavailablePage(signInRequired: true);
        }
        return ModuleAccountPage(
          key: ValueKey((moduleId, config.organizationId, state.user.id)),
          module: module,
          config: config,
          accountId: state.user.id,
        );
      },
    );
  }
}
