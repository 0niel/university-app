import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Настройки',
          style: Theme.of(context).textTheme.headline6,
        ),
        //shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: Image.network(
                            'https://mirea.ninja/user_avatar/mirea.ninja/admin/120/13_2.png')
                        .image,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "admin",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          "Редактировать профиль",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: LightThemeColors.grey400,
                height: 42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
