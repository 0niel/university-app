part of 'user_activities_cubit.dart';

@freezed
abstract class UserActivitiesState with _$UserActivitiesState {
  const factory UserActivitiesState({
    @Default(<UserActivity>[]) List<UserActivity> activities,
    @Default(UserActivitiesStatus.initial) UserActivitiesStatus status,
  }) = _UserActivitiesState;

  const UserActivitiesState._();

  List<UserActivity> forDay(DateTime day) {
    return activities
        .where(
          (activity) =>
              activity.startsAt.year == day.year &&
              activity.startsAt.month == day.month &&
              activity.startsAt.day == day.day,
        )
        .toList();
  }

  List<UserActivityType> typesOn(DateTime day) {
    final seen = <UserActivityType>{};
    for (final activity in forDay(day)) {
      seen.add(activity.type);
    }
    return seen.toList();
  }
}
