import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/top_authors_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('renders a ranked author list using the kit avatar', (
    tester,
  ) async {
    await tester.pumpApp(
      const TopAuthorsCard(
        authors: [
          MaterialAuthor(name: 'Аня К.', downloads: 40, materials: 5),
          MaterialAuthor(name: 'Тимур Л.', downloads: 12, materials: 2),
        ],
      ),
    );

    expect(find.byType(AppAvatar), findsNWidgets(2));
    expect(find.text('Аня К.'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
