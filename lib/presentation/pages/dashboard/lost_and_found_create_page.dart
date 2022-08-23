import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:unicons/unicons.dart';

class LostAndFoundCreatePage extends StatelessWidget {
  const LostAndFoundCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.13),
          scrolledUnderElevation: 8,
          centerTitle: true,
          title: const NinjaText.bodyMedium(
            "Добавить в бюро находок",
            fontWeight: 600,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const _ImageSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageSelector extends StatelessWidget {
  const _ImageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: NinjaButton.rounded(
        expanded: true,
        padding: const EdgeInsets.only(top: 37),
        backgroundColor: NinjaConstant.grey50,
        borderRadiusAll: 10.0,
        onPressed: () {},
        child: Column(
          children: [
            SizedBox(
              width: 121,
              height: 121,
              child: DottedBorder(
                color: NinjaConstant.grey300,
                strokeWidth: 1,
                padding: EdgeInsets.zero,
                dashPattern: const [10, 10],
                borderType: BorderType.Circle,
                child: const Center(
                  child: Icon(
                    UniconsLine.focus_add,
                    size: 34,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const NinjaText.bodyMedium(
              "Добавьте фотографию",
              color: NinjaConstant.grey400,
            ),
          ],
        ),
      ),
    );
  }
}
