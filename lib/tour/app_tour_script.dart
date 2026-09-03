import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/app_tour_controller.dart';
import 'package:rtu_mirea_app/tour/model/app_tour_step.dart';

List<AppTourStep> buildAppTourSteps(AppLocalizations l10n) => [
  AppTourStep(
    title: l10n.tourNavTitle,
    body: l10n.tourNavBody,
    target: .navigationBar,
    location: '/feed',
    radius: AppRadius.spotlight,
    padding: 4,
    optional: false,
  ),
  AppTourStep(
    title: l10n.tourSearchTitle,
    body: l10n.tourSearchBody,
    target: .homeSearch,
    location: '/feed',
    shape: NinjaSpotlightShape.circle,
    padding: 6,
  ),
  AppTourStep(
    title: l10n.tourDaysTitle,
    body: l10n.tourDaysBody,
    target: .homeDays,
    location: '/feed',
    radius: AppRadius.field,
    padding: 6,
  ),
  AppTourStep(
    title: l10n.tourBoardTitle,
    body: l10n.tourBoardBody,
    target: .homeBoard,
    location: '/feed',
    radius: AppRadius.card,
  ),
  AppTourStep(
    title: l10n.tourServicesTitle,
    body: l10n.tourServicesBody,
    target: .homeServices,
    location: '/feed',
    radius: AppRadius.field,
  ),
  AppTourStep(
    title: l10n.tourScheduleViewsTitle,
    body: l10n.tourScheduleViewsBody,
    target: .scheduleViews,
    location: '/schedule',
    radius: AppRadius.full,
    padding: 6,
  ),
  AppTourStep(
    title: l10n.tourScheduleWeekTitle,
    body: l10n.tourScheduleWeekBody,
    target: .scheduleWeek,
    location: '/schedule',
    radius: AppRadius.field,
  ),
  AppTourStep(
    title: l10n.tourCatalogTitle,
    body: l10n.tourCatalogBody,
    target: .servicesCatalog,
    location: '/services',
    radius: AppRadius.field,
  ),
  AppTourStep(
    title: l10n.tourProfileTitle,
    body: l10n.tourProfileBody,
    target: .profileStats,
    location: '/profile',
    radius: AppRadius.card,
  ),
  AppTourStep(
    title: l10n.tourDoneTitle,
    body: l10n.tourDoneBody,
    location: '/feed',
    optional: false,
  ),
];

Future<void> startAppTour(BuildContext context) {
  context.read<HomeCubit>().dismissSearchCoach();
  return AppTourController.instance.start(buildAppTourSteps(context.l10n));
}
