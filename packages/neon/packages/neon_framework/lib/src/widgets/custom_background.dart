import 'package:flutter/material.dart';
import 'package:neon_framework/src/theme/branding.dart';
import 'package:neon_framework/src/theme/neon.dart';
import 'package:neon_framework/src/theme/server.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/utils/hex_color.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/image.dart';
import 'package:neon_framework/src/widgets/options_collection_builder.dart';

/// Displays the custom background if the user has it enabled.
///
/// The background will be loaded from the server.
/// It might be a single color or a full image.
class NeonCustomBackground extends StatelessWidget {
  /// Creates a new custom background.
  const NeonCustomBackground({
    required this.child,
    super.key,
  });

  /// Widget displayed on top of the custom background.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final globalOptions = NeonProvider.of<GlobalOptions>(context);

    return OptionsCollectionBuilder(
      valueListenable: globalOptions,
      child: child,
      builder: (context, options, child) {
        if (!options.themeUseNextcloudTheme.value || !options.themeCustomBackground.value) {
          return child!;
        }

        final theme = Theme.of(context).extension<ServerTheme>()!.nextcloudTheme;

        if (theme == null) {
          return ColoredBox(
            color: Theme.of(context).colorScheme.background,
            child: child,
          );
        }

        if (theme.backgroundPlain) {
          return ColoredBox(
            color: Color.lerp(HexColor(theme.background), Colors.black, 0.5)!,
            child: child,
          );
        }

        return Stack(
          children: [
            Positioned.fill(
              child: NeonUrlImage(
                uri: Uri.parse(theme.background),
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            child!,
          ],
        );
      },
    );
  }
}
