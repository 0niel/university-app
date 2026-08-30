import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

abstract final class CampusesConfig {
  static final List<CampusModel> campuses = [
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
}
