import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:app_ui/app_ui.dart';

enum ItemType {
  group,
  teacher,
  classroom,
}

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({
    super.key,
    required this.name,
    required this.onPressed,
    required this.type,
  });

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
            color: Theme.of(context).extension<AppColors>()!.colorful03,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              name.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
              style: AppTextStyle.bodyBold.copyWith(
                color: Theme.of(context).extension<AppColors>()!.active,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          name,
          style: AppTextStyle.titleS.copyWith(
            color: Theme.of(context).extension<AppColors>()!.active,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
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
                    color: Theme.of(context).extension<AppColors>()!.active,
                  ),
                ),
              ),
      ),
    );
  }
}
