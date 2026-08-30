part of '../view/onboarding_page.dart';

bool get _supportsNotifications => !kIsWeb;

class _PermissionsStep extends StatefulWidget {
  const _PermissionsStep({
    required this.permissionClient,
    required this.onBack,
    required this.onFinish,
    super.key,
  });

  final PermissionClient permissionClient;
  final VoidCallback onBack;
  final VoidCallback onFinish;

  @override
  State<_PermissionsStep> createState() => _PermissionsStepState();
}

class _PermissionsStepState extends State<_PermissionsStep>
    with WidgetsBindingObserver {
  var _notificationsGranted = false;
  var _locationGranted = false;
  var _requestingNotifications = false;
  var _requestingLocation = false;
  var _statusesLoaded = false;
  var _statusRequest = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadStatuses());
  }

  @override
  void dispose() {
    _statusRequest++;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == .resumed) unawaited(_loadStatuses());
  }

  Future<void> _loadStatuses() async {
    final request = ++_statusRequest;
    try {
      final notificationsGranted =
          _supportsNotifications &&
          await context.read<LocalNotificationsRepository>().hasPermission();
      final location = await widget.permissionClient.locationWhenInUseStatus();
      if (!mounted || request != _statusRequest) return;
      setState(() {
        _notificationsGranted = notificationsGranted;
        _locationGranted = location.isGranted;
        _statusesLoaded = true;
      });
    } on Exception catch (error, stackTrace) {
      log(
        'Permission status load failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingPermissionsStep',
      );
      if (mounted) setState(() => _statusesLoaded = true);
    }
  }

  Future<void> _requestNotifications() async {
    if (!_supportsNotifications || _requestingNotifications) return;
    _statusRequest++;
    setState(() => _requestingNotifications = true);
    try {
      final granted = await context
          .read<LocalNotificationsRepository>()
          .ensurePermission();
      if (!mounted) return;
      setState(() => _notificationsGranted = granted);
    } on Exception catch (error, stackTrace) {
      log(
        'Notification permission request failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingPermissionsStep',
      );
    } finally {
      if (mounted) setState(() => _requestingNotifications = false);
    }
  }

  Future<void> _requestLocation() async {
    if (_requestingLocation) return;
    _statusRequest++;
    setState(() => _requestingLocation = true);
    try {
      final permission = await widget.permissionClient
          .requestLocationWhenInUse();
      if (!mounted) return;
      setState(() => _locationGranted = permission.isGranted);
    } on Exception catch (error, stackTrace) {
      log(
        'Location permission request failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingPermissionsStep',
      );
    } finally {
      if (mounted) setState(() => _requestingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _OnboardStep(
      step: 3,
      total: 3,
      showBack: true,
      onBack: widget.onBack,
      ctaLabel: l10n.onboardingPermCta,
      onCta: widget.onFinish,
      child: _PermissionsStepBody(
        notificationsGranted: _notificationsGranted,
        locationGranted: _locationGranted,
        showNotifications: _supportsNotifications,
        loading: !_statusesLoaded,
        onRequestNotifications: () {
          unawaited(_requestNotifications());
        },
        onRequestLocation: () {
          unawaited(_requestLocation());
        },
      ),
    );
  }
}
