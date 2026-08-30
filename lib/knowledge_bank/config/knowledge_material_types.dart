import 'package:rtu_mirea_app/l10n/l10n.dart';

abstract final class KnowledgeMaterialTypes {
  static const List<String> keys = ['note', 'exam', 'task', 'cheat'];

  static String labelOf(AppLocalizations l10n, String key) {
    return switch (key) {
      'exam' => l10n.knowledgeTypeExam,
      'task' => l10n.knowledgeTypeTask,
      'cheat' => l10n.knowledgeTypeCheat,
      _ => l10n.knowledgeTypeNote,
    };
  }
}
