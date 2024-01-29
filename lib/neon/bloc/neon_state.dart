part of 'neon_bloc.dart';

class NeonState extends Equatable {
  const NeonState({
    required this.isRegisterOfferViewed,
  });

  const NeonState.initial()
      : this(
          isRegisterOfferViewed: false,
        );

  final bool isRegisterOfferViewed;

  @override
  List<Object?> get props => [isRegisterOfferViewed];

  NeonState copyWith({
    bool? isRegisterOfferViewed,
  }) {
    return NeonState(
      isRegisterOfferViewed:
          isRegisterOfferViewed ?? this.isRegisterOfferViewed,
    );
  }
}
