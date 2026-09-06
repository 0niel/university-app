import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/config/campuses_config.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/services.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({this.initialCampusId, this.initialRoomId, super.key});

  final String? initialCampusId;
  final String? initialRoomId;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapDataRepository? _repository;
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
    _repository?.dispose();
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
      create: (context) {
        final cubit = FreeRoomsCubit(campusRepository: context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: BlocProvider(
        create: (context) => MapBloc(
          availableCampuses: CampusesConfig.campuses,
          objectsService: ObjectsService(),
          repository: _repository ??= MapDataRepository(
            supabase: Supabase.instance.client,
            organizationId: context.read<UniversityConfig>().organizationId,
            bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
          ),
        )..add(const MapEvent.initialized()),
        child: MapView(
          initialCampusId: widget.initialCampusId,
          initialRoomId: widget.initialRoomId,
        ),
      ),
    );
  }
}
