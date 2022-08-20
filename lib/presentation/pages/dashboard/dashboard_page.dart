import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:unicons/unicons.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: NinjaText.bodyLarge("События", fontWeight: 700),
            ),
            SizedBox(
              height: 70,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 5,
                itemBuilder: (context, index) => const _StoryItem(),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 14),
              child: NinjaText.bodyLarge("Сервисы", fontWeight: 700),
            ),
            SizedBox(
              height: 125,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 5,
                itemBuilder: (context, index) =>
                    const _ServiceCard(isNew: true),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({Key? key, required this.isNew}) : super(key: key);

  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 125,
      padding: const EdgeInsets.only(top: 8, right: 13, bottom: 13, left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: NinjaConstant.grey100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(UniconsLine.hunting, size: 20),
                ),
              ),
              if (isNew)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: NinjaConstant.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                  child: const NinjaText.bodyXSmall("New", fontWeight: 500),
                )
            ],
          ),
          const SizedBox(
            width: 73,
            child: NinjaText.bodySmall(
              "Бюро находок",
              fontWeight: 500,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(138),
        border: Border.all(
          color: NinjaConstant.grey200,
          width: 1,
        ),
      ),
      child: const FlutterLogo(size: 70),
    );
  }
}
