part of 'contributors_bloc.dart';

enum ContributorsStatus {
  initial,
  loading,
  loaded,
  failure,
}

class ContributorsState extends Equatable {
  const ContributorsState({
    required this.contributors,
    required this.status,
  });

  const ContributorsState.initial()
      : this(
          contributors: const ContributorsResponse(contributors: []),
          status: ContributorsStatus.initial,
        );

  final ContributorsResponse contributors;
  final ContributorsStatus status;

  @override
  List<Object?> get props => [contributors, status];

  ContributorsState copyWith({
    ContributorsResponse? contributors,
    ContributorsStatus? status,
  }) {
    return ContributorsState(
      contributors: contributors ?? this.contributors,
      status: status ?? this.status,
    );
  }
}
