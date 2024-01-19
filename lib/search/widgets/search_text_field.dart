import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.colorsOf(context).background02,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyle.titleS.copyWith(
          color: AppTheme.colorsOf(context).active,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          hintText: 'Поиск',
          hintStyle: AppTextStyle.titleS.copyWith(
            color: AppTheme.colorsOf(context).deactive,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8, left: 16),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: AppTheme.colorsOf(context).active,
              width: 24,
              height: 24,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            maxWidth: 48,
            maxHeight: 48,
          ),
        ),
      ),
    );
  }
}
