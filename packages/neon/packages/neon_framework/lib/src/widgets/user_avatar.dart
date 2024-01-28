import 'package:flutter/material.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/theme/sizes.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/image.dart';
import 'package:neon_framework/src/widgets/server_icon.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/user_status.dart' as user_status;

/// A circle that contains the user profile image and status.
class NeonUserAvatar extends StatefulWidget {
  /// Creates a new Neon user avatar.
  NeonUserAvatar({
    required this.account,
    String? username,
    this.showStatus = true,
    this.size,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  }) : username = username ?? account.username;

  /// The account used to fetch the image.
  final Account account;

  /// The user profile to display
  final String username;

  /// Whether to show the status.
  final bool showStatus;

  /// The size of the avatar.
  final double? size;

  /// The color with which to fill the circle. Changing the background
  /// color will cause the avatar to animate to the new color.
  final Color? backgroundColor;

  /// The color used to render the loading animation.
  final Color? foregroundColor;

  @override
  State<NeonUserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<NeonUserAvatar> {
  late final _userStatusBloc = NeonProvider.of<AccountsBloc>(context).getUserStatusBlocFor(widget.account);
  late double size;

  @override
  void initState() {
    super.initState();

    if (widget.showStatus) {
      _userStatusBloc.load(widget.username);
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final brightness = Theme.of(context).brightness;
          size = constraints.constrain(Size.square(widget.size ?? largeIconSize)).shortestSide;
          final pixelSize = (size * MediaQuery.of(context).devicePixelRatio).toInt();

          final avatar = CircleAvatar(
            radius: size / 2,
            backgroundColor: widget.backgroundColor,
            child: ClipOval(
              child: NeonApiImage.withAccount(
                account: widget.account,
                cacheKey: 'avatar-${widget.username}-$brightness$pixelSize',
                getImage: (client) async => switch (brightness) {
                  Brightness.dark => client.core.avatar.getAvatarDark(
                      userId: widget.username,
                      size: pixelSize,
                    ),
                  Brightness.light => client.core.avatar.getAvatar(
                      userId: widget.username,
                      size: pixelSize,
                    ),
                },
              ),
            ),
          );

          if (!widget.showStatus) {
            return avatar;
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              avatar,
              ResultBuilder(
                stream: _userStatusBloc.statuses.map(
                  (statuses) => statuses[widget.username] ?? Result<user_status.$PublicInterface>.loading(),
                ),
                builder: _userStatusIconBuilder,
              ),
            ],
          );
        },
      );

  Widget _userStatusIconBuilder(BuildContext context, Result<user_status.$PublicInterface> result) {
    final hasEmoji = result.data?.icon != null;
    final scaledSize = size / (hasEmoji ? 2 : 2.5);

    Widget? child;
    if (result.isLoading) {
      child = CircularProgressIndicator(
        strokeWidth: 1.5,
        color: widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      );
    } else if (result.hasError) {
      child = Icon(
        Icons.error_outline,
        size: scaledSize,
        color: Theme.of(context).colorScheme.error,
      );
    } else if (hasEmoji) {
      child = Text(
        result.data!.icon!,
        style: const TextStyle(
          fontSize: 16,
        ),
      );
    } else if (result.hasData) {
      final type = result.data!.status;
      if (type != 'offline') {
        child = NeonServerIcon(icon: 'user-status-$type');
      }
    }

    return SizedBox.square(
      dimension: size,
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: scaledSize,
          height: scaledSize,
          child: child,
        ),
      ),
    );
  }
}
