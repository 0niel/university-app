import 'package:rtu_mirea_app/l10n/l10n.dart';

String mentorTopicLabel(AppLocalizations l10n, String key) => switch (key) {
  'ml' => l10n.mentorshipTopicMl,
  'python' => l10n.mentorshipTopicPython,
  'career' => l10n.mentorshipTopicCareer,
  'design' => l10n.mentorshipTopicDesign,
  'frontend' => l10n.mentorshipTopicFrontend,
  'cybersec' => l10n.mentorshipTopicCybersec,
  _ => key,
};

String mentorLevelLabel(AppLocalizations l10n, String key) => switch (key) {
  'course3' => l10n.mentorshipLevelCourse3,
  'course4' => l10n.mentorshipLevelCourse4,
  'master' => l10n.mentorshipLevelMaster,
  _ => key,
};

String mentorFormatLabel(AppLocalizations l10n, String key) => switch (key) {
  'online' => l10n.mentorshipFormatOnline,
  'campus' => l10n.mentorshipFormatCampus,
  'chat' => l10n.mentorshipFormatChat,
  _ => key,
};

String mentorWhenLabel(AppLocalizations l10n, String key) => switch (key) {
  'tonight' => l10n.mentorshipWhenTonight,
  'tomorrow' => l10n.mentorshipWhenTomorrow,
  'week' => l10n.mentorshipWhenWeek,
  _ => key,
};

String mentorWhenShortLabel(AppLocalizations l10n, String key) => switch (key) {
  'tonight' => l10n.mentorshipWhenShortTonight,
  'tomorrow' => l10n.mentorshipWhenShortTomorrow,
  'week' => l10n.mentorshipWhenShortWeek,
  _ => key,
};
