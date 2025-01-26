import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/search/search.dart';

class SearchModeSelect extends StatelessWidget {
  const SearchModeSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            height: 32,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildModeButton(
                  context,
                  isActive: state.searchMode == SearchMode.all,
                  text: "Все",
                  mode: SearchMode.all,
                ),
                _buildModeButton(
                  context,
                  isActive: state.searchMode == SearchMode.groups,
                  text: "Группы",
                  mode: SearchMode.groups,
                  icon: Assets.icons.hugeicons.userGroup
                      .svg(color: _getIconColor(context, state.searchMode == SearchMode.groups)),
                ),
                _buildModeButton(
                  context,
                  isActive: state.searchMode == SearchMode.teachers,
                  text: "Преподаватели",
                  mode: SearchMode.teachers,
                  icon: Assets.icons.hugeicons.teaching
                      .svg(color: _getIconColor(context, state.searchMode == SearchMode.teachers)),
                ),
                _buildModeButton(
                  context,
                  isActive: state.searchMode == SearchMode.classrooms,
                  text: "Аудитории",
                  mode: SearchMode.classrooms,
                  icon: Assets.icons.hugeicons.building06
                      .svg(color: _getIconColor(context, state.searchMode == SearchMode.classrooms)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeButton(BuildContext context,
      {required bool isActive, required String text, required SearchMode mode, Widget? icon}) {
    return ModeSelectButton(
      isActive: isActive,
      text: text,
      icon: icon,
      onClick: () {
        context.read<SearchBloc>().add(ChangeSearchMode(searchMode: mode));
      },
    );
  }

  Color _getIconColor(BuildContext context, bool isActive) {
    return isActive
        ? Theme.of(context).extension<AppColors>()!.active
        : Theme.of(context).extension<AppColors>()!.deactive;
  }
}
