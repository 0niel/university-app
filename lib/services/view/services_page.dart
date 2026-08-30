import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/services/view/services_view.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key, this.initialEditMode = false});

  final bool initialEditMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ninja.canvas,
      body: SafeArea(
        bottom: false,
        child: ServicesView(initialEditMode: initialEditMode),
      ),
    );
  }
}
