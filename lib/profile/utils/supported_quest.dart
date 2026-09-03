import 'package:gamification_repository/gamification_repository.dart';

bool isSupportedProfileQuest(GamificationQuest quest) {
  final text = '${quest.id} ${quest.title}'.toLowerCase();
  return !RegExp(
    'check[ _-]?in|attendance|отмет.{0,12}(пар|занят)|'
    'посет.{0,12}(пар|занят)|attend.{0,12}(class|lesson)',
  ).hasMatch(text);
}
