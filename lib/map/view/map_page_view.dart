import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/map/map.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';

class MapPageView extends StatefulWidget {
  const MapPageView({super.key});

  static final campuses = [
    CampusModel(
      id: 'v-78',
      displayName: 'В-78',
      floors: [
        FloorModel(
          id: 'v-78-floor0',
          number: 0,
          svgPath: Assets.maps.v78.floor0.keyName,
        ),
        FloorModel(
          id: 'v-78-floor1',
          number: 1,
          svgPath: Assets.maps.v78.floor1.keyName,
        ),
        FloorModel(
          id: 'v-78-floor2',
          number: 2,
          svgPath: Assets.maps.v78.floor2.keyName,
        ),
        FloorModel(
          id: 'v-78-floor3',
          number: 3,
          svgPath: Assets.maps.v78.floor3.keyName,
        ),
        FloorModel(
          id: 'v-78-floor4',
          number: 4,
          svgPath: Assets.maps.v78.floor4.keyName,
        ),
      ],
    ),
    CampusModel(
      id: 's-20',
      displayName: 'С-20',
      floors: [
        FloorModel(
          id: 's-20-floor0',
          number: 1,
          svgPath: Assets.maps.s20.floor1.keyName,
        ),
        FloorModel(
          id: 's-20-floor1',
          number: 2,
          svgPath: Assets.maps.s20.floor2.keyName,
        ),
        FloorModel(
          id: 's-20-floor2',
          number: 3,
          svgPath: Assets.maps.s20.floor3.keyName,
        ),
        FloorModel(
          id: 's-20-floor3',
          number: 4,
          svgPath: Assets.maps.s20.floor4.keyName,
        ),
      ],
    ),
    CampusModel(
      displayName: 'МП-1',
      id: 'mp-1',
      floors: [
        FloorModel(
          id: 'mp-1-floor0',
          number: -1,
          svgPath: Assets.maps.mp1.a1Svg_.keyName,
        ),
        FloorModel(
          id: 'mp-1-floor1',
          number: 1,
          svgPath: Assets.maps.mp1.a1Svg.keyName,
        ),
        FloorModel(
          id: 'mp-1-floor2',
          number: 2,
          svgPath: Assets.maps.mp1.a2.keyName,
        ),
        FloorModel(
          id: 'mp-1-floor3',
          number: 3,
          svgPath: Assets.maps.mp1.a3.keyName,
        ),
        FloorModel(
          id: 'mp-1-floor4',
          number: 4,
          svgPath: Assets.maps.mp1.a4.keyName,
        ),
        FloorModel(
          id: 'mp-1-floor5',
          number: 5,
          svgPath: Assets.maps.mp1.a5.keyName,
        ),
      ],
    ),
  ];

  @override
  State<MapPageView> createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocProvider(
      create: (_) => MapBloc(
        availableCampuses: MapPageView.campuses,
        objectsService: ObjectsService(),
      )..add(MapInitialized()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Карта'),
        ),
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is! MapLoaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SvgInteractiveMap(
                        svgAssetPath: state.selectedFloor.svgPath,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: SizedBox(
                    width: 100,
                    child: CampusSelector(
                      campuses: MapPageView.campuses,
                      selectedCampus: state.selectedCampus,
                      onCampusSelected: (campus) {
                        context.read<MapBloc>().add(CampusSelected(campus));
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: bottomNavigationBarHeight + 32,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).extension<AppColors>()!.background02,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLandscape
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: state.selectedCampus.floors.map((floor) {
                              return MapNavigationButton(
                                floor: floor.number,
                                isSelected: state.selectedFloor.number == floor.number,
                                onClick: () {
                                  context.read<MapBloc>().add(FloorSelected(floor, state.selectedCampus));
                                },
                              );
                            }).toList(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: state.selectedCampus.floors.map((floor) {
                              return MapNavigationButton(
                                floor: floor.number,
                                isSelected: state.selectedFloor.number == floor.number,
                                onClick: () {
                                  context.read<MapBloc>().add(FloorSelected(floor, state.selectedCampus));
                                },
                              );
                            }).toList(),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
