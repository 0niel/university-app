part of '../schedule_details_page.dart';

class LessonMaterialsPage extends StatefulWidget {
  const LessonMaterialsPage({
    required this.lesson,
    required this.selectedDate,
    required this.lessonNumber,
    super.key,
  });

  final LessonSchedulePart lesson;
  final DateTime selectedDate;
  final int lessonNumber;

  @override
  State<LessonMaterialsPage> createState() => _LessonMaterialsPageState();
}

class _LessonMaterialsPageState extends State<LessonMaterialsPage> {
  List<LessonMaterial> _materials = const [];
  bool _loading = true;
  Object? _error;
  int _loadRevision = 0;
  String? _openingId;
  final Map<String, String> _urlCache = {};

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final revision = ++_loadRevision;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final details = await context.read<ScheduleRepository>().getLessonDetails(
        subjectName: widget.lesson.subject,
        lessonDate: widget.selectedDate,
        lessonBellsNumber: widget.lessonNumber,
      );
      if (!mounted || revision != _loadRevision) return;
      setState(
        () => _materials = details.materials.sorted(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        ),
      );
    } on Exception catch (error) {
      if (mounted && revision == _loadRevision) setState(() => _error = error);
    } finally {
      if (mounted && revision == _loadRevision) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _download(LessonMaterial material) async {
    try {
      final url = await context
          .read<ScheduleRepository>()
          .createLessonMaterialUrl(material);
      if (!await launchUrlString(url, mode: .externalApplication)) {
        throw Exception('Unable to open material');
      }
    } on Exception catch (_) {
      if (!mounted) return;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsOpenFailed,
      );
    }
  }

  Future<String> _urlFor(
    ScheduleRepository repository,
    LessonMaterial material,
  ) async {
    final cached = _urlCache[material.id];
    if (cached != null) return cached;
    final url = await repository.createLessonMaterialUrl(material);
    _urlCache[material.id] = url;
    return url;
  }

  Future<void> _openViewer(LessonMaterial material) async {
    final index = _materials.indexWhere((m) => m.id == material.id);
    if (index < 0 || _openingId != null) return;
    setState(() => _openingId = material.id);
    try {
      final repository = context.read<ScheduleRepository>();
      final urls = await Future.wait(
        _materials.map((m) => _urlFor(repository, m)),
      );
      if (!mounted) return;
      final items = [
        for (final (i, m) in _materials.indexed)
          MediaItem(
            url: urls[i],
            kind: MediaItem.kindOf(mimeType: m.mimeType, fileName: m.fileName),
            title: m.title,
            fileName: m.fileName,
            mimeType: m.mimeType,
            sizeBytes: m.fileSize,
          ),
      ];
      await showMediaViewer(context, items: items, initialIndex: index);
    } on Exception catch (_) {
      if (!mounted) return;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsOpenFailed,
      );
    } finally {
      if (mounted) setState(() => _openingId = null);
    }
  }

  Future<void> _showUploadSheet() async {
    final repository = context.read<ScheduleRepository>();
    final uploaded = await showAppSheet<bool>(
      context,
      title: context.l10n.lessonDetailsMaterialToClass,
      subtitle:
          '${widget.lesson.subject} · '
          '${_lessonTypeName(context.l10n, widget.lesson).toLowerCase()} '
          '${widget.lessonNumber}',
      child: RepositoryProvider.value(
        value: repository,
        child: LessonMaterialUploadSheet(
          lesson: widget.lesson,
          selectedDate: widget.selectedDate,
          lessonNumber: widget.lessonNumber,
        ),
      ),
    );
    if (uploaded == true && mounted) await _load();
  }

  Widget _buildState(BuildContext context) {
    if (_loading) {
      return const _MaterialsPageSkeleton(
        key: ValueKey('materials_page_skeleton'),
      );
    }
    if (_error != null) {
      final l10n = context.l10n;
      return AppErrorState(
        key: const ValueKey('materials_page_error'),
        title: l10n.lessonDetailsLoadFailed,
        message: l10n.lessonDetailsCheckConnection,
        primaryLabel: l10n.retry,
        footnote: null,
        onPrimary: () => unawaited(_load()),
      );
    }
    if (_materials.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: _EmptyMaterialsCard(
          onTap: () => unawaited(_showUploadSheet()),
        ),
      ).animateEmptyState(key: const ValueKey('materials_page_empty'));
    }
    return Column(
      key: const ValueKey('materials_page_list'),
      children: [
        for (final (index, material) in _materials.indexed)
          Padding(
            padding: const .only(bottom: AppSpacing.gap),
            child: _MaterialCard(
              material: material,
              onOpen: () => unawaited(_openViewer(material)),
              onDownload: () => unawaited(_download(material)),
            ),
          ).animateListItem(index: index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      floatingActionButton: AppFab(
        icon: AppLineIcon.plus,
        tooltip: context.l10n.lessonDetailsUpload,
        onPressed: () => unawaited(_showUploadSheet()),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: context.colors.ink,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: AppInnerHeader(
                title: context.l10n.lessonDetailsMaterialsPage,
                backSemanticsLabel: context.l10n.back,
                onBack: () => Navigator.of(context).maybePop(),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.sm,
                  AppSpacing.screen,
                  120,
                ),
                sliver: SliverList.list(
                  children: [
                    Text(
                      '${widget.lesson.subject} · '
                      '${_lessonTypeName(
                        context.l10n,
                        widget.lesson,
                      ).toLowerCase()} '
                      '${widget.lessonNumber}',
                      style: AppText.subtext.copyWith(
                        color: context.colors.muted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    _ContributeBanner(
                      onTap: () => unawaited(_showUploadSheet()),
                    ),
                    const SizedBox(height: AppSpacing.sheetBottom),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.xsm,
                      children: [
                        Text(
                          context.l10n.lessonDetailsMaterialsCount(
                            _materials.length,
                          ),
                          style: AppText.subtext.copyWith(
                            color: context.colors.muted,
                            fontWeight: .w700,
                          ),
                        ),
                        Text(
                          context.l10n.lessonDetailsNewestFirst,
                          style: AppText.captionSmall.copyWith(
                            color: context.colors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppStateSwitcher(child: _buildState(context)),
                  ],
                ),
              ),
            ),
          ],
        ).animatePageEntrance(),
      ),
    );
  }
}
