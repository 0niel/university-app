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

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
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
      if (!mounted) return;
      setState(() => _materials = details.materials);
    } on Exception catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _download(LessonMaterial material) async {
    try {
      final url = await context
          .read<ScheduleRepository>()
          .createLessonMaterialUrl(material);
      await launchUrlString(url, mode: .externalApplication);
    } on Exception catch (_) {
      if (!mounted) return;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsOpenFailed,
      );
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
        child: _UploadMaterialSheet(
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
      return NinjaErrorState(
        key: const ValueKey('materials_page_error'),
        title: l10n.lessonDetailsLoadFailed,
        message: l10n.lessonDetailsCheckConnection,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(_load()),
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
            padding: const .only(bottom: 10),
            child: _MaterialCard(
              material: material,
              onDownload: () => unawaited(_download(material)),
            ),
          ).animateListItem(index: index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ninja.canvas,
      floatingActionButton: NinjaFab(
        icon: AppLineIconWidget(
          .plus,
          size: 24,
          color: context.ninja.onBrand,
        ),
        tooltip: context.l10n.lessonDetailsUpload,
        onPressed: () => unawaited(_showUploadSheet()),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: context.ninja.ink,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: context.ninja.canvas,
              surfaceTintColor: Colors.transparent,
              leading: NinjaIconButton(
                icon: const AppLineIconWidget(.chevronL, size: 20),
                tooltip: context.l10n.back,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Text(
                context.l10n.lessonDetailsMaterialsPage,
                style: NinjaText.headline.copyWith(color: context.ninja.ink),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  8,
                  NinjaMetrics.screenPadding,
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
                      style: NinjaText.subtext.copyWith(
                        color: context.ninja.muted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _ContributeBanner(
                      onTap: () => unawaited(_showUploadSheet()),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          context.l10n.lessonDetailsMaterialsCount(
                            _materials.length,
                          ),
                          style: NinjaText.subtext.copyWith(
                            color: context.ninja.muted,
                            fontWeight: .w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          context.l10n.lessonDetailsNewestFirst,
                          style: NinjaText.helper.copyWith(
                            color: context.ninja.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    NinjaStateSwitcher(child: _buildState(context)),
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
