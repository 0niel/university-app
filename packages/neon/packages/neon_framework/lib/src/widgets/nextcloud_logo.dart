import 'package:flutter/widgets.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// The Nextcloud logo, in widget form.
///
/// For guidelines on using the Nextcloud logo, visit https://nextcloud.com/trademarks.
class NextcloudLogo extends StatelessWidget {
  /// Creates a widget that shows the Nextcloud logo.
  const NextcloudLogo({
    this.size = 100,
    super.key,
  });

  /// The size of the logo in logical pixels.
  ///
  /// The logo will be fit into a square this size.
  final double size;

  @override
  Widget build(BuildContext context) => VectorGraphic(
        width: size,
        height: size,
        loader: const AssetBytesLoader(
          'assets/logo_nextcloud.svg.vec',
          packageName: 'neon_framework',
        ),
        semanticsLabel: NeonLocalizations.of(context).nextcloudLogo,
      );
}
