import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_section_header.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_surface.dart';
import 'package:share_plus/share_plus.dart';

part 'rating_card.dart';
part 'review_card.dart';
part 'review_card_skeleton.dart';
part 'review_sheet.dart';
part 'reviews_skeleton.dart';
part 'stars_row.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({required this.teacherName, super.key});

  final String teacherName;

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  TeacherProfile _profile = .empty;
  bool _loading = true;
  bool _error = false;

  CampusRepository get _repository => context.read();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final profile = await _repository.getTeacherProfile(widget.teacherName);
      if (mounted) {
        setState(() {
          _profile = profile;
          _loading = false;
        });
      }
    } on Exception catch (e, st) {
      log(
        'Failed to load teacher profile',
        error: e,
        stackTrace: st,
        name: 'TeacherProfilePage',
      );
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  Future<void> _review() async {
    final mine = _profile.reviews.where((r) => r.isMine).firstOrNull;
    final saved = await showAppSheet<bool>(
      context,
      title: context.l10n.teacherProfileReviewTitle,
      subtitle: widget.teacherName,
      child: _ReviewSheet(
        repository: _repository,
        teacherName: widget.teacherName,
        current: mine,
      ),
    );
    if (saved == true) await _load();
  }

  void _share() {
    final overall = _profile.overall;
    unawaited(
      SharePlus.instance.share(
        ShareParams(
          text:
              '${widget.teacherName} · '
              '${context.read<UniversityConfig>().appName}'
              '${overall != null ? ' · ★ ${overall.toStringAsFixed(1)}' : ''}',
        ),
      ),
    );
  }

  Widget _buildReviews(BuildContext context, TeacherProfile profile) {
    final l10n = context.l10n;
    if (_loading) {
      return const _ReviewsSkeleton(key: ValueKey('teacher_reviews_skeleton'));
    }
    if (_error) {
      return NinjaErrorState(
        title: l10n.loadingError,
        message: l10n.tryAgain,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(_load()),
      ).animateEmptyState(key: const ValueKey('teacher_reviews_error'));
    }
    if (profile.reviews.isEmpty) {
      return NinjaEmptyState(
        title: l10n.teacherProfileEmptyTitle,
        message: l10n.teacherProfileEmptySub,
        icon: AppLineIconWidget(
          AppLineIcon.message,
          size: 20,
          color: context.ninja.muted,
        ),
        actionLabel: l10n.teacherProfileLeaveReview,
        onAction: () => unawaited(_review()),
      ).animateEmptyState(key: const ValueKey('teacher_reviews_empty'));
    }
    return Column(
      key: const ValueKey('teacher_reviews'),
      crossAxisAlignment: .stretch,
      children: [
        for (final (index, review) in profile.reviews.indexed) ...[
          _ReviewCard(review: review).animateListItem(index: index),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final profile = _profile;
    final overall = profile.overall;
    final reviewsCountLabel = context.l10n.teacherProfileReviewsCount(
      profile.reviewsCount,
    );
    return Scaffold(
      backgroundColor: colors.canvas,
      body: RefreshIndicator(
        color: colors.ink,
        onRefresh: _load,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: colors.canvas,
              surfaceTintColor: Colors.transparent,
              leading: NinjaIconButton(
                icon: const AppLineIconWidget(.chevronL, size: 20),
                tooltip: context.l10n.back,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              actions: [
                NinjaIconButton(
                  icon: const AppLineIconWidget(.share, size: 20),
                  tooltip: context.l10n.teacherProfileShare,
                  onPressed: _share,
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  8,
                  NinjaMetrics.screenPadding,
                  100,
                ),
                sliver: SliverList.list(
                  children: [
                    NinjaScheduleSurface(
                      child: Row(
                        spacing: 14,
                        children: [
                          NinjaAvatar(
                            initials: _teacherInitials(widget.teacherName),
                            size: 64,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: 4,
                              children: [
                                Text(
                                  widget.teacherName,
                                  style: NinjaText.title.copyWith(
                                    color: colors.ink,
                                  ),
                                ),
                                Text(
                                  overall != null
                                      ? '★ ${overall.toStringAsFixed(1)}'
                                            ' · $reviewsCountLabel'
                                      : context
                                            .l10n
                                            .teacherProfileNoReviewsInline,
                                  style: NinjaText.subtext.copyWith(
                                    color: colors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _RatingCard(
                          value: profile.clarity,
                          label: context.l10n.teacherProfileClarity,
                        ),
                        _RatingCard(
                          value: profile.loyalty,
                          label: context.l10n.teacherProfileLoyalty,
                        ),
                        _RatingCard(
                          value: profile.usefulness,
                          label: context.l10n.teacherProfileUsefulness,
                        ),
                      ],
                    ),
                    if (profile.subjects.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      NinjaScheduleSectionHeader(
                        title: context.l10n.teacherProfileSubjects,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final subject in profile.subjects.take(8))
                            NinjaChip(label: subject),
                        ],
                      ),
                    ],
                    const SizedBox(height: 28),
                    NinjaScheduleSectionHeader(
                      title: context.l10n.teacherProfileReviews,
                    ),
                    const SizedBox(height: 10),
                    NinjaStateSwitcher(child: _buildReviews(context, profile)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CommunityFab(
        label: context.l10n.teacherProfileLeaveReview,
        icon: .pencil,
        onPressed: () => unawaited(_review()),
      ),
    );
  }
}

String _teacherInitials(String name) => name
    .trim()
    .split(RegExp(r'\s+'))
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part.characters.firstOrNull?.toUpperCase() ?? '')
    .join();
