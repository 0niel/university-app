import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_submit_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/runtime/mini_apps_runtime.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_template.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/widgets.dart';
import 'package:stac_bridge/stac_bridge.dart';
import 'package:url_launcher/url_launcher.dart';

part 'mini_app_submit_view.dart';
part 'metadata_section.dart';
part 'category_section.dart';
part 'permissions_section.dart';
part 'screen_draft.dart';
part 'source_section.dart';
part 'submit_section_label.dart';
part 'screen_editor.dart';

const kStarterScreenJson = '''
{
  "type": "scaffold",
  "body": {
    "type": "singleChildScrollView",
    "child": {
      "type": "padding",
      "padding": {"left": 16, "right": 16, "top": 16, "bottom": 16},
      "child": {
        "type": "column",
        "crossAxisAlignment": "stretch",
        "children": [
          {"type": "appSectionTitle", "title": "Мой мини-апп",
           "subtitle": "работает на Stac"},
          {"type": "appCard", "child": {
            "type": "column",
            "children": [
              {"type": "appText", "data": "Привет, ниндзя! 🥷"},
              {"type": "sizedBox", "height": 12},
              {"type": "appButton", "label": "Открыть расписание",
               "expanded": true,
               "onPressed": {"actionType": "openDeepLink",
                             "location": "/schedule"}}
            ]
          }}
        ]
      }
    }
  }
}''';

final miniAppTemplates = [
  MiniAppTemplate(
    nameBuilder: (context) => context.l10n.miniAppsTplList,
    screens: [
      (
        '/',
        '''
{
  "type": "scaffold",
  "body": {"type": "singleChildScrollView", "child": {
    "type": "padding",
    "padding": {"left": 16, "right": 16, "top": 16},
    "child": {"type": "column", "crossAxisAlignment": "stretch", "children": [
      {"type": "appSectionTitle", "title": "Мой список"},
      {"type": "appCard", "padding": 4, "child": {"type": "column", "children": [
        {"type": "appListRow", "title": "Первый пункт", "emoji": "1️⃣",
         "isFirst": true,
         "onTap": {"actionType": "openPage", "path": "/details",
                   "title": "Детали"}},
        {"type": "appListRow", "title": "Второй пункт", "emoji": "2️⃣",
         "onTap": {"actionType": "openPage", "path": "/details",
                   "title": "Детали"}}
      ]}}
    ]}
  }}
}''',
      ),
      (
        '/details',
        '''
{
  "type": "scaffold",
  "body": {"type": "padding",
    "padding": {"left": 16, "right": 16, "top": 16},
    "child": {"type": "column", "crossAxisAlignment": "stretch", "children": [
      {"type": "appCard", "child": {"type": "appText", "data": "Детали пункта"}},
      {"type": "sizedBox", "height": 12},
      {"type": "appButton", "label": "Назад", "variant": "secondary",
       "expanded": true, "onPressed": {"actionType": "pop"}}
    ]}
  }
}''',
      ),
    ],
  ),
  MiniAppTemplate(
    nameBuilder: (context) => context.l10n.miniAppsTplChecklist,
    screens: [
      (
        '/',
        '''
{
  "type": "scaffold",
  "body": {"type": "padding",
    "padding": {"left": 16, "right": 16, "top": 16},
    "child": {"type": "column", "crossAxisAlignment": "stretch", "children": [
      {"type": "appSectionTitle", "title": "Чеклист",
       "subtitle": "сохраняется между запусками"},
      {"type": "appCard", "child": {"type": "column",
        "crossAxisAlignment": "stretch", "children": [
        {"type": "appText", "data": "Сделано: {{storage.done}}"},
        {"type": "sizedBox", "height": 12},
        {"type": "appButton", "label": "Отметить выполненным",
         "expanded": true,
         "onPressed": {"actionType": "multiAction", "actions": [
           {"actionType": "setStorage", "key": "done", "value": "да"},
           {"actionType": "reload"}
         ]}},
        {"type": "sizedBox", "height": 8},
        {"type": "appButton", "label": "Сбросить", "variant": "ghost",
         "expanded": true,
         "onPressed": {"actionType": "multiAction", "actions": [
           {"actionType": "setStorage", "key": "done", "value": "нет"},
           {"actionType": "reload"}
         ]}}
      ]}}
    ]}
  }
}''',
      ),
    ],
  ),
  MiniAppTemplate(
    nameBuilder: (context) => context.l10n.miniAppsTplPoll,
    screens: [
      (
        '/',
        '''
{
  "type": "scaffold",
  "body": {"type": "padding",
    "padding": {"left": 16, "right": 16, "top": 16},
    "child": {"type": "column", "crossAxisAlignment": "stretch", "children": [
      {"type": "appSectionTitle", "title": "Опрос",
       "subtitle": "выбери вариант"},
      {"type": "appCard", "padding": 4, "child": {"type": "column",
        "children": [
        {"type": "appListRow", "title": "Вариант А", "emoji": "🅰️",
         "isFirst": true,
         "onTap": {"actionType": "multiAction", "actions": [
           {"actionType": "setStorage", "key": "vote", "value": "А"},
           {"actionType": "showToast", "message": "Голос за А!"}
         ]}},
        {"type": "appListRow", "title": "Вариант Б", "emoji": "🅱️",
         "onTap": {"actionType": "multiAction", "actions": [
           {"actionType": "setStorage", "key": "vote", "value": "Б"},
           {"actionType": "showToast", "message": "Голос за Б!"}
         ]}}
      ]}},
      {"type": "sizedBox", "height": 10},
      {"type": "appMetaPill", "text": "Твой голос: {{storage.vote}}"}
    ]}
  }
}''',
      ),
    ],
  ),
];

class MiniAppSubmitPage extends StatelessWidget {
  const MiniAppSubmitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MiniAppSubmitCubit(
        miniAppsRepository: context.read(),
      ),
      child: const MiniAppSubmitView(),
    );
  }
}
