import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_widget_parsers.dart';
import 'package:stac_bridge/stac_bridge.dart';

import 'kit_harness.dart';

void main() {
  setUpAll(
    () => StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => null,
      ),
    ),
  );

  const photo = <String, dynamic>{
    'type': 'appImage',
    'src': 'https://example.test/photo.png',
    'width': 180,
    'height': 120,
  };

  testWidgets('standalone appImage opens a matching fullscreen gallery', (
    tester,
  ) async {
    await pumpKit(tester, const StacAppImageParser(), photo);
    await tester.tap(find.byType(KitNetworkImage));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final gallery = tester.widget<ImagesViewGallery>(
      find.byType(ImagesViewGallery),
    );
    expect(gallery.imageUrls, ['https://example.test/photo.png']);
    expect(gallery.heroTags[0], isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('parent card action wins when its child is an appImage', (
    tester,
  ) async {
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await pumpKit(tester, const StacAppCardParser(), {
      'onTap': {'actionType': 'setState', 'key': 'clicked', 'value': true},
      'child': photo,
    }, store: store);
    await tester.tap(find.byType(KitNetworkImage));
    await tester.pump();
    expect(store.get('clicked'), true);
    expect(find.byType(ImagesViewGallery), findsNothing);
  });

  testWidgets('authored image action wins over automatic preview', (
    tester,
  ) async {
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await pumpKit(tester, const StacAppImageParser(), {
      ...photo,
      'onTap': {'actionType': 'setState', 'key': 'clicked', 'value': true},
    }, store: store);
    await tester.tap(find.byType(KitNetworkImage));
    await tester.pump();
    expect(store.get('clicked'), true);
    expect(find.byType(ImagesViewGallery), findsNothing);
  });

  testWidgets('preview can be disabled for authored decorative images', (
    tester,
  ) async {
    await pumpKit(tester, const StacAppImageParser(), {
      ...photo,
      'enablePreview': false,
    });
    await tester.tap(find.byType(KitNetworkImage));
    await tester.pump();
    expect(find.byType(ImagesViewGallery), findsNothing);
  });
}
