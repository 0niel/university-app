import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'searchHero',
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppColors>()!.background02,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          style: AppTextStyle.titleS.copyWith(
            color: Theme.of(context).extension<AppColors>()!.active,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: InputBorder.none,
            hintText: 'Поиск',
            hintStyle: AppTextStyle.titleS.copyWith(
              color: Theme.of(context).extension<AppColors>()!.deactive,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8, left: 16),
              child: Assets.icons.hugeicons.search.svg(
                color: Theme.of(context).extension<AppColors>()!.active,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              maxWidth: 48,
              maxHeight: 48,
            ),
          ),
        ),
      ),
    );
  }
}
