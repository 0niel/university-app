import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:university_app_server_api/client.dart';

import '../widgets/widgets.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final PageController _schedulePageController;

  @override
  void initState() {
    super.initState();
    _schedulePageController = PageController(
      initialPage: Calendar.getPageIndex(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _schedulePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state.selectedSchedule == null &&
            state.status != ScheduleStatus.loading) {
          return NoSelectedScheduleMessage(onTap: () {
            context.go('/schedule/search');
          });
        } else if (state.status == ScheduleStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == ScheduleStatus.loaded) {
          return Scaffold(
            appBar: AppBar(title: const Text('Расписание'), actions: [
              SizedBox(
                width: 60,
                height: 60,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.ellipsis,
                    color: AppTheme.colors.active,
                  ),
                  onPressed: () {
                    SettingsMenu.show(context);
                  },
                ),
              ),
            ]),
            backgroundColor: AppTheme.colors.background01,
            body: SafeArea(
              child: Column(
                children: [
                  Calendar(
                    pageViewController: _schedulePageController,
                    schedule: state.selectedSchedule?.schedule ?? [],
                  ),
                  Expanded(
                    child: EventsPageView(
                      controller: _schedulePageController,
                      itemBuilder: (context, index) {
                        final schedules = Calendar.getSchedulePartsByDay(
                          schedule: state.selectedSchedule?.schedule ?? [],
                          day: Calendar.firstCalendarDay
                              .add(Duration(days: index)),
                        );

                        final holiday = schedules.firstWhereOrNull(
                          (element) => element is HolidaySchedulePart,
                        );

                        if (holiday != null) {
                          return HolidayPage(
                              title: (holiday as HolidaySchedulePart).title);
                        }

                        return ListView(
                          children: schedules
                              .whereType<LessonSchedulePart>()
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: LessonCard(lesson: e),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}

// @visibleForTesting
// class ScheduleViewPopulated extends StatefulWidget {
//   const ScheduleViewPopulated({
//     required this.categories,
//     super.key,
//   });

//   final List<Category> categories;

//   @override
//   State<ScheduleViewPopulated> createState() => _ScheduleViewPopulatedState();
// }

// class _ScheduleViewPopulatedState extends State<ScheduleViewPopulated>
//     with SingleTickerProviderStateMixin, WidgetsBindingObserver {
//   late final TabController _tabController;

//   final Map<Category, ScrollController> _controllers =
//       <Category, ScrollController>{};

//   static const _categoryScrollToTopDuration = Duration(milliseconds: 300);

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _tabController = TabController(
//       length: widget.categories.length,
//       vsync: this,
//     )..addListener(_onTabChanged);
//     for (final category in widget.categories) {
//       _controllers[category] = ScrollController();
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       context.read<FeedBloc>().add(const FeedResumed());
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controllers.forEach((_, controller) => controller.dispose());
//     _tabController
//       ..removeListener(_onTabChanged)
//       ..dispose();
//     super.dispose();
//   }

//   void _onTabChanged() => context
//       .read<CategoriesBloc>()
//       .add(CategorySelected(category: widget.categories[_tabController.index]));

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<CategoriesBloc, CategoriesState>(
//       listener: (context, state) {
//         final selectedCategory = state.selectedCategory;
//         if (selectedCategory != null) {
//           final selectedCategoryIndex =
//               widget.categories.indexOf(selectedCategory);
//           if (selectedCategoryIndex != -1 &&
//               selectedCategoryIndex != _tabController.index) {
//             _tabController
//                 .animateTo(widget.categories.indexOf(selectedCategory));
//           }
//         }
//       },
//       listenWhen: (previous, current) =>
//           previous.selectedCategory != current.selectedCategory,
//       child: Column(
//         children: [
//           CategoriesTabBar(
//             controller: _tabController,
//             tabs: widget.categories
//                 .map(
//                   (category) => CategoryTab(
//                     categoryName: category.name,
//                     onDoubleTap: () {
//                       _controllers[category]?.animateTo(
//                         0,
//                         duration: _categoryScrollToTopDuration,
//                         curve: Curves.ease,
//                       );
//                     },
//                   ),
//                 )
//                 .toList(),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: widget.categories
//                   .map(
//                     (category) => CategoryFeed(
//                       key: PageStorageKey(category),
//                       category: category,
//                       scrollController: _controllers[category],
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
