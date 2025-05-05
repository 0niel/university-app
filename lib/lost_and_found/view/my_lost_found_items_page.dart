import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/loading_state_widget.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/widgets.dart';

class MyLostFoundItemsPage extends StatefulWidget {
  const MyLostFoundItemsPage({super.key});

  @override
  State<MyLostFoundItemsPage> createState() => _MyLostFoundItemsPageState();
}

class _MyLostFoundItemsPageState extends State<MyLostFoundItemsPage> {
  List<LostFoundItem> _items = [];
  bool _isLoading = true;
  String? _error;
  final _filters = <LostFoundItemStatus?>[null, LostFoundItemStatus.lost, LostFoundItemStatus.found];
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMyItems();
  }

  Future<void> _loadMyItems({LostFoundItemStatus? status}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = context.read<AppBloc>().state.user.id;
      final repository = context.read<LostFoundRepository>();

      // Use the updated getUserItems method with status parameter
      final items = await repository.getUserItems(authorId: userId, status: status);

      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterItems(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
    _loadMyItems(status: _filters[index]);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: appColors.background01,
      appBar: AppBar(
        backgroundColor: appColors.surface,
        elevation: 0,
        title: Text(
          'Мои объявления',
          style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateLostFoundItemPage()),
              ).then((_) => _loadMyItems(status: _filters[_selectedFilterIndex]));
            },
            icon: Icon(Icons.add_circle_outline_rounded, color: appColors.primary),
            tooltip: 'Создать объявление',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadMyItems(status: _filters[_selectedFilterIndex]),
              color: appColors.primary,
              child: _buildContent(appColors),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      color: appColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(0, 'Все'),
            const SizedBox(width: 8),
            _buildFilterChip(1, 'Потеряно'),
            const SizedBox(width: 8),
            _buildFilterChip(2, 'Найдено'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isSelected = _selectedFilterIndex == index;

    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      backgroundColor: appColors.surfaceLow,
      selectedColor: appColors.primary.withOpacity(0.1),
      side: BorderSide(color: isSelected ? appColors.primary : appColors.borderLight, width: isSelected ? 1.0 : 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: Text(
        label,
        style: AppTextStyle.body.copyWith(
          color: isSelected ? appColors.primary : appColors.deactive,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onSelected: (_) => _filterItems(index),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  Widget _buildContent(AppColors appColors) {
    if (_isLoading) {
      return const LoadingStateWidget();
    }

    if (_error != null) {
      return ErrorStateWidget(
        message: 'Ошибка: $_error',
        onRetry: () => _loadMyItems(status: _filters[_selectedFilterIndex]),
      );
    }

    if (_items.isEmpty) {
      final IconData emptyIcon;
      final String emptyMessage;

      switch (_selectedFilterIndex) {
        case 1:
          emptyIcon = Icons.search_off;
          emptyMessage = 'У вас нет объявлений о потерянных вещах';
          break;
        case 2:
          emptyIcon = Icons.check_circle_outline;
          emptyMessage = 'У вас нет объявлений о найденных вещах';
          break;
        default:
          emptyIcon = Icons.article_outlined;
          emptyMessage = 'У вас нет объявлений';
      }

      return EmptyStateWidget(
        message: emptyMessage,
        icon: emptyIcon,
        buttonText: 'Создать объявление',
        onButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateLostFoundItemPage()),
          ).then((_) => _loadMyItems(status: _filters[_selectedFilterIndex]));
        },
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return LostFoundItemCard(
          item: _items[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LostFoundDetailPage(item: _items[index])),
            ).then((_) => _loadMyItems(status: _filters[_selectedFilterIndex]));
          },
        );
      },
    );
  }
}
