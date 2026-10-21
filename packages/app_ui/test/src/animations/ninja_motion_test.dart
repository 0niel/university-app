import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keyboard metrics do not rebuild motion-only consumers', (
    tester,
  ) async {
    final media = ValueNotifier(const MediaQueryData());
    addTearDown(media.dispose);
    final builds = <Duration>[];
    final probe = _MotionProbe(onBuild: builds.add);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ValueListenableBuilder(
          valueListenable: media,
          builder: (context, value, child) => MediaQuery(
            data: value,
            child: child!,
          ),
          child: probe,
        ),
      ),
    );
    expect(builds, [NinjaMotion.base]);

    for (final inset in [40.0, 120.0, 240.0, 320.0]) {
      media.value = media.value.copyWith(
        viewInsets: EdgeInsets.only(bottom: inset),
      );
      await tester.pump();
    }
    expect(builds, [NinjaMotion.base]);

    media.value = media.value.copyWith(disableAnimations: true);
    await tester.pump();
    expect(builds, [NinjaMotion.base, Duration.zero]);

    media.value = media.value.copyWith(
      disableAnimations: false,
      accessibleNavigation: true,
    );
    await tester.pump();
    expect(builds.last, Duration.zero);
    expect(builds, hasLength(3));
  });
}

class _MotionProbe extends StatelessWidget {
  const _MotionProbe({required this.onBuild});

  final ValueChanged<Duration> onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild(NinjaMotion.of(context));
    return const SizedBox.shrink();
  }
}
