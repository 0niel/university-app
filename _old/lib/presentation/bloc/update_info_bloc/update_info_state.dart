part of 'update_info_bloc.dart';

abstract class UpdateInfoState {
  const UpdateInfoState();
}

/// Need to show an update dialog
class ShowUpdateDialog extends UpdateInfoState {
  const ShowUpdateDialog({
    required this.data,
  });

  final UpdateInfo data;
}

/// Don't need to show
class NoUpdateDialog extends UpdateInfoState {
  const NoUpdateDialog();
}
