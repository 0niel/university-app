import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';

class LostAndFoundServicePage extends StatelessWidget {
  const LostAndFoundServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.13),
          scrolledUnderElevation: 8,
          centerTitle: true,
          title: const NinjaText.bodyMedium(
            "Бюро находок",
            fontWeight: 600,
          ),
          actions: [
            NinjaButton.text(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              onPressed: () {},
              child: const NinjaText.bodyMedium(
                "Добавить",
                color: NinjaConstant.secondary,
                fontWeight: 600,
              ),
            ),
          ],
        ),
        body: const Center(
          child: Text('LostAndFoundServicePage'),
        ),
      ),
    );
  }
}
