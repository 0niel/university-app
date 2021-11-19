import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ProfileLectrosPage extends StatelessWidget {
  const ProfileLectrosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Преподаватели',
          style: DarkTextTheme.title,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is LogInSuccess) {
                return BlocBuilder<EmployeeBloc, EmployeeState>(
                  builder: (context, state) {
                    return FloatingSearchBar(
                      accentColor: DarkThemeColors.primary,
                      iconColor: DarkThemeColors.white,
                      backgroundColor: DarkThemeColors.background02,
                      hint: 'Начните вводить имя',
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
                          context.read<EmployeeBloc>().add(LoadEmployees(
                              token: authState.token, name: query));
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
                              color: Colors.white,
                              elevation: 4.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  state.employees.length,
                                  (index) => Container(
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    color: DarkThemeColors.background02,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.employees[index].name +
                                              ' ' +
                                              state
                                                  .employees[index].secondName +
                                              ' ' +
                                              state.employees[index].lastName,
                                          style: DarkTextTheme.bodyBold,
                                        ),
                                        Text(
                                          state.employees[index].email,
                                          style: DarkTextTheme.bodyRegular
                                              .copyWith(
                                                  color: DarkThemeColors
                                                      .colorful02),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(state.employees[index].post,
                                            style: DarkTextTheme.bodyRegular),
                                        Text(state.employees[index].department,
                                            style: DarkTextTheme.bodyRegular),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Кол-во занимаемых ставок: ' +
                                              state.employees[index].rate,
                                          style: DarkTextTheme.bodyRegular
                                              .copyWith(
                                                  color:
                                                      DarkThemeColors.deactive),
                                        ),
                                        Text(
                                          'Вид занятости: ' +
                                              state.employees[index]
                                                  .employmentKind,
                                          style: DarkTextTheme.bodyRegular
                                              .copyWith(
                                                  color:
                                                      DarkThemeColors.deactive),
                                        ),
                                        Text(
                                          'Дата приема на работу: ' +
                                              state.employees[index]
                                                  .employmentDate,
                                          style: DarkTextTheme.bodyRegular
                                              .copyWith(
                                                  color:
                                                      DarkThemeColors.deactive),
                                        ),
                                        Text(
                                          'Дата увольнения: ' +
                                              state.employees[index].fireDate,
                                          style: DarkTextTheme.bodyRegular
                                              .copyWith(
                                                  color:
                                                      DarkThemeColors.deactive),
                                        ),
                                      ],
                                    ),
                                  ),
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
      ),
    );
  }
}
