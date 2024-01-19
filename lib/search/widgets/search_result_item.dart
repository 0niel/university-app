import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

enum ItemType {
  group,
  teacher,
  classroom,
}

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({
    Key? key,
    required this.name,
    required this.onPressed,
    required this.type,
  }) : super(key: key);

  final String name;
  final ItemType type;
  final void Function() onPressed;

  Widget _buildTeacherItem(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.colorsOf(context).colorful03,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              name.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
              style: AppTextStyle.bodyBold.copyWith(
                color: AppTheme.colorsOf(context).active,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          name,
          style: AppTextStyle.titleS.copyWith(
            color: AppTheme.colorsOf(context).active,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: type == ItemType.teacher
            ? _buildTeacherItem(context)
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: AppTextStyle.titleS.copyWith(
                    color: AppTheme.colorsOf(context).active,
                  ),
                ),
              ),
      ),
    );
  }
}
