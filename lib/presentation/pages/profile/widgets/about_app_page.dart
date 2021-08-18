import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/settings_button.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class AboutAppPage extends StatelessWidget {
  static const String routeName = '/profile/about_app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'О приложении',
          style: DarkTextTheme.title,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            CircleAvatar(
              radius: 68,
              backgroundImage: Image.network(
                      'https://mirea.ninja/user_avatar/mirea.ninja/admin/120/13_2.png')
                  .image,
            ),
          ]),
        ),
      ),
    );
  }
}
