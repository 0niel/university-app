import 'package:app_ui/src/ninja/surfaces/ninja_skeleton.dart';
import 'package:flutter/widgets.dart';

class AppSkeletonText extends StatelessWidget {
  const AppSkeletonText({
    this.sample = '\u00a0',
    this.widthFactor = 1,
    this.maxLines,
    super.key,
  }) : assert(
         widthFactor >= 0 && widthFactor <= 1,
         'Skeleton width factor must be between zero and one',
       );

  final String sample;
  final double widthFactor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: Text(sample, maxLines: maxLines),
          ),
          Positioned.fill(
            child: NinjaSkeleton.bar(height: 0, widthFactor: widthFactor),
          ),
        ],
      ),
    ),
  );
}
