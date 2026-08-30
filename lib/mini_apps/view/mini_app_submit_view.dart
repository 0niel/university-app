part of 'mini_app_submit_page.dart';

class MiniAppSubmitView extends StatefulWidget {
  const MiniAppSubmitView({super.key});

  @override
  State<MiniAppSubmitView> createState() => _MiniAppSubmitViewState();
}

class _MiniAppSubmitViewState extends State<MiniAppSubmitView> {
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emojiController = TextEditingController(text: '🧩');
  final _originController = TextEditingController();
  final _entryPathController = TextEditingController(text: '/');
  final List<ScreenDraft> _screens = [
    ScreenDraft(path: '/', json: kStarterScreenJson),
  ];

  MiniAppCategory _category = .tools;
  MiniAppSourceKind _sourceKind = .hosted;
  final Set<MiniAppPermission> _permissions = {};
  bool _slugEdited = false;

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _emojiController.dispose();
    _originController.dispose();
    _entryPathController.dispose();
    for (final screen in _screens) {
      screen.dispose();
    }
    super.dispose();
  }

  void _syncSlug(String name) {
    if (_slugEdited) return;
    final slug = name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    _slugController.text = slug;
  }

  void _addScreen() {
    setState(() => _screens.add(ScreenDraft(path: '/page-${_screens.length}')));
  }

  Future<void> _applyTemplate(MiniAppTemplate template) async {
    final pristine =
        _screens.length == 1 &&
        _screens.first.jsonController.text == kStarterScreenJson;
    if (!pristine) {
      final confirmed = await showNinjaConfirmDialog(
        context,
        title: context.l10n.miniAppsTplReplaceTitle,
        message: context.l10n.miniAppsTplReplaceBody,
        confirmLabel: context.l10n.miniAppsModerationConfirm,
        cancelLabel: context.l10n.cancel,
      );
      if (!confirmed) return;
    }
    setState(() {
      for (final screen in _screens) {
        screen.dispose();
      }
      _screens.clear();
      for (final screen in template.screens) {
        _screens.add(ScreenDraft(path: screen.$1, json: screen.$2));
      }
    });
  }

  void _removeScreen(ScreenDraft screen) {
    setState(() => _screens.remove(screen));
    screen.dispose();
  }

  Future<void> _preview(ScreenDraft screen) async {
    final cubit = context.read<MiniAppSubmitCubit>();
    final json = cubit.parseScreenJson(screen.jsonController.text);
    if (json == null) return;
    await MiniAppsRuntime.ensureInitialized();
    if (!mounted) return;
    await showAppSheet<void>(
      context,
      title: context.l10n.miniAppsSubmitPreview,
      scrollable: false,
      child: SizedBox(
        height: MediaQuery.heightOf(context) * 0.6,
        child: ClipRRect(
          borderRadius: .circular(NinjaRadius.card),
          child:
              StacBridge.render(json, context) ??
              NinjaEmptyState(
                icon: AppLineIconWidget(
                  AppLineIcon.grid,
                  size: 20,
                  color: context.ninja.muted,
                ),
                title: context.l10n.miniAppsRunnerError,
              ),
        ),
      ),
    );
  }

  Future<void> _submit({required bool asDraft}) async {
    final cubit = context.read<MiniAppSubmitCubit>();
    final screens = <MiniAppScreen>[];
    if (_sourceKind == .hosted) {
      for (final draft in _screens) {
        final json = cubit.parseScreenJson(draft.jsonController.text);
        if (json == null) return;
        screens.add(
          MiniAppScreen(path: draft.pathController.text.trim(), json: json),
        );
      }
      try {
        final repository = context.read<MiniAppsRepository>();
        final validation = await repository.validateScreens(screens);
        if (!validation.isClean && mounted) {
          final unknown = [
            ...validation.unknownWidgets,
            ...validation.unknownActions,
          ].join(', ');
          showNinjaToast(
            context,
            showCheck: false,
            message: context.l10n.miniAppsSubmitUnknownTypes(unknown),
          );
        }
      } on Exception catch (error, stackTrace) {
        log(
          'Mini app screen validation failed',
          error: error,
          stackTrace: stackTrace,
          name: 'MiniAppSubmitView',
        );
      }
      if (!mounted) return;
    }
    unawaited(
      cubit.submit(
        slug: _slugController.text.trim(),
        name: _nameController.text,
        description: _descriptionController.text,
        iconEmoji: _emojiController.text.trim(),
        category: _category,
        sourceKind: _sourceKind,
        originUrl: _originController.text.trim(),
        entryPath: _entryPathController.text.trim().isEmpty
            ? '/'
            : _entryPathController.text.trim(),
        screens: screens,
        permissions: _permissions.toList(),
        asDraft: asDraft,
      ),
    );
  }

  void _onStatus(BuildContext context, MiniAppSubmitState state) {
    final l10n = context.l10n;
    final message = switch (state.status) {
      .invalidJson => l10n.miniAppsSubmitInvalidJson,
      .invalidFields => l10n.miniAppsSubmitInvalidFields,
      .invalidScreens => l10n.miniAppsSubmitInvalidScreens,
      .failure => l10n.miniAppsSubmitFailure,
      .success => l10n.miniAppsSubmitSuccess,
      .idle || .submitting => null,
    };
    if (message != null) {
      showNinjaToast(
        context,
        showCheck: state.status == .success,
        message: message,
      );
    }
    if (state.status == .success) {
      context.go('/services/apps');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return BlocConsumer<MiniAppSubmitCubit, MiniAppSubmitState>(
      listener: _onStatus,
      builder: (context, state) {
        final submitting = state.status == .submitting;
        return Scaffold(
          backgroundColor: colors.canvas,
          appBar: NinjaAppBar.inner(
            title: l10n.miniAppsSubmitTitle,
            onBack: () => Navigator.of(context).maybePop(),
            backSemanticLabel: l10n.back,
          ),
          body: ListView(
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              18,
              NinjaMetrics.screenPadding,
              40,
            ),
            children: [
              Text(
                l10n.miniAppsSubmitSubtitle,
                style: NinjaText.body.copyWith(color: colors.muted),
              ),
              const SizedBox(height: 20),
              _MetadataSection(
                nameController: _nameController,
                slugController: _slugController,
                descriptionController: _descriptionController,
                emojiController: _emojiController,
                onNameChanged: _syncSlug,
                onSlugEdited: () => _slugEdited = true,
              ),
              const SizedBox(height: 18),
              _CategorySection(
                category: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 18),
              if (_sourceKind == .hosted) ...[
                _SubmitSectionLabel(
                  title: l10n.miniAppsTplTitle,
                  subtitle: l10n.miniAppsTplSubtitle,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final template in miniAppTemplates)
                      NinjaChip(
                        label: template.nameBuilder(context),
                        onTap: () => unawaited(_applyTemplate(template)),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
              _SourceSection(
                sourceKind: _sourceKind,
                originController: _originController,
                entryPathController: _entryPathController,
                screens: _screens,
                onKindChanged: (kind) => setState(() => _sourceKind = kind),
                onPreview: (screen) => unawaited(_preview(screen)),
                onAddScreen: _addScreen,
                onRemoveScreen: _removeScreen,
              ),
              if (_sourceKind == .remote) ...[
                const SizedBox(height: 18),
                _PermissionsSection(
                  permissions: _permissions,
                  onToggled: (permission) => setState(() {
                    if (!_permissions.remove(permission)) {
                      _permissions.add(permission);
                    }
                  }),
                ),
              ],
              const SizedBox(height: 24),
              NinjaButton.primary(
                label: submitting
                    ? l10n.miniAppsSubmitSending
                    : l10n.miniAppsSubmitSend,
                expanded: true,
                loading: submitting,
                onPressed: submitting
                    ? null
                    : () => unawaited(_submit(asDraft: false)),
              ),
              const SizedBox(height: 10),
              NinjaButton.outline(
                label: l10n.miniAppsSubmitDraft,
                expanded: true,
                onPressed: submitting
                    ? null
                    : () => unawaited(_submit(asDraft: true)),
              ),
            ],
          ),
        );
      },
    );
  }
}
