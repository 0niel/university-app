import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neon_framework/theme.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'dart:developer';
import 'package:flutter/painting.dart' as painting;
import 'package:http/http.dart' as http;
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';

/// The custom theme used in the Neon app.
final neonTheme = NeonTheme(
  branding: branding,
  colorScheme: colorScheme,
);

/// The custom branding used in the Neon app.
final branding = Branding(
  name: 'Cloud Mirea Ninja',
  logo: VectorGraphic(
    width: 100,
    height: 100,
    colorFilter: ColorFilter.mode(
      AppTheme.colors.primary,
      painting.BlendMode.srcIn,
    ),
    loader: const NetworkSvgLoader(
      'https://cdn2.mirea.ninja/original/2X/7/78bcc63aff95d9ad39e6a4de12937f45c97c8cb5.svg',
    ),
  ),
  showLoginWithNextcloud: false,
  sourceCodeURL: 'https://github.com/0niel/university-app',
  issueTrackerURL: 'https://github.com/0niel/university-app/issues',
  legalese: 'Copyright © 2024, provokateurin\nUnder GPLv3 license',
);

/// The custom color scheme used in the Neon app.
final colorScheme = NeonColorScheme(
  primary: AppTheme.colors.primary,
);

class NetworkSvgLoader extends BytesLoader {
  const NetworkSvgLoader(this.url);

  final String url;

  @override
  Future<ByteData> loadBytes(BuildContext? context) async {
    return await compute((String svgUrl) async {
      final http.Response request = await http.get(Uri.parse(svgUrl));
      final TimelineTask task = TimelineTask()..start('encodeSvg');
      final Uint8List compiledBytes = encodeSvg(
        xml: request.body,
        debugName: svgUrl,
        enableClippingOptimizer: false,
        enableMaskingOptimizer: false,
        enableOverdrawOptimizer: false,
      );
      task.finish();
      return compiledBytes.buffer.asByteData();
    }, url, debugLabel: 'Load Bytes');
  }

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) {
    return other is NetworkSvgLoader && other.url == url;
  }
}
