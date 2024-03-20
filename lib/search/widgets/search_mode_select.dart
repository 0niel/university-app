import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/search/search.dart';

class SearchModeSelect extends StatelessWidget {
  const SearchModeSelect({Key? key}) : super(key: key);

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
                ModeSelectButton(
                  isActive: state.searchMode == SearchMode.all,
                  text: "Все",
                  onClick: () {
                    context.read<SearchBloc>().add(const ChangeSearchMode(searchMode: SearchMode.all));
                  },
                ),
                ModeSelectButton(
                  isActive: state.searchMode == SearchMode.groups,
                  text: "Группы",
                  icon: const Icon(FontAwesomeIcons.userGraduate, size: 16),
                  onClick: () {
                    context.read<SearchBloc>().add(const ChangeSearchMode(searchMode: SearchMode.groups));
                  },
                ),
                ModeSelectButton(
                  isActive: state.searchMode == SearchMode.teachers,
                  text: "Преподаватели",
                  icon: const Icon(FontAwesomeIcons.chalkboardUser, size: 16),
                  onClick: () {
                    context.read<SearchBloc>().add(const ChangeSearchMode(searchMode: SearchMode.teachers));
                  },
                ),
                ModeSelectButton(
                  isActive: state.searchMode == SearchMode.classrooms,
                  text: "Аудитории",
                  icon: const Icon(FontAwesomeIcons.building, size: 16),
                  onClick: () {
                    context.read<SearchBloc>().add(const ChangeSearchMode(searchMode: SearchMode.classrooms));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
