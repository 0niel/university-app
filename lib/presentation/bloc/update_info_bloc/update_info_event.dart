part of 'update_info_bloc.dart';

abstract class UpdateInfoEvent {
  const UpdateInfoEvent();
}

/// Set data got from Strapi
class SetUpdateInfo extends UpdateInfoEvent {
  const SetUpdateInfo({
    required this.data,
  });

  final UpdateInfo data;
}

/// Make dialog not show again
class DialogIsShown extends UpdateInfoEvent {
  const DialogIsShown();
}
