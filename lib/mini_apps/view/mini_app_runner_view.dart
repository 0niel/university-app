part of 'mini_app_runner_page.dart';

class _MiniAppRunnerView extends StatefulWidget {
  const _MiniAppRunnerView({required this.slug, this.initialPage});
  final String slug;
  final String? initialPage;

  @override
  State<_MiniAppRunnerView> createState() => _MiniAppRunnerViewState();
}

class _MiniAppRunnerViewState extends State<_MiniAppRunnerView> {
  MiniAppSession? _session;
  bool _initialPageOpened = false;

  @override
  void initState() {
    super.initState();
    _session = MiniAppSession(slug: widget.slug, host: _RunnerHost(this));
    MiniAppSessionStack.push(_session!);
  }

  @override
  void dispose() {
    final session = _session;
    if (session != null) MiniAppSessionStack.pop(session);
    super.dispose();
  }

  Future<void> _openInnerPage(String path, String? title) async {
    final cubit = context.read<MiniAppRunnerCubit>();
    final appName = cubit.state.app?.name ?? '';
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: MiniAppInnerScreen(path: path, title: title ?? appName),
        ),
      ),
    );
  }

  void _close() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go('/services/apps');
    }
  }

  Future<void> _about(MiniApp app) async {
    final cubit = context.read<MiniAppRunnerCubit>();
    await showAppSheet<void>(
      context,
      title: app.name,
      child: MiniAppAboutSheet(
        app: app,
        onRate: cubit.rate,
        onPermissionsChanged: cubit.updateConsents,
      ),
    );
  }

  Future<void> _report() async {
    final cubit = context.read<MiniAppRunnerCubit>();
    final sent = await showAppSheet<bool>(
      context,
      title: context.l10n.miniAppsReportTitle,
      subtitle: context.l10n.miniAppsReportSubtitle,
      child: MiniAppReportSheet(onSubmit: cubit.report),
    );
    if (sent == true && mounted) {
      showNinjaToast(context, message: context.l10n.miniAppsReportSent);
    }
  }

  void _onReady() {
    final page = widget.initialPage;
    if (page == null || _initialPageOpened) return;
    _initialPageOpened = true;
    unawaited(_openInnerPage(page, null));
  }

  Future<void> _askConsent(MiniApp app) async {
    final scopes = await showAppSheet<List<MiniAppPermission>>(
      context,
      title: context.l10n.miniAppsConsentTitle(app.name),
      subtitle: context.l10n.miniAppsConsentSubtitle,
      child: MiniAppConsentSheet(app: app),
    );
    if (!mounted) return;
    if (scopes == null) {
      _close();
    } else {
      await context.read<MiniAppRunnerCubit>().applyConsents(scopes);
    }
  }

  void _onStatus(BuildContext _, MiniAppRunnerState state) {
    if (state.status == .ready) {
      _onReady();
    } else if (state.status == .consentRequired) {
      final app = state.app;
      if (app != null) unawaited(_askConsent(app));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return BlocConsumer<MiniAppRunnerCubit, MiniAppRunnerState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == .ready || current.status == .consentRequired),
      listener: _onStatus,
      builder: (context, state) {
        final app = state.app;
        return Scaffold(
          backgroundColor: colors.canvas,
          appBar: _RunnerAppBar(
            title: app?.name ?? '',
            onBack: _close,
            onMenu: app == null ? null : () => unawaited(_openMenu(app)),
          ),
          body: MiniAppRunnerBody(state: state),
        );
      },
    );
  }

  Future<void> _openMenu(MiniApp app) async {
    final l10n = context.l10n;
    final action = await showAppSheet<String>(
      context,
      title: app.name,
      child: Column(
        mainAxisSize: .min,
        children: [
          for (final (value, label) in <(String, String)>[
            ('reload', l10n.miniAppsReload),
            ('about', l10n.miniAppsAbout),
            if (!app.isOwner) ('report', l10n.miniAppsReport),
            ('close', l10n.miniAppsClose),
          ])
            Builder(
              builder: (sheetContext) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppPressable(
                  onTap: () => Navigator.of(sheetContext).pop(value),
                  semanticsLabel: label,
                  semanticsButton: true,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: sheetContext.ninja.surface,
                      borderRadius: BorderRadius.circular(NinjaRadius.card),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: NinjaMetrics.minTouchTarget,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Text(
                          label,
                          style: NinjaText.body.copyWith(
                            color: sheetContext.ninja.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    if (action == null || !mounted) return;
    _onMenuAction(action, app);
  }

  void _onMenuAction(String action, MiniApp app) {
    switch (action) {
      case 'reload':
        unawaited(context.read<MiniAppRunnerCubit>().load());
      case 'about':
        unawaited(_about(app));
      case 'report':
        unawaited(_report());
      case 'close':
        _close();
    }
  }
}

class _RunnerHost extends MiniAppHost {
  const _RunnerHost(this._state);

  final _MiniAppRunnerViewState _state;

  @override
  Future<void> openLocation(String location) async {
    final normalized = DeepLinks.normalizeLocation(location);
    if (normalized == null || !_state.mounted) return;
    _state.context.go(normalized);
  }

  @override
  Future<void> openExternalUrl(Uri url) async {
    await launchUrl(url, mode: .externalApplication);
  }

  @override
  Future<void> openPage({required String path, String? title}) async {
    if (!_state.mounted) return;
    await _state._openInnerPage(path, title);
  }

  @override
  Future<void> openMiniApp({required String slug, String? path}) async {
    if (!_state.mounted) return;
    final query = path == null ? '' : '?page=${Uri.encodeComponent(path)}';
    _state.context.go('/services/apps/$slug/run$query');
  }

  @override
  Future<void> reload() async {
    if (!_state.mounted) return;
    await _state.context.read<MiniAppRunnerCubit>().load();
  }

  @override
  Future<void> setStorage(String key, Object? value) async {
    if (!_state.mounted) return;
    await _state.context.read<MiniAppRunnerCubit>().setStorageValue(key, value);
  }

  @override
  Future<Object?> fetch({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? query,
    Object? body,
  }) async {
    if (!_state.mounted) return null;
    try {
      return await _state.context.read<MiniAppsRepository>().callApi(
        slug: _state.widget.slug,
        path: path,
        method: method,
        query: query?.map((key, value) => MapEntry(key, '$value')),
        body: body,
      );
    } on Exception {
      return null;
    }
  }

  @override
  Future<Map<String, double>?> getLocation() async {
    if (!await _ensureScope(.location)) return null;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var permission = await Geolocator.checkPermission();
      if (permission == .denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == .denied || permission == .deniedForever) {
        return null;
      }
      final position = await Geolocator.getCurrentPosition();
      return {
        'lat': position.latitude,
        'lng': position.longitude,
        'accuracy': position.accuracy,
      };
    } on Exception {
      return null;
    }
  }

  @override
  Future<String?> pickImage({required bool fromCamera}) async {
    if (!await _ensureScope(.camera)) return null;
    try {
      final file = await ImagePicker().pickImage(
        source: fromCamera ? .camera : .gallery,
        maxWidth: 1600,
        imageQuality: 75,
      );
      if (file == null || !_state.mounted) return null;
      final cubit = _state.context.read<MiniAppRunnerCubit>();
      final appId = cubit.state.app?.id;
      if (appId == null) return null;
      final bytes = await file.readAsBytes();
      if (!_state.mounted) return null;
      return await _state.context.read<MiniAppsRepository>().uploadImage(
        appId: appId,
        bytes: bytes,
        fileName: file.name,
        contentType: file.mimeType,
      );
    } on Exception {
      return null;
    }
  }

  @override
  Future<String?> scanCode() async {
    if (!await _ensureScope(.camera) || !_state.mounted) {
      return null;
    }
    return Navigator.of(_state.context).push(MiniAppScanPage.route());
  }

  @override
  Future<Map<String, String>?> pickFile() async {
    if (!await _ensureScope(.files)) return null;
    try {
      final file = await FilePicker.pickFile();
      if (file == null || !_state.mounted) return null;
      final bytes = await file.readAsBytes();
      final name = (file.path ?? '')
          .split(RegExp(r'[\\/]'))
          .lastWhere((s) => s.isNotEmpty, orElse: () => 'file');
      if (!_state.mounted) return null;
      final appId = _state.context.read<MiniAppRunnerCubit>().state.app?.id;
      if (appId == null) return null;
      final url = await _state.context.read<MiniAppsRepository>().uploadFile(
        appId: appId,
        bytes: bytes,
        fileName: name,
      );
      return {'url': url, 'name': name};
    } on Exception {
      return null;
    }
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await LocalAuthClient().authenticate(reason: reason);
    } on Exception {
      return false;
    }
  }

  @override
  Future<int?> scheduleReminder({
    required String title,
    required String body,
    required String whenIso,
  }) async {
    final when = DateTime.tryParse(whenIso);
    if (when == null || when.isBefore(DateTime.now())) return null;
    try {
      final client = LocalNotificationsClient();
      await client.init();
      if (!await client.requestPermission()) return null;
      final id = (when.millisecondsSinceEpoch ~/ 1000) % 0x7fffffff;
      await client.schedule(id: id, title: title, body: body, when: when);
      return id;
    } on Exception {
      return null;
    }
  }

  @override
  Future<bool> addCalendarEvent({
    required String title,
    required String startIso,
    String? endIso,
    String? location,
    String? notes,
  }) async {
    if (!await _ensureScope(.calendar)) return false;
    final start = DateTime.tryParse(startIso);
    if (start == null) return false;
    final end = endIso == null ? null : DateTime.tryParse(endIso);
    try {
      final plugin = DeviceCalendarPlugin();
      var permission = await plugin.hasPermissions();
      if (permission.data != true) {
        permission = await plugin.requestPermissions();
        if (permission.data != true) return false;
      }
      final calendars =
          (await plugin.retrieveCalendars()).data ?? const <Calendar>[];
      final calendar =
          calendars.firstWhereOrNull((c) => c.isReadOnly == false) ??
          calendars.firstOrNull;
      final calendarId = calendar?.id;
      if (calendarId == null) return false;
      await LocalNotificationsClient().init();
      final event = Event(
        calendarId,
        title: title,
        description: notes,
        location: location,
        start: tz.TZDateTime.from(start, tz.local),
        end: tz.TZDateTime.from(
          end ?? start.add(const Duration(hours: 1)),
          tz.local,
        ),
      );
      final created = await plugin.createOrUpdateEvent(event);
      return created?.isSuccess ?? false;
    } on Exception {
      return false;
    }
  }

  @override
  void closeMiniApp() {
    if (_state.mounted) _state._close();
  }

  Future<bool> _ensureScope(MiniAppPermission scope) async {
    if (!_state.mounted) return false;
    final cubit = _state.context.read<MiniAppRunnerCubit>();
    final app = cubit.state.app;
    if (app == null) return false;
    final granted = app.grantedPermissions ?? const <MiniAppPermission>[];
    if (_containsScope(scope, granted)) return true;
    if (!_containsScope(scope, app.requestedPermissions)) return false;

    final allow = await showNinjaDialog<bool>(
      _state.context,
      builder: (dialogContext) => MiniAppScopePromptDialog(scope: scope),
    );
    if (allow != true || !_state.mounted) return false;
    await cubit.updateConsents([...granted, scope]);
    return true;
  }

  bool _containsScope(
    MiniAppPermission scope,
    List<MiniAppPermission> permissions,
  ) => switch (scope) {
    .identity => permissions.contains(MiniAppPermission.identity),
    .email => permissions.contains(MiniAppPermission.email),
    .profile => permissions.contains(MiniAppPermission.profile),
    .group => permissions.contains(MiniAppPermission.group),
    .notifications => permissions.contains(MiniAppPermission.notifications),
    .location => permissions.contains(MiniAppPermission.location),
    .camera => permissions.contains(MiniAppPermission.camera),
    .files => permissions.contains(MiniAppPermission.files),
    .calendar => permissions.contains(MiniAppPermission.calendar),
  };
}
