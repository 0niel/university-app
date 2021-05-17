import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/components/buttom_navbar.dart';
import 'package:rtu_mirea_app/components/button.dart';
import 'package:rtu_mirea_app/components/search_bar.dart';
import 'package:rtu_mirea_app/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final PageController controller = PageController(initialPage: 0);
    return Scaffold(
      bottomNavigationBar: ButtomNavBar(currentIndex: 1),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "Группы",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.w900, color: kTextLightColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Просмотр и управление скачанными группами",
                    style: TextStyle(color: kTextLightColor),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: size.width * .5, // it just take the 50% width
                    child: SearchBar(),
                  ),
                  Expanded(
                    flex: 2,
                    child: OverflowBox(
                      minHeight: 100,
                      maxWidth: MediaQuery.of(context).size.width,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: controller,
                        children: <Widget>[
                          Container(
                            margin: new EdgeInsets.symmetric(horizontal: 20.0),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: <Widget>[
                                GroupCard(
                                  groupName: 'ИКБО-25-20',
                                  isCurrent: true,
                                  press: () {},
                                ),
                                GroupCard(
                                  groupName: 'ИВБО-03-20',
                                  press: () {},
                                ),
                                GroupCard(
                                  groupName: 'ИНБО-07-20',
                                  press: () {},
                                ),
                                GroupCard(
                                  groupName: 'ИНБО-08-20',
                                  press: () {},
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: new EdgeInsets.symmetric(horizontal: 20.0),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: <Widget>[
                                GroupCard(
                                  groupName: 'ИКБО-11-20',
                                  press: () {},
                                ),
                                GroupCard(
                                  groupName: 'ИКБО-01-20',
                                  press: () {},
                                ),
                                GroupCard(
                                  groupName: 'ИКБО-02-20',
                                  press: () {},
                                ),
                                GroupCard(
                                  groupName: 'ИКБО-03-20',
                                  press: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        "Добавить группу",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ButtonPrimary(
                        text: 'Скачать группу',
                        textColor: kTextLightColor,
                        size: Size(MediaQuery.of(context).size.width, 48),
                        onPress: () {},
                        backgroupColor: Color(0xFFFF8181),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;
  final bool isCurrent;
  final Function press;
  const GroupCard({
    Key key,
    this.groupName,
    this.isCurrent = false,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: constraint.maxWidth / 2 - 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: press,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 42,
                      width: 43,
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.lightBlue : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.lightBlue),
                      ),
                      child: Icon(
                        Icons.done,
                        color: isCurrent ? Colors.white : Colors.lightBlue,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      groupName,
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
