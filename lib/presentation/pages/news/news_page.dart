import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/event_card.dart';
import 'package:unicons/unicons.dart';

import 'widgets/news_card.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  // void _showBottomSheet(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext buildContext) {
  //         return Container(
  //           decoration: BoxDecoration(
  //               color: theme.backgroundColor,
  //               borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(16),
  //                   topRight: Radius.circular(16))),
  //           child: Padding(
  //             padding: FxSpacing.fromLTRB(24, 24, 24, 36),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: <Widget>[
  //                     Column(
  //                       children: <Widget>[
  //                         Icon(Icons.supervisor_account_outlined,
  //                             size: 26, color: theme.colorScheme.onBackground),
  //                         Container(
  //                           margin: FxSpacing.top(4),
  //                           child: Text(
  //                             "180 Followers",
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 color: theme.colorScheme.onBackground),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     Column(
  //                       children: <Widget>[
  //                         Icon(Icons.supervisor_account_outlined,
  //                             size: 26, color: theme.colorScheme.onBackground),
  //                         Container(
  //                           margin: FxSpacing.top(4),
  //                           child: Text(
  //                             "147 Following",
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 color: theme.colorScheme.onBackground),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

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
              onPressed: () {},
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
