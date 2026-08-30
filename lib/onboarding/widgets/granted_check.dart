part of '../view/onboarding_page.dart';

class _GrantedCheck extends StatelessWidget {
  const _GrantedCheck({required this.granted});

  final bool granted;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: granted ? colors.brand : colors.surfaceAlt,
        shape: .circle,
      ),
      child: granted
          ? NinjaCheckMark(size: 13, color: colors.onBrand)
          : AppLineIconWidget(
              AppLineIcon.plus,
              size: 17,
              color: colors.brand,
            ),
    );
  }
}
