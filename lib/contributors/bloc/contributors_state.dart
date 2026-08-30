part of 'contributors_bloc.dart';

@freezed
abstract class ContributorsState with _$ContributorsState {
  const factory ContributorsState({
    @Default(ContributorsResponse(contributors: []))
    ContributorsResponse contributors,
    @Default(ContributorsStatus.initial) ContributorsStatus status,
  }) = _ContributorsState;

  const ContributorsState._();
}
