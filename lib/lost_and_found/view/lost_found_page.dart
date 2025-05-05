import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/loading_state_widget.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/widgets.dart';
import 'package:university_app_server_api/client.dart';

class LostFoundPage extends StatefulWidget {
  const LostFoundPage({super.key});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Listen for text changes to update search
    _searchController.addListener(() {
      if (_searchController.text.isEmpty && _isSearching) {
        setState(() => _isSearching = false);
        context.read<LostFoundBloc>().add(LoadLostFoundItems(status: _getCurrentTabStatus()));
      } else if (_searchController.text.isNotEmpty && !_isSearching) {
        setState(() => _isSearching = true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _performSearch();
    }
  }

  LostFoundItemStatus? _getCurrentTabStatus() {
    switch (_tabController.index) {
      case 1:
        return LostFoundItemStatus.lost;
      case 2:
        return LostFoundItemStatus.found;
      default:
        return null;
    }
  }

  void _performSearch() {
    final text = _searchController.text.trim();
    final bloc = context.read<LostFoundBloc>();

    if (text.isNotEmpty) {
      bloc.add(
        SearchLostFoundItems(
          text,
          // status: _getCurrentTabStatus(),
        ),
      );
    } else {
      bloc.add(LoadLostFoundItems(status: _getCurrentTabStatus()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isLoggedIn) {
          context.read<LostFoundBloc>().add(LoadLostFoundItems(status: _getCurrentTabStatus()));
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: appColors.background01,
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              // Search bar
              _buildSearchBar(context),

              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: appColors.surface,
                  border: Border(bottom: BorderSide(color: appColors.divider, width: 0.5)),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [Tab(text: 'Все'), Tab(text: 'Потеряно'), Tab(text: 'Найдено')],
                  indicatorColor: appColors.primary,
                  indicatorWeight: 3,
                  labelColor: appColors.primary,
                  unselectedLabelColor: appColors.deactive,
                  labelStyle: AppTextStyle.bodyBold,
                  unselectedLabelStyle: AppTextStyle.body,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _LostFoundItemList(),
                    _LostFoundItemList(status: LostFoundItemStatus.lost),
                    _LostFoundItemList(status: LostFoundItemStatus.found),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(context),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return AppBar(
      backgroundColor: appColors.surface,
      elevation: 0,
      title: Text(
        'Бюро находок',
        style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person_outline, color: appColors.active),
          tooltip: 'Мои объявления',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyLostFoundItemsPage()),
            ).then((_) => _performSearch());
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      color: appColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: appColors.surfaceLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.borderLight),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Поиск по объявлениям...',
            hintStyle: AppTextStyle.body.copyWith(color: appColors.deactive),
            prefixIcon: Icon(Icons.search, color: appColors.deactive, size: 20),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: appColors.deactive, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch();
                        _searchFocusNode.unfocus();
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          ),
          style: AppTextStyle.body.copyWith(color: appColors.active),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performSearch(),
          onTapOutside: (_) => _searchFocusNode.unfocus(),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isLoggedIn = context.select<AppBloc, bool>((bloc) => bloc.state.status.isLoggedIn);

    return FloatingActionButton.extended(
      onPressed: () {
        if (isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateLostFoundItemPage()),
          ).then((_) => _performSearch());
        } else {
          _showLoginDialog(context);
        }
      },
      backgroundColor: appColors.primary,
      foregroundColor: appColors.white,
      elevation: 2,
      icon: const Icon(Icons.add),
      label: const Text('Объявление'),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Вход в систему',
              style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
            ),
            content: Text(
              'Для создания объявления необходимо авторизоваться.',
              style: AppTextStyle.body.copyWith(color: appColors.deactive),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена', style: TextStyle(color: appColors.deactive)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, LoginWithEmailPage.route());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Войти', style: TextStyle(color: appColors.white)),
              ),
            ],
          ),
    );
  }
}

class _LostFoundItemList extends StatelessWidget {
  final LostFoundItemStatus? status;

  const _LostFoundItemList({this.status});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return BlocBuilder<LostFoundBloc, LostFoundState>(
      builder: (context, state) {
        if (state is LostFoundInitial) {
          context.read<LostFoundBloc>().add(LoadLostFoundItems(status: status));
          return const LoadingStateWidget();
        } else if (state is LostFoundLoading) {
          return const LoadingStateWidget();
        } else if (state is LostFoundLoaded) {
          final items = state.items;
          if (items.isEmpty) {
            return _buildEmptyState(context, false);
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<LostFoundBloc>().add(LoadLostFoundItems(status: status));
              return Future.delayed(const Duration(milliseconds: 500));
            },
            color: appColors.primary,
            child: _buildItemsList(context, items),
          );
        } else if (state is LostFoundError) {
          return ErrorStateWidget(
            message: 'Ошибка: ${state.message}',
            onRetry: () {
              context.read<LostFoundBloc>().add(LoadLostFoundItems(status: status));
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearchResult) {
    final isLoggedIn = context.select<AppBloc, bool>((bloc) => bloc.state.status.isLoggedIn);

    return EmptyStateWidget(
      message:
          isSearchResult
              ? 'Ничего не найдено'
              : status == LostFoundItemStatus.lost
              ? 'Нет потерянных вещей'
              : status == LostFoundItemStatus.found
              ? 'Нет найденных вещей'
              : 'Нет объявлений',
      icon: isSearchResult ? Icons.search_off : Icons.inbox,
      buttonText: isLoggedIn ? 'Создать объявление' : 'Войти',
      onButtonPressed: () {
        if (isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateLostFoundItemPage()),
          ).then((_) => context.read<LostFoundBloc>().add(LoadLostFoundItems(status: status)));
        } else {
          Navigator.push(context, LoginWithEmailPage.route());
        }
      },
    );
  }

  Widget _buildItemsList(BuildContext context, List<LostFoundItem> items) {
    final physics = AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics());

    return ListView.builder(
      itemCount: items.length,
      physics: physics,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        // Subtle fade-in animation with small delay based on index
        return FadeTransition(
          opacity: TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 1.0),
          ]).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Interval(
                0.1 + (index * 0.05).clamp(0.0, 0.4),
                0.5 + (index * 0.05).clamp(0.0, 0.4),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
              CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Interval(
                  0.1 + (index * 0.05).clamp(0.0, 0.4),
                  0.5 + (index * 0.05).clamp(0.0, 0.4),
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
            child: LostFoundItemCard(
              item: items[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LostFoundDetailPage(item: items[index])),
                ).then((_) => context.read<LostFoundBloc>().add(LoadLostFoundItems(status: status)));
              },
            ),
          ),
        );
      },
    );
  }
}
