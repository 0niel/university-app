import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/widgets/lector_search_card.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ProfileLectrosPage extends StatefulWidget {
  const ProfileLectrosPage({Key? key}) : super(key: key);

  @override
  State<ProfileLectrosPage> createState() => _ProfileLectrosPageState();
}

class _ProfileLectrosPageState extends State<ProfileLectrosPage> {
  late FloatingSearchBarController _controller;

  @override
  void initState() {
    _controller = FloatingSearchBarController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Преподаватели"),
        backgroundColor: DarkThemeColors.background01,
      ),
      backgroundColor: DarkThemeColors.background01,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is LogInSuccess) {
              return BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  return FloatingSearchBar(
                    controller: _controller,
                    backdropColor: DarkThemeColors.background01,
                    shadowColor: DarkThemeColors.background03,
                    accentColor: DarkThemeColors.primary,
                    iconColor: DarkThemeColors.white,
                    backgroundColor: DarkThemeColors.background02,
                    hint: 'Начните вводить фамилию',
                    body: _controller.isOpen == false || _controller.isHidden
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.search, size: 85),
                              const SizedBox(height: 24),
                              Text('Здесь появятся результаты поиска',
                                  style: DarkTextTheme.body)
                            ],
                          )
                        : Container(),
                    hintStyle: DarkTextTheme.titleS
                        .copyWith(color: DarkThemeColors.deactive),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                    transitionDuration: const Duration(milliseconds: 800),
                    transitionCurve: Curves.easeInOut,
                    physics: const BouncingScrollPhysics(),
                    axisAlignment: isPortrait ? 0.0 : -1.0,
                    openAxisAlignment: 0.0,
                    width: isPortrait ? 600 : 500,
                    debounceDelay: const Duration(milliseconds: 500),
                    progress: state is EmployeeLoading,
                    onQueryChanged: (query) {
                      if (query.length > 2) {
                        context.read<EmployeeBloc>().add(
                            LoadEmployees(token: authState.token, name: query));
                      }
                    },
                    transition: CircularFloatingSearchBarTransition(),
                    actions: [
                      FloatingSearchBarAction(
                        showIfOpened: false,
                        child: CircularButton(
                          icon: const Icon(Icons.people_rounded),
                          onPressed: () {},
                        ),
                      ),
                      FloatingSearchBarAction.searchToClear(
                        showIfClosed: false,
                      ),
                    ],
                    builder: (context, transition) {
                      if (state is EmployeeLoaded) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Material(
                            color: DarkThemeColors.background02,
                            elevation: 4.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                state.employees.length,
                                (index) => LectorSearchCard(
                                    employee: state.employees[index]),
                              ),
                            ),
                          ),
                        );
                      } else if (state is EmployeeItemsNotFound) {
                        return const Center(child: Text("Ничего не найдено"));
                      }

                      return Container();
                    },
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
