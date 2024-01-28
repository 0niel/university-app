import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/widgets/lector_search_card.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

final GlobalKey<FloatingSearchBarState> _searchBarKey = GlobalKey<FloatingSearchBarState>();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Преподаватели"),
        backgroundColor: AppTheme.colorsOf(context).background01,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AppTheme.colorsOf(context).background01,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState.status == UserStatus.authorized && userState.user != null) {
              return BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  return FloatingSearchBar(
                    key: _searchBarKey,
                    controller: _controller,
                    elevation: 0,
                    backdropColor: AppTheme.colorsOf(context).background01,
                    shadowColor: AppTheme.colorsOf(context).background03,
                    accentColor: AppTheme.colorsOf(context).primary,
                    iconColor: AppTheme.colorsOf(context).active,
                    backgroundColor: AppTheme.colorsOf(context).background02,
                    hint: 'Начните вводить фамилию',
                    body: _controller.isOpen == false || _controller.isHidden
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.magnifyingGlass, size: 85),
                              const SizedBox(height: 24),
                              Text('Здесь появятся результаты поиска',
                                  style: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).deactive)),
                            ],
                          )
                        : Container(),
                    hintStyle: AppTextStyle.titleS.copyWith(color: AppTheme.colorsOf(context).deactive),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                    transitionDuration: const Duration(milliseconds: 800),
                    transitionCurve: Curves.easeInOut,
                    physics: const BouncingScrollPhysics(),
                    openAxisAlignment: 0.0,
                    debounceDelay: const Duration(milliseconds: 500),
                    progress: state is EmployeeLoading,
                    onQueryChanged: (query) {
                      if (query.length > 2) {
                        context.read<EmployeeBloc>().add(LoadEmployees(name: query));
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
                            color: AppTheme.colorsOf(context).background02,
                            elevation: 4.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                state.employees.length,
                                (index) => LectorSearchCard(employee: state.employees[index]),
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
