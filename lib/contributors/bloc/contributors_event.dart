part of 'contributors_bloc.dart';

abstract class ContributorsEvent extends Equatable {
  const ContributorsEvent();
}

class ContributorsRequested extends ContributorsEvent {
  const ContributorsRequested();

  @override
  List<Object?> get props => [];
}
