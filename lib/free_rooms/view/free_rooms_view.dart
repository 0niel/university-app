import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_sheet.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_rooms_list.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FreeRoomsView extends StatefulWidget {
  const FreeRoomsView({super.key});

  @override
  State<FreeRoomsView> createState() => _FreeRoomsViewState();
}

class _FreeRoomsViewState extends State<FreeRoomsView> {
  final _query = TextEditingController();
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() {});
      unawaited(context.read<FreeRoomsCubit>().load());
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<FreeRoomsCubit>();
    final state = context.watch<FreeRoomsCubit>().state;
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: RefreshIndicator(
        color: context.colors.accent,
        onRefresh: cubit.load,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: ninjaBottomInset(context) + AppSpacing.lg,
          ),
          children: [
            AppInnerHeader(
              title: l10n.freeRoomsNowTitle,
              subtitle: l10n.freeRoomsSubtitle,
              onBack: () => Navigator.of(context).maybePop(),
              backSemanticsLabel: l10n.back,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
              child: AppSearchField(
                controller: _query,
                hintText: l10n.mapRoomSearchHint,
                onCanvas: true,
                onChanged: cubit.queryChanged,
                onClear: () => cubit.queryChanged(''),
              ),
            ),
            AppChipRow<String>(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              value: state.campus,
              onChanged: cubit.campusChanged,
              items: [
                AppChipRowItem(value: '', label: l10n.freeRoomsAllBuildings),
                for (final campus in state.campuses)
                  AppChipRowItem(value: campus, label: campus),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: FreeRoomsList(
                state: state,
                onRetry: () => unawaited(cubit.load()),
                onRoomTap: (room) =>
                    unawaited(showFreeRoomSheet(context, room)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
