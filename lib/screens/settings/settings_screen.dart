import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/components/buttom_navbar.dart';
import 'package:rtu_mirea_app/components/button.dart';
import 'package:rtu_mirea_app/components/search_bar.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ButtomNavBar(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Настройки',
          style: Theme.of(context).textTheme.headline6,
        ),
        //shadowColor: Colors.transparent,
      ),
      body: Container(),
    );
  }
}
