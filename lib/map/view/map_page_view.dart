import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/map/map.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class MapPageView extends StatefulWidget {
  const MapPageView({super.key});

  static final campuses = [
    const CampusModel(
      id: 'v-78',
      displayName: 'В-78',
      floors: [
        FloorModel(
          id: 'v-78-floor0',
          number: 0,
          svgPath: 'assets/maps/v-78/floor_0.svg',
        ),
        FloorModel(
          id: 'v-78-floor1',
          number: 1,
          svgPath: 'assets/maps/v-78/floor_1.svg',
        ),
        FloorModel(
          id: 'v-78-floor2',
          number: 2,
          svgPath: 'assets/maps/v-78/floor_2.svg',
        ),
        FloorModel(
          id: 'v-78-floor3',
          number: 3,
          svgPath: 'assets/maps/v-78/floor_3.svg',
        ),
        FloorModel(
          id: 'v-78-floor4',
          number: 4,
          svgPath: 'assets/maps/v-78/floor_4.svg',
        ),
      ],
    ),
    const CampusModel(
      id: 's-20',
      displayName: 'С-20',
      floors: [
        FloorModel(
          id: 's-20-floor0',
          number: 1,
          svgPath: 'assets/maps/s-20/floor_1.svg',
        ),
        FloorModel(
          id: 's-20-floor1',
          number: 2,
          svgPath: 'assets/maps/s-20/floor_2.svg',
        ),
        FloorModel(
          id: 's-20-floor2',
          number: 3,
          svgPath: 'assets/maps/s-20/floor_3.svg',
        ),
        FloorModel(
          id: 's-20-floor3',
          number: 4,
          svgPath: 'assets/maps/s-20/floor_4.svg',
        ),
      ],
    ),
    const CampusModel(
      displayName: 'МП-1',
      id: 'mp-1',
      floors: [
        FloorModel(
          id: 'mp-1-floor0',
          number: -1,
          svgPath: 'assets/maps/mp-1/-1.svg',
        ),
        FloorModel(
          id: 'mp-1-floor1',
          number: 1,
          svgPath: 'assets/maps/mp-1/1.svg',
        ),
        FloorModel(
          id: 'mp-1-floor2',
          number: 2,
          svgPath: 'assets/maps/mp-1/2.svg',
        ),
        FloorModel(
          id: 'mp-1-floor3',
          number: 3,
          svgPath: 'assets/maps/mp-1/3.svg',
        ),
        FloorModel(
          id: 'mp-1-floor4',
          number: 4,
          svgPath: 'assets/maps/mp-1/4.svg',
        ),
        FloorModel(
          id: 'mp-1-floor5',
          number: 5,
          svgPath: 'assets/maps/mp-1/5.svg',
        ),
      ],
    ),
  ];

  @override
  State<MapPageView> createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  bool isLoading = true;

  List<RoomModel> rooms = [];

  Rect viewBoxRect = const Rect.fromLTWH(0, 0, 1000, 1000);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initMap(String svgPath) async {
    final (parsedRooms, vb) = await SvgRoomsParser.parseSvg(svgPath);
    setState(() {
      rooms = parsedRooms;
      viewBoxRect = vb;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc(
        availableCampuses: MapPageView.campuses,
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

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initMap(state.selectedFloor.svgPath);
            });

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SvgInteractiveView(
                        svgAssetPath: state.selectedFloor.svgPath,
                        rooms: state.rooms,
                        viewBoxRect: viewBoxRect,
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
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.colorsOf(context).background02,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: state.selectedCampus.floors.map((floor) {
                        return MapNavigationButton(
                          floor: floor.number,
                          isSelected: state.selectedFloor.number == floor.number,
                          onClick: () {
                            context.read<MapBloc>().add(FloorSelected(floor));
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
