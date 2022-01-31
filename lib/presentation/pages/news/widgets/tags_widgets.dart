import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class Tags extends StatelessWidget {
  final bool isClickable;
  final bool withIcon;
  final List<String> tags;
  final Function(String)? onClick;
  const Tags({
    Key? key,
    required this.isClickable,
    required this.withIcon,
    required this.tags,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        withIcon
            ? SvgPicture.asset("assets/icons/tag.svg", height: 50)
            : const SizedBox(width: 0, height: 0),
        withIcon
            ? const Padding(padding: EdgeInsets.only(left: 12))
            : const SizedBox(width: 0, height: 0),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags
                .map(
                  (element) => (Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (isClickable && onClick != null) {
                          onClick!(element);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: DarkThemeColors.colorful05, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            element,
                            style: DarkTextTheme.body
                                .copyWith(color: DarkThemeColors.colorful05),
                          ),
                        ),
                      ),
                    ),
                  )),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
