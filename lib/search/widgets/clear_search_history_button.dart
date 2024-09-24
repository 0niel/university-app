import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';

class ClearSearchHistoryButton extends StatelessWidget {
  const ClearSearchHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: PlatformTextButton(
        onPressed: () {
          context.read<SearchBloc>().add(const ClearSearchHistory());
        },
        child: const Text(
          "Очистить",
        ),
      ),
    );
  }
}
