import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/apps.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/drawer_destination.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/src/widgets/image.dart';
import 'package:neon_framework/src/widgets/linear_progress_indicator.dart';
import 'package:nextcloud/core.dart' as core;

/// A custom pre populated [Drawer] side panel.
///
/// Displays an entry for every registered and supported client and one for
/// the settings page.
@internal
class NeonDrawer extends StatefulWidget {
  /// Created a new Neon drawer.
  const NeonDrawer({
    super.key,
  });

  @override
  State<NeonDrawer> createState() => _NeonDrawerState();
}

class _NeonDrawerState extends State<NeonDrawer> {
  late AccountsBloc _accountsBloc;
  late AppsBloc _appsBloc;
  List<AppImplementation>? _apps;
  int? _activeApp;

  @override
  void initState() {
    super.initState();

    _accountsBloc = NeonProvider.of<AccountsBloc>(context);
    _appsBloc = _accountsBloc.activeAppsBloc;

    _appsBloc.appImplementations.listen((result) {
      setState(() {
        _apps = result.data?.toList();
        _activeApp = _apps?.indexWhere((app) => app.id == _appsBloc.activeApp.valueOrNull?.id);
      });
    });
  }

  void onAppChange(int index) {
    Scaffold.maybeOf(context)?.closeDrawer();

    // selected item is not a registered app like the SettingsPage
    if (index >= (_apps?.length ?? 0)) {
      const SettingsRoute().go(context);
      return;
    }

    setState(() {
      _activeApp = index;
    });

    _appsBloc.setActiveApp(_apps![index].id);
    //context.goNamed(apps[index].routeName);
  }

  @override
  Widget build(BuildContext context) {
    final appDestinations = _apps?.map(
      (app) => NavigationDrawerDestinationExtension.fromNeonDestination(
        app.destination(context),
      ),
    );

    final drawer = NavigationDrawer(
      selectedIndex: _activeApp,
      onDestinationSelected: onAppChange,
      children: [
        const NeonDrawerHeader(),
        ...?appDestinations,
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings),
          label: Text(NeonLocalizations.of(context).settings),
        ),
      ],
    );

    return drawer;
  }
}

/// Custom styled [DrawerHeader] used inside a [Drawer] or [NeonDrawer].
///
/// The neon drawer will display the [core.ThemingPublicCapabilities_Theming.name]
/// and [core.ThemingPublicCapabilities_Theming.logo] and automatically rebuild
/// when the current theme changes.
@internal
class NeonDrawerHeader extends StatelessWidget {
  /// Creates a new Neon drawer header.
  const NeonDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final capabilitiesBloc = accountsBloc.activeCapabilitiesBloc;

    final branding = ResultBuilder<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>.behaviorSubject(
      subject: capabilitiesBloc.capabilities,
      builder: (context, capabilities) {
        if (!capabilities.hasData) {
          return NeonLinearProgressIndicator(
            visible: capabilities.isLoading,
          );
        }

        if (capabilities.hasError) {
          return NeonError(
            capabilities.error,
            onRetry: capabilitiesBloc.refresh,
          );
        }

        final theme = capabilities.requireData.capabilities.themingPublicCapabilities?.theming;

        if (theme == null) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              theme.name,
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            Flexible(
              child: NeonUrlImage(
                uri: Uri.parse(theme.logo),
              ),
            ),
          ],
        );
      },
    );

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: branding,
    );
  }
}
