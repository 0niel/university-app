import 'package:rtu_mirea_app/l10n/l10n.dart';

abstract final class KnowledgeMaterialTypes {
  static const List<String> keys = [
    'note',
    'board',
    'task',
    'extra',
    'exam',
    'cheat',
  ];

  static String labelOf(AppLocalizations l10n, String key) {
    return switch (key) {
      'board' => l10n.knowledgeTypeBoard,
      'task' => l10n.knowledgeTypeTask,
      'extra' => l10n.knowledgeTypeExtra,
      'exam' => l10n.knowledgeTypeExam,
      'cheat' => l10n.knowledgeTypeCheat,
      _ => l10n.knowledgeTypeNote,
    };
  }
}
