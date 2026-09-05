import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/feed/bloc/feed_bloc.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_layout.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_progress_bars.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_slide.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class StoryViewerPage extends StatefulWidget {
  const StoryViewerPage({
    required this.sourceId,
    super.key,
    this.onOpenArticle,
    this.slideDuration = const Duration(seconds: 6),
    this.maxStories = 10,
    this.heroTag,
  });

  final String sourceId;
  final ValueChanged<String>? onOpenArticle;
  final Duration slideDuration;
  final int maxStories;
  final Object? heroTag;

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _timer;
  late final AnimationController _dismiss;
  late final Category _category;
  NewsSourceItem? _source;
  int _index = 0;
  int _count = 0;
  int _pointers = 0;
  bool _dragging = false;
  bool _closing = false;
  bool _active = true;
  bool _mediaReady = false;
  bool _mediaOpen = false;
  bool _navigationTapPending = false;
  double _swipeDistance = 0;
  final _mediaHeroScope = Object();
  String? _mediaPostId;
  String? _precachedNextId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dismiss = AnimationController.unbounded(vsync: this);
    _timer = AnimationController(
      vsync: this,
      duration: widget.slideDuration,
    )..addStatusListener(_onTimerStatus);
    final categories = context.read<CategoriesBloc>().state;
    final source = feedSourceById(categories.sources, widget.sourceId);
    _source = source;
    final id = source == null ? widget.sourceId : feedSourceKey(source);
    _category = feedCategoryFor(
      categories,
      id: id,
      name: source == null ? widget.sourceId : feedSourceName(source),
    );
    final feedBloc = context.read<FeedBloc>();
    if (!feedBloc.state.feed.containsKey(_category.id)) {
      feedBloc.add(FeedRequested(category: _category));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dismiss.dispose();
    _timer
      ..removeStatusListener(_onTimerStatus)
      ..dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    if (_active) {
      _resume();
    } else {
      _timer.stop();
    }
  }

  bool get _reducedMotion =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);

  void _resume() {
    if (mounted &&
        _active &&
        !_closing &&
        !_dragging &&
        !_mediaOpen &&
        !_navigationTapPending &&
        _pointers == 0 &&
        _count > 0 &&
        _mediaReady &&
        !_reducedMotion) {
      unawaited(_timer.forward());
    }
  }

  void _releasePointer() {
    _pointers = math.max(0, _pointers - 1);
    _resume();
  }

  void _navigationStarted() {
    _navigationTapPending = true;
    _timer.stop();
  }

  void _navigationCancelled() {
    _navigationTapPending = false;
    _resume();
  }

  void _navigate(VoidCallback action) {
    _navigationTapPending = false;
    action();
    _resume();
  }

  void _dragStart(DragStartDetails _) {
    _dragging = true;
    _timer.stop();
    _dismiss.stop();
  }

  void _dragUpdate(DragUpdateDetails details) {
    if (_closing) return;
    _dismiss.value = (_dismiss.value + details.delta.dy).clamp(
      0,
      MediaQuery.sizeOf(context).height,
    );
  }

  Future<void> _dragEnd(DragEndDetails details) async {
    if (_closing) return;
    final close =
        _dismiss.value > 110 ||
        (_dismiss.value > 24 && (details.primaryVelocity ?? 0) > 900);
    _closing = close;
    if (close) {
      _dragging = false;
      _timer.stop();
      unawaited(Navigator.of(context).maybePop());
      return;
    }
    await _dismiss.animateTo(
      0,
      duration: _reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
    if (!mounted) return;
    _dragging = false;
    _resume();
  }

  void _swipeStart(DragStartDetails _) {
    _dragging = true;
    _swipeDistance = 0;
    _timer.stop();
  }

  void _swipeEnd(DragEndDetails details) {
    if (_closing) return;
    _dragging = false;
    final velocity = details.primaryVelocity ?? 0;
    if (_swipeDistance < -48 || velocity < -450) {
      _next();
    } else if (_swipeDistance > 48 || velocity > 450) {
      _prev();
    } else {
      _resume();
    }
  }

  Future<void> _viewImage(PostBlock post) async {
    final url = post.imageUrl;
    if (_mediaOpen || _closing || url == null || url.isEmpty) return;
    _mediaOpen = true;
    _timer.stop();
    try {
      await showMediaViewer(
        context,
        items: [
          MediaItem(
            url: url,
            kind: MediaKind.image,
            title: post.title,
            heroTag: (_mediaHeroScope, post.id),
          ),
        ],
      );
    } finally {
      if (mounted) {
        _mediaOpen = false;
        _resume();
      }
    }
  }

  void _onTimerStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _next();
  }

  void _restart() {
    _timer.reset();
    _resume();
  }

  void _next() {
    if (_index + 1 < _count) {
      _mediaReady = false;
      setState(() => _index++);
      _restart();
    } else {
      _close();
    }
  }

  void _prev() {
    if (_index > 0) {
      _mediaReady = false;
      setState(() => _index--);
    }
    _restart();
  }

  void _close() {
    _closing = true;
    _timer.stop();
    unawaited(Navigator.of(context).maybePop());
  }

  void _read(PostBlock post) {
    _closing = true;
    _timer.stop();
    Navigator.of(context).pop();
    widget.onOpenArticle?.call(post.id);
  }

  void _ensureStarted(int count) {
    _count = count;
    if (count == 0) {
      _timer.stop();
      _mediaPostId = null;
      _mediaReady = false;
      return;
    }
    if (_reducedMotion) {
      return;
    }
    if (_timer.isAnimating || _timer.value > 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_timer.isAnimating && _timer.value == 0) {
        _resume();
      }
    });
  }

  void _prepareMedia(PostBlock post) {
    if (_mediaPostId == post.id) return;
    _mediaPostId = post.id;
    _mediaReady = post.imageUrl?.isNotEmpty != true;
    _timer.reset();
  }

  void _onMediaReady(String id) {
    if (_mediaReady || _mediaPostId != id) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _mediaReady || _mediaPostId != id) return;
      _mediaReady = true;
      _resume();
    });
  }

  void _precacheNext(BuildContext context, List<PostBlock> posts, int index) {
    final next = index + 1 < posts.length ? posts[index + 1] : null;
    final url = next?.imageUrl;
    if (next == null ||
        url == null ||
        url.isEmpty ||
        _precachedNextId == next.id) {
      return;
    }
    _precachedNextId = next.id;
    unawaited(
      precacheImage(
        CachedNetworkImageProvider(url),
        context,
      ).catchError((Object _) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    const dark = AppColors.dark;
    return Listener(
      onPointerDown: (_) {
        _pointers++;
        _timer.stop();
      },
      onPointerUp: (_) => _releasePointer(),
      onPointerCancel: (_) => _releasePointer(),
      child: GestureDetector(
        key: const Key('storyViewer_dismiss'),
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: _dragStart,
        onVerticalDragUpdate: _dragUpdate,
        onVerticalDragEnd: (details) => unawaited(_dragEnd(details)),
        onVerticalDragCancel: () => unawaited(_dragEnd(DragEndDetails())),
        onHorizontalDragStart: _swipeStart,
        onHorizontalDragUpdate: (details) => _swipeDistance += details.delta.dx,
        onHorizontalDragEnd: _swipeEnd,
        onHorizontalDragCancel: () {
          _dragging = false;
          _resume();
        },
        child: AnimatedBuilder(
          animation: _dismiss,
          builder: (context, child) {
            final progress =
                (_dismiss.value / MediaQuery.sizeOf(context).height).clamp(
                  0.0,
                  1.0,
                );
            return ColoredBox(
              color: dark.canvas.withValues(alpha: 1 - progress),
              child: Transform.translate(
                offset: Offset(0, _dismiss.value),
                child: Transform.scale(
                  scale: 1 - progress * .08,
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(progress * 36),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Scaffold(
            backgroundColor: context.colors.ink,
            body: LayoutBuilder(
              builder: (context, constraints) {
                final stage = ColoredBox(
                  color: dark.canvas,
                  child: BlocBuilder<FeedBloc, FeedState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status ||
                        previous.feed[_category.id] !=
                            current.feed[_category.id],
                    builder: (context, state) {
                      final posts = feedPosts(
                        state.feed[_category.id],
                      ).take(widget.maxStories).toList();
                      if (posts.isEmpty) {
                        _ensureStarted(0);
                        final pending =
                            state.status == FeedStatus.loading ||
                            (state.status == FeedStatus.initial &&
                                !state.feed.containsKey(_category.id));
                        return _StoryStagePlaceholder(
                          pending: pending,
                          failed: state.status == FeedStatus.failure,
                          sourceName: _sourceName(context),
                          avatarUrl: _source?.avatarUrl,
                          heroTag: widget.heroTag,
                          onClose: _close,
                          onRetry: () => context.read<FeedBloc>().add(
                            FeedRequested(category: _category),
                          ),
                        );
                      }
                      final index = math.min(_index, posts.length - 1);
                      _prepareMedia(posts[index]);
                      _ensureStarted(posts.length);
                      _precacheNext(context, posts, index);
                      return _StoryScreen(
                        posts: posts,
                        index: index,
                        timer: _timer,
                        sourceName: _sourceName(context, posts[index]),
                        time: feedRelativeTime(
                          context.l10n,
                          posts[index].publishedAt,
                        ),
                        avatarUrl: _source?.avatarUrl,
                        heroTag: widget.heroTag,
                        imageHeroTag: (_mediaHeroScope, posts[index].id),
                        onViewImage: posts[index].imageUrl?.isNotEmpty == true
                            ? () => _navigate(
                                () => unawaited(_viewImage(posts[index])),
                              )
                            : null,
                        onPrev: () => _navigate(_prev),
                        onNext: () => _navigate(_next),
                        onNavigationStart: _navigationStarted,
                        onNavigationCancel: _navigationCancelled,
                        onClose: _close,
                        onRead: () => _read(posts[index]),
                        onMediaReady: () => _onMediaReady(posts[index].id),
                      );
                    },
                  ),
                );
                if (constraints.maxWidth <= StoryLayout.wideBreakpoint) {
                  return stage;
                }
                return Center(
                  child: AspectRatio(aspectRatio: 9 / 16, child: stage),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _sourceName(BuildContext context, [PostBlock? post]) {
    final source = _source;
    if (source != null) return feedSourceName(source);
    final categoryName = context.read<CategoriesBloc>().state.getCategoryName(
      post?.categoryId ?? _category.id,
    );
    if (categoryName != null) return categoryName;
    return post?.author ?? widget.sourceId;
  }
}

class _StoryHeader extends StatelessWidget {
  const _StoryHeader({
    required this.sourceName,
    required this.onClose,
    this.avatarUrl,
    this.time,
    this.heroTag,
    this.onViewImage,
  });

  final String sourceName;
  final String? avatarUrl;
  final String? time;
  final VoidCallback onClose;
  final Object? heroTag;
  final VoidCallback? onViewImage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final white = colors.white;
    final time = this.time;
    Widget avatar(Widget child) => heroTag == null
        ? child
        : HeroMode(
            enabled:
                !MediaQuery.disableAnimationsOf(context) &&
                !MediaQuery.accessibleNavigationOf(context),
            child: Hero(tag: heroTag!, child: child),
          );
    return Row(
      children: [
        ExcludeSemantics(
          child: avatar(
            Container(
              width: StoryLayout.avatarSize,
              height: StoryLayout.avatarSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accent,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl!,
                      fit: BoxFit.cover,
                      width: StoryLayout.avatarSize,
                      height: StoryLayout.avatarSize,
                      errorWidget: (_, _, _) =>
                          _StoryInitials(name: sourceName),
                    )
                  : _StoryInitials(name: sourceName),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.gap),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: sourceName,
                  style: AppText.tab.copyWith(color: white),
                ),
                if (time != null && time.isNotEmpty)
                  TextSpan(
                    text: '  ·  $time',
                    style: AppText.caption.copyWith(
                      color: white.withValues(alpha: .7),
                    ),
                  ),
              ],
            ),
            key: const Key('storyViewer_headerName'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onViewImage != null)
          AppIconButton(
            key: const Key('storyViewer_viewImage'),
            icon: const AppLineIconWidget(AppLineIcon.focus),
            tooltip: l10n.imageViewer,
            onPressed: onViewImage,
            tone: AppIconButtonTone.surface,
            foregroundColor: white,
            backgroundColor: white.withValues(alpha: .15),
            shape: AppIconButtonShape.circle,
          ),
        AppPressState(
          key: const Key('storyViewer_close'),
          onTap: onClose,
          semanticsLabel: l10n.storyClose,
          semanticsButton: true,
          builder: (context, {required pressed}) => SizedBox.square(
            dimension: AppControlSize.touchTarget,
            child: Center(
              child: Container(
                key: const Key('storyViewer_closeSurface'),
                width: StoryLayout.closeSize,
                height: StoryLayout.closeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white.withValues(alpha: pressed ? .25 : .15),
                ),
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.close,
                    size: 18,
                    strokeWidth: 2.4,
                    color: white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StoryScreen extends StatelessWidget {
  const _StoryScreen({
    required this.posts,
    required this.index,
    required this.timer,
    required this.sourceName,
    required this.onPrev,
    required this.onNext,
    required this.onClose,
    required this.onRead,
    required this.onMediaReady,
    required this.onNavigationStart,
    required this.onNavigationCancel,
    this.time,
    this.avatarUrl,
    this.heroTag,
    this.imageHeroTag,
    this.onViewImage,
  });

  final List<PostBlock> posts;
  final int index;
  final Animation<double> timer;
  final String sourceName;
  final String? time;
  final String? avatarUrl;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onClose;
  final VoidCallback onRead;
  final VoidCallback onMediaReady;
  final VoidCallback onNavigationStart;
  final VoidCallback onNavigationCancel;
  final Object? heroTag;
  final Object? imageHeroTag;
  final VoidCallback? onViewImage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final post = posts[index];
    final resolvedTime = time ?? feedRelativeTime(l10n, post.publishedAt);
    final top = math.max<double>(
      StoryLayout.topInset,
      MediaQuery.paddingOf(context).top + AppSpacing.md,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: StoryLayout.navigationBottomInset,
          child: Row(
            children: [
              Expanded(
                flex: 35,
                child: Semantics(
                  button: true,
                  label: l10n.storyPrevious,
                  child: Listener(
                    onPointerDown: (_) => onNavigationStart(),
                    onPointerCancel: (_) => onNavigationCancel(),
                    child: GestureDetector(
                      key: const Key('storyViewer_prevZone'),
                      behavior: HitTestBehavior.opaque,
                      onTap: onPrev,
                      onDoubleTap: onViewImage,
                      onTapCancel: onNavigationCancel,
                      onDoubleTapCancel: onViewImage == null
                          ? null
                          : onNavigationCancel,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 65,
                child: Semantics(
                  button: true,
                  label: l10n.storyNext,
                  child: Listener(
                    onPointerDown: (_) => onNavigationStart(),
                    onPointerCancel: (_) => onNavigationCancel(),
                    child: GestureDetector(
                      key: const Key('storyViewer_nextZone'),
                      behavior: HitTestBehavior.opaque,
                      onTap: onNext,
                      onDoubleTap: onViewImage,
                      onTapCancel: onNavigationCancel,
                      onDoubleTapCancel: onViewImage == null
                          ? null
                          : onNavigationCancel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          layoutBuilder: (current, previous) => Stack(
            fit: StackFit.expand,
            children: [
              for (final child in previous)
                HeroMode(
                  enabled: false,
                  child: ExcludeSemantics(child: IgnorePointer(child: child)),
                ),
              ?current,
            ],
          ),
          duration:
              MediaQuery.disableAnimationsOf(context) ||
                  MediaQuery.accessibleNavigationOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          child: RepaintBoundary(
            key: ValueKey('storyViewer_frame_${post.id}'),
            child: StorySlide(
              key: ValueKey('storyViewer_slide_${post.id}'),
              title: post.title,
              meta: '$sourceName · $resolvedTime',
              lead: post.description,
              imageUrl: post.imageUrl,
              readLabel: l10n.storyRead,
              onRead: onRead,
              onMediaReady: onMediaReady,
              imageHeroTag: imageHeroTag,
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: top,
          child: Column(
            children: [
              IgnorePointer(
                child: StoryProgressBars(
                  count: posts.length,
                  index: index,
                  progress: timer,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _StoryHeader(
                sourceName: sourceName,
                avatarUrl: avatarUrl,
                time: time,
                onClose: onClose,
                heroTag: heroTag,
                onViewImage: onViewImage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StoryInitials extends StatelessWidget {
  const _StoryInitials({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      feedAbbreviation(name),
      style: AppText.sans(12, FontWeight.w800, height: 1).copyWith(
        color: context.colors.onAccent,
      ),
    ),
  );
}

class _StoryStagePlaceholder extends StatelessWidget {
  const _StoryStagePlaceholder({
    required this.pending,
    required this.failed,
    required this.sourceName,
    required this.onClose,
    required this.onRetry,
    this.avatarUrl,
    this.heroTag,
  });

  final bool pending;
  final bool failed;
  final String sourceName;
  final String? avatarUrl;
  final VoidCallback onClose;
  final VoidCallback onRetry;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = math.max<double>(
      StoryLayout.topInset,
      MediaQuery.paddingOf(context).top + AppSpacing.md,
    );
    return Stack(
      key: Key(
        pending
            ? 'storyViewer_pending'
            : failed
            ? 'storyViewer_failure'
            : 'storyViewer_empty',
      ),
      fit: StackFit.expand,
      children: [
        const StoryBackdrop(),
        if (!pending)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: failed
                  ? AppErrorState(
                      lineIcon: AppLineIcon.alert,
                      title: l10n.loadingError,
                      message: '',
                      primaryLabel: l10n.retry,
                      onPrimary: onRetry,
                      footnote: null,
                    )
                  : AppEmptyState(title: l10n.storyEmpty),
            ),
          ),
        Positioned(
          left: 16,
          right: 16,
          top: top,
          child: Column(
            children: [
              const IgnorePointer(
                child: StoryProgressBars(
                  count: 1,
                  index: 0,
                  progress: AlwaysStoppedAnimation<double>(0),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _StoryHeader(
                sourceName: sourceName,
                avatarUrl: avatarUrl,
                onClose: onClose,
                heroTag: heroTag,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
