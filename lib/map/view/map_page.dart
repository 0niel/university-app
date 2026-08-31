import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/config/campuses_config.dart';
import 'package:rtu_mirea_app/map/services/services.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      SystemChrome.setPreferredOrientations([
        .portraitUp,
        .portraitDown,
        .landscapeLeft,
        .landscapeRight,
      ]),
    );
  }

  @override
  void dispose() {
    unawaited(
      SystemChrome.setPreferredOrientations([
        .portraitUp,
        .portraitDown,
      ]),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc(
        availableCampuses: CampusesConfig.campuses,
        objectsService: ObjectsService(),
      )..add(const MapEvent.initialized()),
      child: const MapView(),
    );
  }
}
