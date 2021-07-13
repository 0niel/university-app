import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../colors.dart';
import 'widgets/schedule_page_view.dart';

class ScheduleScreen extends StatelessWidget {
  static const String routeName = '/schedule';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: LightThemeColors.grey100,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
        automaticallyImplyLeading: false,
        title: Text(
          'Расписание',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: SvgPicture.asset('assets/icons/menu.svg'),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SchedulePageView(),
        ),
      ),
    );
  }
}
