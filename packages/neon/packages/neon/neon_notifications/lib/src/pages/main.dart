import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_notifications/l10n/localizations.dart';
import 'package:neon_notifications/src/blocs/notifications.dart';
import 'package:nextcloud/ids.dart';
import 'package:nextcloud/notifications.dart' as notifications;

class NotificationsMainPage extends StatefulWidget {
  const NotificationsMainPage({
    super.key,
  });

  @override
  State<NotificationsMainPage> createState() => _NotificationsMainPageState();
}

class _NotificationsMainPageState extends State<NotificationsMainPage> {
  late NotificationsBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = NeonProvider.of<NotificationsBlocInterface>(context) as NotificationsBloc;

    bloc.errors.listen((error) {
      NeonError.showSnackbar(context, error);
    });
  }

  @override
  Widget build(BuildContext context) => ResultBuilder<BuiltList<notifications.Notification>>.behaviorSubject(
        subject: bloc.notificationsList,
        builder: (context, notifications) => Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: StreamBuilder<int>(
            stream: bloc.unreadCounter,
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;
              return FloatingActionButton(
                onPressed: unreadCount > 0 ? bloc.deleteAllNotifications : null,
                tooltip: NotificationsLocalizations.of(context).notificationsDismissAll,
                child: const Icon(MdiIcons.checkAll),
              );
            },
          ),
          body: NeonListView(
            scrollKey: 'notifications-notifications',
            isLoading: notifications.isLoading,
            error: notifications.error,
            onRefresh: bloc.refresh,
            itemCount: notifications.data?.length,
            itemBuilder: (context, index) => _buildNotification(context, notifications.data![index]),
          ),
        ),
      );

  Widget _buildNotification(
    BuildContext context,
    notifications.Notification notification,
  ) {
    final app = NeonProvider.of<Iterable<AppImplementation>>(context).tryFind(notification.app);

    return ListTile(
      title: Text(notification.subject),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notification.message.isNotEmpty) ...[
            Text(
              notification.message,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
          RelativeTime(
            date: DateTime.parse(notification.datetime),
          ),
        ],
      ),
      leading: app != null
          ? app.buildIcon(
              size: largeIconSize,
            )
          : SizedBox.fromSize(
              size: const Size.square(largeIconSize),
              child: NeonUrlImage(
                uri: Uri.parse(notification.icon!),
                size: const Size.square(largeIconSize),
                svgColorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
              ),
            ),
      onTap: () async {
        if (notification.app == AppIDs.notifications) {
          return;
        }
        if (app != null) {
          // TODO: use go_router once implemented
          final accountsBloc = NeonProvider.of<AccountsBloc>(context);
          accountsBloc.activeAppsBloc.setActiveApp(app.id);
        } else {
          await showUnimplementedDialog(
            context: context,
            title: NotificationsLocalizations.of(context).notificationAppNotImplementedYet,
          );
        }
      },
      onLongPress: () {
        bloc.deleteNotification(notification.notificationId);
      },
    );
  }
}
