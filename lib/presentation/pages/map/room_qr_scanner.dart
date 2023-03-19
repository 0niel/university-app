import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/map/room_schedule.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/app_settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'cubit/rooms_cubit.dart';

class RoomQrScannerPage extends StatefulWidget {
  const RoomQrScannerPage({Key? key}) : super(key: key);

  @override
  State<RoomQrScannerPage> createState() => _RoomQrScannerPageState();
}

class _RoomQrScannerPageState extends State<RoomQrScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        title: const Text("QR-сканер"),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            if (barcode.rawValue == null) return;

            BlocProvider.of<RoomsCubit>(context)
                .loadRoomData(barcode.rawValue!);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RoomDataPage(
                  roomName: barcode.rawValue!,
                ),
              ),
            );

            cameraController.stop();
          }
        },
      ),
    );
  }
}
