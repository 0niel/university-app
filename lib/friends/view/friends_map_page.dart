import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/view/friends_map_view.dart';

class FriendsMapPage extends StatefulWidget {
  const FriendsMapPage({super.key});

  @override
  State<FriendsMapPage> createState() => _FriendsMapPageState();
}

class _FriendsMapPageState extends State<FriendsMapPage> {
  late final FriendsMapCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FriendsMapCubit>();
    unawaited(_cubit.setMapVisible(visible: true));
  }

  @override
  void dispose() {
    unawaited(_cubit.setMapVisible(visible: false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const FriendsMapView();
}
