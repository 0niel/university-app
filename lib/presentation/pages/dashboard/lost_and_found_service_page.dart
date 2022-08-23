import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:rtu_mirea_app/presentation/routes/router.gr.dart';
import 'package:unicons/unicons.dart';

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
              onPressed: () {
                context.router.push(const LostAndFoundCreateRoute());
              },
              child: const NinjaText.bodyMedium(
                "Добавить",
                color: NinjaConstant.secondary,
                fontWeight: 600,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const _FiltersBar(),
                ...List.generate(
                  5,
                  (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _LostAndFoundCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LostAndFoundCard extends StatelessWidget {
  const _LostAndFoundCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: NinjaConstant.grey50,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 215,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/test_cover.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const NinjaText.bodyMedium(
                "Нашел ключи от кваритры или офиса, позвоните, встретимся",
                height: 1.3,
                fontWeight: 500,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              const NinjaText.bodySmall("7 мая 2022",
                  color: NinjaConstant.grey400),
            ],
          ),
          const Positioned(
            top: 13,
            left: 13,
            child: _CardLabel(isFound: true),
          ),
        ],
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({Key? key, required this.isFound}) : super(key: key);

  final bool isFound;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isFound ? NinjaConstant.primary : NinjaConstant.error,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      child: NinjaText.bodyXSmall(
        isFound ? "Нашёл" : "Потерял",
        color: isFound ? NinjaConstant.grey900 : Colors.white,
        fontWeight: 500,
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NinjaChoiceChip(
          onPressed: (val) {},
          choicesList: ['Все', 'Нашёл', 'Потерял', 'Завершено'],
          spacing: 5,
        ),
        SizedBox(
          width: 36,
          child: NinjaButton.rounded(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            onPressed: () => null,
            borderRadiusAll: 50,
            child: const Icon(UniconsLine.calender),
          ),
        )
      ],
    );
  }
}
