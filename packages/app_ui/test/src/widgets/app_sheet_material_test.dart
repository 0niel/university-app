import 'dart:async';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  testWidgets('glass sheet samples the page through its Material host', (
    tester,
  ) async {
    for (final colors in [AppColors.dark, AppColors.light]) {
      final backdrop = await _openSheet(tester, colors: colors);
      final before = await _surfacePixel(tester);
      backdrop.value = const Color(0xff264bd9);
      await tester.pump();
      final after = await _surfacePixel(tester);
      expect(after, isNot(equals(before)), reason: 'dark=${colors.isDark}');
      final material = tester.widget<Material>(_sheetMaterial());
      expect(material.type, MaterialType.transparency);
      expect(material.clipBehavior, Clip.antiAlias);
      expect(
        material.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('glass off keeps custom and default sheets opaque', (
    tester,
  ) async {
    for (final colors in [AppColors.dark, AppColors.light]) {
      for (final color in [null, const Color(0xff315a42)]) {
        final backdrop = await _openSheet(
          tester,
          colors: colors,
          glassEnabled: false,
          backgroundColor: color,
        );
        final before = await _surfacePixel(tester);
        backdrop.value = const Color(0xff264bd9);
        await tester.pump();
        expect(await _surfacePixel(tester), before);
        final expected = (color ?? colors.surface).toARGB32();
        expect(before, [
          (expected >> 16) & 255,
          (expected >> 8) & 255,
          expected & 255,
          255,
        ]);
        expect(find.byType(LiquidGlassLens), findsNothing);
        expect(find.byType(BackdropFilter), findsNothing);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('custom tint reaches the sheet frost without blocking taps', (
    tester,
  ) async {
    const color = Color(0xff315a42);
    var taps = 0;
    final backdrop = await _openSheet(
      tester,
      colors: AppColors.dark,
      backgroundColor: color,
      onTap: () => taps++,
    );
    final surface = tester.widget<AppGlassSurface>(
      find.byType(AppGlassSurface),
    );
    expect(surface.color, color);
    final glass = tester.widget<LiquidGlassLite>(find.byType(LiquidGlassLite));
    expect(
      glass.color!.toARGB32() & 0xffffff,
      color.toARGB32() & 0xffffff,
    );
    final before = await _surfacePixel(tester);
    backdrop.value = const Color(0xff264bd9);
    await tester.pump();
    expect(await _surfacePixel(tester), isNot(equals(before)));
    await tester.tap(find.byKey(const Key('sheet-tap-target')));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sheet toggle keeps its editor and ordinary outline', (
    tester,
  ) async {
    final setting = ValueNotifier(true);
    final controller = TextEditingController();
    addTearDown(setting.dispose);
    addTearDown(controller.dispose);
    await _openSheet(
      tester,
      colors: AppColors.dark,
      glassSetting: setting,
      child: TextField(
        key: const Key('editor'),
        controller: controller,
      ),
    );
    final field = find.byKey(const Key('editor'));
    await tester.enterText(field, 'draft');
    final element = tester.element(field);
    final bounds = tester.getRect(_sheetMaterial());
    for (final enabled in [true, false, true]) {
      setting.value = enabled;
      await tester.pumpAndSettle();
      expect(tester.element(field), same(element));
      expect(tester.widget<TextField>(field).controller, same(controller));
      expect(controller.text, 'draft');
      expect(tester.getRect(_sheetMaterial()), bounds);
      expect(find.byType(LiquidGlassLens), findsNothing);
      expect(
        tester.layers.whereType<BackdropFilterLayer>(),
        enabled ? hasLength(1) : isEmpty,
      );
      expect(
        tester.renderObject<RenderBox>(find.byType(AppGlassSurface)),
        paintsExactlyCountTimes(#drawVertices, 0),
      );
      final outline = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: _sheetMaterial(),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is DecoratedBox &&
                    widget.position == DecorationPosition.foreground &&
                    widget.decoration is BoxDecoration &&
                    (widget.decoration as BoxDecoration).border != null,
              ),
            )
            .first,
      );
      final decoration = outline.decoration as BoxDecoration;
      expect(
        decoration.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      );
      expect((decoration.border! as Border).top.width, greaterThan(0));
      expect(tester.takeException(), isNull);
    }
  });
}

Finder _sheetMaterial() => find
    .descendant(of: find.byType(AppSheet), matching: find.byType(Material))
    .first;

Future<ValueNotifier<Color>> _openSheet(
  WidgetTester tester, {
  required AppColors colors,
  bool glassEnabled = true,
  Color? backgroundColor,
  VoidCallback? onTap,
  ValueNotifier<bool>? glassSetting,
  Widget? child,
}) async {
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final backdrop = ValueNotifier(const Color(0xffd62d35));
  final setting = glassSetting ?? ValueNotifier(glassEnabled);
  if (glassSetting == null) addTearDown(setting.dispose);
  final appKey = UniqueKey();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    backdrop.dispose();
  });
  await tester.pumpWidget(
    RepaintBoundary(
      key: const Key('capture'),
      child: ValueListenableBuilder<bool>(
        valueListenable: setting,
        builder: (context, enabled, _) => MaterialApp(
          key: appKey,
          theme: AppTheme.generateTheme(
            colors,
            colors.isDark ? Brightness.dark : Brightness.light,
            glassEnabled: enabled,
          ),
          home: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                ValueListenableBuilder<Color>(
                  valueListenable: backdrop,
                  builder: (context, color, _) => ColoredBox(color: color),
                ),
                Positioned(
                  top: 24,
                  left: 24,
                  child: Builder(
                    builder: (context) => TextButton(
                      key: const Key('open'),
                      onPressed: () => unawaited(
                        showAppSheet<void>(
                          context,
                          showClose: false,
                          showGrabber: false,
                          scrollable: false,
                          backgroundColor: backgroundColor,
                          barrierColor: Colors.transparent,
                          child:
                              child ??
                              InkWell(
                                key: const Key('sheet-tap-target'),
                                onTap: onTap,
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 180,
                                ),
                              ),
                        ),
                      ),
                      child: const Text('Open'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(const Key('open')));
  await tester.pumpAndSettle();
  return backdrop;
}

Future<List<int>> _surfacePixel(WidgetTester tester) async {
  final bounds = tester.getRect(find.byType(AppGlassSurface));
  final point = Offset(bounds.center.dx, bounds.top + 52);
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('capture')),
  );
  return (await tester.runAsync(() async {
    final image = await boundary.toImage();
    try {
      final bytes = (await image.toByteData())!;
      final offset = (point.dy.floor() * image.width + point.dx.floor()) * 4;
      return Uint8List.sublistView(bytes, offset, offset + 4).toList();
    } finally {
      image.dispose();
    }
  }))!;
}
