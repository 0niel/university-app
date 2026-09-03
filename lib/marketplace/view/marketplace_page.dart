import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/marketplace/cubit/market_contact_prefs_cubit.dart';
import 'package:rtu_mirea_app/marketplace/cubit/market_favorites_cubit.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_cubit.dart';
import 'package:rtu_mirea_app/marketplace/view/marketplace_view.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MarketplaceCubit(context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: BlocProvider(
        create: (_) => MarketFavoritesCubit(),
        child: BlocProvider(
          create: (_) => MarketContactPrefsCubit(),
          child: BlocBuilder<MarketFavoritesCubit, List<String>>(
            builder: (context, favorites) => MarketplaceView(
              favoriteIds: favorites.toSet(),
              onToggleFavorite: context.read<MarketFavoritesCubit>().toggle,
            ),
          ),
        ),
      ),
    );
  }
}
