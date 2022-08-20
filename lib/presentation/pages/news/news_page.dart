import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/event_card.dart';
import 'package:unicons/unicons.dart';

import 'widgets/news_card.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ScrollableAppBar(),
              const _EventsHeader(),
              const SizedBox(height: 34),
              NinjaChoiceChip(
                onPressed: (choice) {},
                choicesList: const ['Все новости', 'Важные'],
                oneChoice: true,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  children: const [
                    _NewsCardWithSpace(),
                    _NewsCardWithSpace(),
                    _NewsCardWithSpace(),
                    _NewsCardWithSpace(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollableAppBar extends StatelessWidget {
  const _ScrollableAppBar({Key? key}) : super(key: key);

  void _showBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 27),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const NinjaText.bodyLarge("Фильтр", fontWeight: 500),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: NinjaButton.rounded(
                        padding: EdgeInsets.zero,
                        borderRadiusAll: 50,
                        backgroundColor: Colors.transparent,
                        onPressed: () => Navigator.of(context).pop(),
                        child: SvgPicture.asset("assets/icons/close_modal.svg"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                NinjaChoiceChip(
                  onPressed: (selected) {
                    print(selected);
                  },
                  choicesList: [
                    "#Праздники",
                    "#Минобрнауки РФ",
                    "#Ректор",
                    "#Абитуриентам",
                    "#Студентам",
                    "#ИИТ",
                    "#ИКБ",
                    "#Сотрудникам",
                    "#ИПИТИП",
                    "#Спорт",
                    "#Колледж",
                    "#Оброзование",
                    "#ИМО",
                    "#ИИИ",
                    "#ИТХТ им. М.В. Ломоносова",
                    "#Волонтерство",
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24, right: 12, top: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const NinjaText.h6('Новости и мероприятия'),
          SizedBox(
            width: 34,
            height: 34,
            child: NinjaButton.rounded(
              borderRadiusAll: 50,
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              expanded: false,
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => _showBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCardWithSpace extends StatelessWidget {
  const _NewsCardWithSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: NewsCard(),
    );
  }
}

class _EventsHeader extends StatelessWidget {
  const _EventsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => const EventCard(),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }
}
