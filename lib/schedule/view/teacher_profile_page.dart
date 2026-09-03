import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart' show Teacher;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'review_card.dart';
part 'review_card_skeleton.dart';
part 'review_sheet.dart';
part 'reviews_skeleton.dart';
part 'stars_row.dart';

Future<void> showTeacherProfileSheet(
  BuildContext context, {
  required Teacher teacher,
}) => showAppSheet<void>(
  context,
  child: RepositoryProvider.value(
    value: context.read<CampusRepository>(),
    child: TeacherProfilePage(
      teacherName: teacher.name,
      teacher: teacher,
      inSheet: true,
    ),
  ),
);

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({
    required this.teacherName,
    this.teacher,
    this.inSheet = false,
    super.key,
  });
  final String teacherName;
  final Teacher? teacher;
  final bool inSheet;

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  TeacherProfile _profile = TeacherProfile.empty;
  bool _loading = true;
  bool _error = false;
  int _loadRevision = 0;
  CampusRepository get _repository => context.read();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    if (!mounted) return;
    final revision = ++_loadRevision;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final profile = await _repository.getTeacherProfile(widget.teacherName);
      if (mounted && revision == _loadRevision) {
        setState(() {
          _profile = profile;
          _loading = false;
        });
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to load teacher profile',
        error: error,
        stackTrace: stackTrace,
        name: 'TeacherProfilePage',
      );
      if (mounted && revision == _loadRevision) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  Future<void> _review() async {
    final saved = await showAppSheet<bool>(
      context,
      title: context.l10n.teacherProfileReviewTitle,
      subtitle: widget.teacherName,
      child: _ReviewSheet(
        repository: _repository,
        teacherName: widget.teacherName,
        current: _profile.reviews.where((r) => r.isMine).firstOrNull,
      ),
    );
    if (saved == true && mounted) await _load();
  }

  void _share() {
    unawaited(
      SharePlus.instance.share(
        ShareParams(
          text:
              '${widget.teacherName} · '
              '${context.read<UniversityConfig>().appName}',
        ),
      ),
    );
  }

  Future<void> _write() async {
    final email = widget.teacher?.email;
    final phone = widget.teacher?.phone;
    final uri = email != null && email.trim().isNotEmpty
        ? Uri(scheme: 'mailto', path: email)
        : phone != null && phone.trim().isNotEmpty
        ? Uri(scheme: 'tel', path: phone)
        : null;
    if (uri == null || !await launchUrl(uri)) {
      if (mounted) {
        ToastManager.showInfo(
          context,
          message: context.l10n.scheduleTeacherNoContacts,
        );
      }
    }
  }

  Widget _buildReviews(BuildContext context) {
    final l10n = context.l10n;
    if (_loading) {
      return const _ReviewsSkeleton(key: ValueKey('teacher_reviews_skeleton'));
    }
    if (_error) {
      return AppErrorState(
        title: l10n.loadingError,
        message: l10n.tryAgain,
        primaryLabel: l10n.retry,
        footnote: null,
        onPrimary: _load,
      );
    }
    if (_profile.reviews.isEmpty) {
      return AppEmptyState(
        title: l10n.teacherProfileEmptyTitle,
        subtitle: l10n.teacherProfileEmptySub,
        actionLabel: l10n.teacherProfileLeaveReview,
        onAction: _review,
      );
    }
    if (widget.inSheet) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: ColoredBox(
          color: context.colors.surface,
          child: Column(
            children: [
              for (final (index, review) in _profile.reviews.indexed) ...[
                if (index > 0) const AppDivider(),
                _ReviewCard(review: review, compact: true),
              ],
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.gap,
      children: [
        for (final review in _profile.reviews) _ReviewCard(review: review),
      ],
    );
  }

  Widget _content(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final profile = _profile;
    final unavailable = _loading || _error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppAvatar(
              name: widget.teacherName,
              imageUrl: widget.teacher?.photoUrl,
              size: 64,
              backgroundColor: colors.surface2,
              textStyle: AppText.sans(20, FontWeight.w700),
              color: colors.muted,
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.teacherName,
                    style: AppText.serif(
                      24,
                      height: 1.1,
                    ).copyWith(color: colors.ink),
                  ),
                  if (widget.teacher?.department case final department?) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      department,
                      style: AppText.sans(
                        13,
                        FontWeight.w400,
                      ).copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide =
                constraints.maxWidth >= 340 &&
                MediaQuery.textScalerOf(context).scale(1) <= 1.5;
            final stats = [
              (
                l10n.scheduleTeacherRating,
                unavailable || profile.overall == null
                    ? '—'
                    : NumberFormat(
                        '0.0',
                        Localizations.localeOf(context).toString(),
                      ).format(profile.overall),
              ),
              (
                l10n.scheduleTeacherReviews,
                unavailable ? '—' : '${profile.reviewsCount}',
              ),
              (
                l10n.scheduleTeacherSubjects,
                unavailable ? '—' : '${profile.subjects.length}',
              ),
            ];
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final stat in stats)
                  SizedBox(
                    width: wide
                        ? (constraints.maxWidth - 16) / 3
                        : constraints.maxWidth,
                    child: AppCard(
                      key: ValueKey('teacher-stat-${stat.$1}'),
                      radius: AppRadius.field,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            stat.$2,
                            style: AppText.sans(
                              20,
                              FontWeight.w800,
                            ).copyWith(color: colors.ink),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            stat.$1,
                            style: AppText.sans(11.5, FontWeight.w400).copyWith(
                              color: colors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        if (profile.subjects.isNotEmpty) ...[
          if (widget.inSheet)
            const SizedBox(height: AppSpacing.md)
          else
            AppOverline(l10n.teacherProfileSubjects),
          Wrap(
            spacing: AppSpacing.xsm,
            runSpacing: AppSpacing.xsm,
            children: [
              for (final (index, subject) in profile.subjects.indexed)
                AppCard(
                  key: ValueKey('teacher-subject-$index'),
                  radius: AppRadius.full,
                  color: colors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    subject,
                    style: AppText.sans(
                      12.5,
                      FontWeight.w600,
                    ).copyWith(color: colors.ink),
                  ),
                ),
            ],
          ),
        ],
        if (widget.inSheet)
          const SizedBox(height: AppSpacing.sectionGap)
        else
          AppOverline(l10n.teacherProfileReviews),
        AppStateSwitcher(child: _buildReviews(context)),
        const SizedBox(height: AppSpacing.sectionGap),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttons = [
              AppButton.secondary(
                label: l10n.scheduleTeacherWrite,
                expanded: true,
                backgroundColor: colors.surface,
                onPressed: _write,
              ),
              AppButton.primary(
                label: l10n.scheduleTeacherReview,
                expanded: true,
                onPressed: _review,
              ),
            ];
            return constraints.maxWidth < 320 ||
                    MediaQuery.textScalerOf(context).scale(1) > 1.4
                ? Column(spacing: AppSpacing.sm, children: buttons)
                : Row(
                    children: [
                      Expanded(child: buttons.first),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: buttons.last),
                    ],
                  );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inSheet) return _content(context);
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            AppInnerHeader(
              title: context.l10n.lessonDetailsTeacherFallback,
              actions: [
                AppHeaderAction(
                  icon: AppLineIcon.share,
                  semanticsLabel: context.l10n.teacherProfileShare,
                  onTap: _share,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.screen,
                AppSpacing.screen,
                AppSpacing.xxlg,
              ),
              child: _content(context),
            ),
          ],
        ),
      ),
    );
  }
}
