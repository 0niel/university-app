import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/tag.dart';

import '../../../routes/router.gr.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // детектор нажатий
    return GestureDetector(
      onTap: () {
        context.router.push(NewsDetailsRoute(isEvent: false));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: NinjaConstant.grey50,
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NinjaText.bodyMedium(
              "Эксперт РТУ МИРЭА разъяснил правила использования пластиковой посуды",
              fontWeight: 500,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
            const SizedBox(height: 6),
            const NinjaText.bodySmall("7 мая 2022",
                color: NinjaConstant.grey400),
            const SizedBox(height: 16),
            Container(
              height: 215,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/test_cover.png'),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: const [
                Tag("#Студентам"),
                Tag("#Праздники"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
