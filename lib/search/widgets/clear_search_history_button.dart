import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';

class ClearSearchHistoryButton extends StatelessWidget {
  const ClearSearchHistoryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
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
