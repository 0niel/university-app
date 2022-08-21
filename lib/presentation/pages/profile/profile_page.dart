import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              backgroundColor: NinjaConstant.grey500,
              expandedHeight: 120.0,
              centerTitle: true,
              title: NinjaText.bodyMedium(
                "Профиль",
                fontWeight: 600,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Color(0xff5c63f1),
                height: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    color: index.isOdd ? Colors.white : Colors.black12,
                    height: 100.0,
                    child: Center(
                      child: Text('$index', textScaleFactor: 5),
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const NinjaText.bodyMedium(
        //     "Профиль",
        //     fontWeight: 600,
        //   ),
        // ),
        // body: const Center(
        //   child: const Text('ProfilePage'),
        // ),
      ),
    );
  }
}
