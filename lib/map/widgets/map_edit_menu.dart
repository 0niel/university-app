import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/widgets/map_community_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_alignment_page.dart';
import 'package:rtu_mirea_app/map/widgets/map_graph_editor_page.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_editor_page.dart';

Future<void> showMapEditMenu(
  BuildContext context, {
  required CampusMapData campus,
  required MapDataRepository repository,
  String? floorId,
}) => showAppSheet<void>(
  context,
  title: 'Улучшаем карту вместе',
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const AppBanner(
        message:
            'Изменения появятся на общей карте после проверки. '
            'Ваша версия сохранится в истории.',
      ),
      const SizedBox(height: 16),
      AppListGroup(
        children: [
          AppListRow(
            title: 'Добавить место или сервис',
            titleMaxLines: null,
            subtitle: 'Столовая, банкомат, вода, печать и другие точки',
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              unawaited(
                Navigator.of(context, rootNavigator: true).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => MapPlaceEditorPage(
                      campus: campus,
                      repository: repository,
                      initialFloorId: floorId,
                    ),
                  ),
                ),
              );
            },
          ),
          AppListRow(
            title: 'Проходы и навигация',
            titleMaxLines: null,
            subtitle: 'Точки, двери, лестницы, лифты и закрытые участки',
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              unawaited(
                Navigator.of(context, rootNavigator: true).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => MapGraphEditorPage(
                      campus: campus,
                      repository: repository,
                      initialFloorId: floorId,
                    ),
                  ),
                ),
              );
            },
          ),
          AppListRow(
            title: 'Привязать этаж к зданию',
            titleMaxLines: null,
            subtitle: 'Три точки на плане и реальной карте',
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              unawaited(
                Navigator.of(context, rootNavigator: true).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => MapFloorAlignmentPage(
                      campus: campus,
                      repository: repository,
                      initialFloorId: floorId,
                    ),
                  ),
                ),
              );
            },
          ),
          AppListRow(
            title: campus.canModerate ? 'Правки и модерация' : 'Мои правки',
            titleMaxLines: null,
            subtitle: 'Сообщить о неточности и проверить статус',
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              unawaited(
                showMapCommunitySheet(
                  context,
                  repository: repository,
                  campus: campus,
                  floorId: floorId,
                ),
              );
            },
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        'Оснащение, меню и сведения о помещении '
        'можно уточнить в его карточке.',
        style: AppText.subtext.copyWith(color: context.colors.muted),
      ),
    ],
  ),
);
