part of 'sponsors_bloc.dart';

enum SponsorsStatus {
  initial,
  loading,
  loaded,
  failure,
}

class SponsorsState extends Equatable {
  const SponsorsState({
    required this.sponsors,
    required this.status,
  });

  const SponsorsState.initial()
      : this(
          sponsors: const SponsorsResponse(sponsors: []),
          status: SponsorsStatus.initial,
        );

  final SponsorsResponse sponsors;
  final SponsorsStatus status;

  @override
  List<Object?> get props => [sponsors, status];

  SponsorsState copyWith({
    SponsorsResponse? sponsors,
    SponsorsStatus? status,
  }) {
    return SponsorsState(
      sponsors: sponsors ?? this.sponsors,
      status: status ?? this.status,
    );
  }
}
