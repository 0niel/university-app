import 'package:flutter/material.dart';
import 'package:wear/nfc_pass/nfc_pass.dart';
import 'package:wear/schedule/schedule.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: const [
          SchedulePage(),
          NfcPassPage(),
        ],
      ),
    );
  }
}
