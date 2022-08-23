import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:rtu_mirea_app/presentation/routes/router.gr.dart';
import 'package:unicons/unicons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: NinjaConstant.grey50,
              expandedHeight: 135.0,
              centerTitle: true,
              title: const NinjaText.bodyMedium(
                "Профиль",
                fontWeight: 600,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 230,
                          height: 40,
                          child: NinjaButton.rounded(
                            borderRadiusAll: 6.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 58.5, vertical: 9.5),
                            onPressed: () {},
                            child: const NinjaText.bodyMedium(
                              "Войти в профиль",
                              fontWeight: 700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: NinjaConstant.grey50,
                height: 23,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 23,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: NinjaText.bodyLarge(
                      "Управление расписанием",
                      fontWeight: 500,
                    ),
                  ),
                  NinjaIconButton(
                    icon: UniconsLine.package,
                    text: 'Группы',
                    additionalText: '15',
                    onPressed: () {},
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: NinjaText.bodyLarge(
                      "Общее",
                      fontWeight: 500,
                    ),
                  ),
                  NinjaIconButton(
                    icon: UniconsLine.coffee,
                    text: 'О приложении',
                    onPressed: () => context.router.push(const AboutAppRoute()),
                  ),
                  NinjaSwitchButton(
                    icon: UniconsLine.moon,
                    text: 'Dark Mode',
                    initialValue: false,
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
