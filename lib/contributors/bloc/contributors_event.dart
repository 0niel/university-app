part of 'contributors_bloc.dart';

abstract class ContributorsEvent extends Equatable {
  const ContributorsEvent();
}

class ContributorsLoadRequest extends ContributorsEvent {
  const ContributorsLoadRequest();

  @override
  List<Object?> get props => [];
}
