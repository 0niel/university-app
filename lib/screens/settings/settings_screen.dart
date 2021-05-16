import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
        toolbarHeight: 80,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(),
    );
  }
}
