import 'package:equatable/equatable.dart';

sealed class LostFoundFailure with EquatableMixin implements Exception {
  const LostFoundFailure(this.error, {this.cleanupPaths = const []});

  final Object error;
  final List<String> cleanupPaths;

  @override
  List<Object?> get props => [error, cleanupPaths];
}

final class CreateLostFoundItemFailure extends LostFoundFailure {
  const CreateLostFoundItemFailure(super.error, {super.cleanupPaths});
}

final class LostFoundUploadFailure extends LostFoundFailure {
  const LostFoundUploadFailure(super.error, {super.cleanupPaths});
}

final class UpdateLostFoundItemFailure extends LostFoundFailure {
  const UpdateLostFoundItemFailure(super.error);
}

final class DeleteLostFoundItemFailure extends LostFoundFailure {
  const DeleteLostFoundItemFailure(super.error);
}

final class GetLostFoundItemsFailure extends LostFoundFailure {
  const GetLostFoundItemsFailure(super.error);
}

final class SearchLostFoundItemsFailure extends LostFoundFailure {
  const SearchLostFoundItemsFailure(super.error);
}

final class GetLostFoundItemFailure extends LostFoundFailure {
  const GetLostFoundItemFailure(super.error);
}
