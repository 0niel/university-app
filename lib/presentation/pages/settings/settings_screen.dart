import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/widgets/settings_button.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

import 'group_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(
              color: LightThemeColors.grey100,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
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
                              ?.copyWith(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(height: 42, thickness: 0.5),
              SettingsButton(
                'Выбор группы',
                Icons.group_add,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupSelectionScreen()),
                ),
              ),
              SettingsButton('Уведомления', Icons.notifications, () {}),
            ],
          ),
        ),
      ),
    );
  }
}
