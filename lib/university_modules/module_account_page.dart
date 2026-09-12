import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/university_modules/app_module_host.dart';
import 'package:rtu_mirea_app/university_modules/module_scoped_storage.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:university_modules/university_modules.dart';

class ModuleAccountPage extends StatefulWidget {
  const ModuleAccountPage({
    required this.module,
    required this.config,
    required this.accountId,
    super.key,
  });

  final UniversityModule module;
  final UniversityConfig config;
  final String accountId;

  @override
  State<ModuleAccountPage> createState() => _ModuleAccountPageState();
}

class _ModuleAccountPageState extends State<ModuleAccountPage> {
  AppModuleHost? _host;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_host != null) return;
    final appBloc = context.read<AppBloc>();
    final digitalPassAvailable =
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        widget.config.isEnabled(.nfcPass);
    _host = AppModuleHost(
      organizationId: widget.config.organizationId,
      accountId: widget.accountId,
      digitalPassAvailable: digitalPassAvailable,
      storage: ModuleScopedStorage(
        storage: const SecureStorage(),
        organizationId: widget.config.organizationId,
        accountId: widget.accountId,
        moduleId: widget.module.descriptor.id,
        isAccountActive: () =>
            mounted &&
            !appBloc.isClosed &&
            appBloc.state.status == .authenticated &&
            appBloc.state.user.id == widget.accountId,
      ),
      setDigitalPassSession: digitalPassAvailable
          ? context.read<NfcPassRepository>().setSessionCookie
          : null,
      clearDigitalPassSession: digitalPassAvailable
          ? context.read<NfcPassRepository>().clearSessionCookie
          : null,
      clearDigitalPassBinding: digitalPassAvailable
          ? context.read<NfcPassRepository>().unbindPass
          : null,
    );
  }

  @override
  Widget build(BuildContext context) => widget.module.build(_host!);
}
