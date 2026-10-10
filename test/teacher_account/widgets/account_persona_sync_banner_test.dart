import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_account_sync_banner.dart';

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

void main() {
  testWidgets(
    'banner distinguishes queued choice from a failed read and clears',
    (
      tester,
    ) async {
      final account = _Account();
      final states = StreamController<AccountPersonaState>();
      addTearDown(states.close);
      const pending = AccountPersonaState(
        loaded: true,
        operation: AccountPersonaOperation.failed,
        pendingEdit: AccountPersonaEdit.teacherSelection,
      );
      whenListen(account, states.stream, initialState: pending);
      when(account.retry).thenAnswer((_) async {});
      late AppLocalizations l10n;
      await tester.pumpWidget(
        BlocProvider<AccountPersonaCubit>.value(
          value: account,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                l10n = context.l10n;
                return const Scaffold(body: TeacherAccountSyncBanner());
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(l10n.accountPersonaSyncError), findsOneWidget);
      expect(find.text(l10n.accountPersonaLoadError), findsNothing);
      await tester.tap(find.text(l10n.retry));
      await tester.pump();
      verify(account.retry).called(1);

      states.add(pending.copyWith(pendingEdit: null));
      await tester.pumpAndSettle();
      expect(find.text(l10n.accountPersonaSyncError), findsNothing);
      expect(find.text(l10n.accountPersonaLoadError), findsOneWidget);

      states.add(
        pending.copyWith(
          operation: AccountPersonaOperation.idle,
          pendingEdit: null,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppBanner), findsNothing);
      expect(find.text(l10n.retry), findsNothing);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
