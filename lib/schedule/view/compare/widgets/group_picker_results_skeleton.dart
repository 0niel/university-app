part of '../compare_page.dart';

class _GroupPickerResultsSkeleton extends StatelessWidget {
  const _GroupPickerResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        for (var index = 0; index < 4; index++)
          const Row(
            spacing: 12,
            children: [
              NinjaSkeleton(width: 24, height: 24, radius: 12),
              Expanded(child: NinjaSkeleton.bar(widthFactor: 0.6)),
            ],
          ),
      ],
    );
  }
}
