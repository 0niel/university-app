import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: ColoredBox(color: Color(0xFF00C853))),
              Expanded(child: ColoredBox(color: Color(0xFFFF00FF))),
            ],
          ),
          Center(
            child: Text(
              'FIRST FRAME',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ],
      ),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint('IOS_STARTUP_PROBE_FIRST_FRAME_V1');
  });
}
