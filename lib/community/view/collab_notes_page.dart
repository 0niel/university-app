import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/community/view/collab_notes_view.dart';

class CollabNotesPage extends StatelessWidget {
  const CollabNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CollabNotesCubit(repository: context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: const CollabNotesView(),
    );
  }
}
