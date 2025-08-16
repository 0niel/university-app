import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/search.dart';

class SearchModeSelect extends StatelessWidget {
  const SearchModeSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final tabs = [
          context.l10n.all,
          context.l10n.groups,
          context.l10n.teachers,
          context.l10n.classrooms,
        ];
        final selectedIndex = SearchMode.values.indexOf(state.searchMode);

        final icons = <Widget?>[
          null,
          _buildIcon(
            context,
            Assets.icons.hugeicons.userGroup,
            selectedIndex == 1,
          ),
          _buildIcon(
            context,
            Assets.icons.hugeicons.teaching,
            selectedIndex == 2,
          ),
          _buildIcon(
            context,
            Assets.icons.hugeicons.building06,
            selectedIndex == 3,
          ),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CategoryTabBar(
            tabs: tabs,
            icons: icons,
            selectedIndex: selectedIndex,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: (index) {
              final mode = SearchMode.values[index];
              context.read<SearchBloc>().add(
                ChangeSearchMode(searchMode: mode),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context, dynamic iconAsset, bool isActive) {
    return SizedBox(
      width: 16,
      height: 16,
      child: iconAsset.svg(
        color: _getIconColor(context, isActive),
        width: 16.0,
        height: 16.0,
      ),
    );
  }

  Color _getIconColor(BuildContext context, bool isActive) {
    return isActive
        ? Theme.of(context).extension<AppColors>()!.active
        : Theme.of(context).extension<AppColors>()!.deactive;
  }
}
