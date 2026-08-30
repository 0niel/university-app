import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

String miniAppStatusLabel(BuildContext context, MiniAppStatus status) {
  final l10n = context.l10n;
  return switch (status) {
    .draft => l10n.miniAppsStatusDraft,
    .pendingReview => l10n.miniAppsStatusPending,
    .published => l10n.miniAppsStatusPublished,
    .rejected => l10n.miniAppsStatusRejected,
    .suspended => l10n.miniAppsStatusSuspended,
  };
}

String miniAppCategoryLabel(BuildContext context, MiniAppCategory? category) {
  final l10n = context.l10n;
  return switch (category) {
    null => l10n.miniAppsCategoryAll,
    .study => l10n.miniAppsCategoryStudy,
    .campus => l10n.miniAppsCategoryCampus,
    .tools => l10n.miniAppsCategoryTools,
    .fun => l10n.miniAppsCategoryFun,
    .social => l10n.miniAppsCategorySocial,
    .other => l10n.miniAppsCategoryOther,
  };
}

String miniAppPermissionLabel(
  BuildContext context,
  MiniAppPermission permission,
) {
  final l10n = context.l10n;
  return switch (permission) {
    .identity => l10n.miniAppsPermIdentity,
    .email => l10n.miniAppsPermEmail,
    .profile => l10n.miniAppsPermProfile,
    .group => l10n.miniAppsPermGroup,
    .notifications => l10n.miniAppsPermNotifications,
    .location => l10n.miniAppsPermLocation,
    .camera => l10n.miniAppsPermCamera,
    .files => l10n.miniAppsPermFiles,
    .calendar => l10n.miniAppsPermCalendar,
  };
}

String miniAppPermissionDescription(
  BuildContext context,
  MiniAppPermission permission,
) {
  final l10n = context.l10n;
  return switch (permission) {
    .identity => l10n.miniAppsPermIdentityDesc,
    .email => l10n.miniAppsPermEmailDesc,
    .profile => l10n.miniAppsPermProfileDesc,
    .group => l10n.miniAppsPermGroupDesc,
    .notifications => l10n.miniAppsPermNotificationsDesc,
    .location => l10n.miniAppsPermLocationDesc,
    .camera => l10n.miniAppsPermCameraDesc,
    .files => l10n.miniAppsPermFilesDesc,
    .calendar => l10n.miniAppsPermCalendarDesc,
  };
}

AppLineIcon miniAppPermissionIcon(MiniAppPermission permission) {
  return switch (permission) {
    .identity => .user,
    .email => .mail,
    .profile => .clipboard,
    .group => .people,
    .notifications => .bell,
    .location => .pin,
    .camera => .camera,
    .files => .folder,
    .calendar => .calendar,
  };
}

String miniAppReportReasonLabel(
  BuildContext context,
  MiniAppReportReason reason,
) {
  final l10n = context.l10n;
  return switch (reason) {
    .spam => l10n.miniAppsReasonSpam,
    .inappropriate => l10n.miniAppsReasonInappropriate,
    .broken => l10n.miniAppsReasonBroken,
    .scam => l10n.miniAppsReasonScam,
    .privacy => l10n.miniAppsReasonPrivacy,
    .other => l10n.miniAppsReasonOther,
  };
}
