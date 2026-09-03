import 'package:gamification_repository/gamification_repository.dart';
import 'package:test/test.dart';

void main() {
  group('UserGamificationProfile', () {
    test('fromJson maps all fields including nested recentBadge', () {
      final profile = UserGamificationProfile.fromJson({
        'userId': 'u1',
        'xp': 1500,
        'level': 7,
        'shurikens': 42,
        'streakDays': 12,
        'lastActiveDate': '2026-06-12T10:00:00.000Z',
        'recentBadge': {
          'id': 'b1',
          'name': 'First Steps',
          'emoji': '🏅',
          'rarity': 'rare',
        },
      });

      expect(profile.userId, 'u1');
      expect(profile.xp, 1500);
      expect(profile.level, 7);
      expect(profile.shurikens, 42);
      expect(profile.streakDays, 12);
      expect(profile.lastActiveDate, DateTime.utc(2026, 6, 12, 10));
      expect(profile.recentBadge?.id, 'b1');
      expect(profile.recentBadge?.name, 'First Steps');
      expect(profile.recentBadge?.emoji, '🏅');
      expect(profile.recentBadge?.rarity, 'rare');
      expect(profile.isEmpty, isFalse);
    });

    test('fromJson applies defaults on missing/null keys', () {
      final profile = UserGamificationProfile.fromJson(const {});

      expect(profile.userId, '');
      expect(profile.xp, 0);
      expect(profile.level, 1);
      expect(profile.shurikens, 0);
      expect(profile.streakDays, 0);
      expect(profile.lastActiveDate, isNull);
      expect(profile.recentBadge, isNull);
      expect(profile.isEmpty, isTrue);
    });

    test('fromJson parses numeric fields from doubles via num', () {
      final profile = UserGamificationProfile.fromJson({
        'userId': 'u2',
        'xp': 99.0,
        'level': 3.0,
        'shurikens': 5.0,
        'streakDays': 2.0,
      });

      expect(profile.xp, 99);
      expect(profile.level, 3);
      expect(profile.shurikens, 5);
      expect(profile.streakDays, 2);
    });

    test('fromJson with invalid lastActiveDate yields null (tryParse)', () {
      final profile = UserGamificationProfile.fromJson({
        'userId': 'u3',
        'xp': 1,
        'level': 1,
        'shurikens': 0,
        'streakDays': 0,
        'lastActiveDate': 'not-a-date',
      });

      expect(profile.lastActiveDate, isNull);
    });

    test('empty constant is empty', () {
      expect(UserGamificationProfile.empty.isEmpty, isTrue);
      expect(UserGamificationProfile.empty.userId, '');
      expect(UserGamificationProfile.empty.level, 1);
    });
  });

  group('GamificationBadgeSummary', () {
    test('fromJson maps fields and defaults rarity to common', () {
      final summary = GamificationBadgeSummary.fromJson({
        'id': 'b9',
        'name': 'Scholar',
        'emoji': '📚',
      });

      expect(summary.id, 'b9');
      expect(summary.name, 'Scholar');
      expect(summary.emoji, '📚');
      expect(summary.rarity, 'common');
    });

    test('fromJson respects explicit rarity', () {
      final summary = GamificationBadgeSummary.fromJson({
        'id': 'b9',
        'name': 'Scholar',
        'emoji': '📚',
        'rarity': 'legendary',
      });

      expect(summary.rarity, 'legendary');
    });
  });

  group('GamificationBadge', () {
    test('fromJson maps all fields', () {
      final badge = GamificationBadge.fromJson({
        'id': 'badge1',
        'category': 'study',
        'name': 'Bookworm',
        'description': 'Read 10 articles',
        'emoji': '🐛',
        'rarity': 'epic',
        'xpReward': 100,
        'shurikenReward': 20,
        'isEarned': true,
        'progress': 0.75,
        'earnedAt': '2026-01-02T00:00:00.000Z',
      });

      expect(badge.id, 'badge1');
      expect(badge.category, 'study');
      expect(badge.name, 'Bookworm');
      expect(badge.description, 'Read 10 articles');
      expect(badge.emoji, '🐛');
      expect(badge.rarity, 'epic');
      expect(badge.xpReward, 100);
      expect(badge.shurikenReward, 20);
      expect(badge.isEarned, isTrue);
      expect(badge.progress, 0.75);
      expect(badge.earnedAt, DateTime.utc(2026, 1, 2));
    });

    test('fromJson applies defaults for optional/missing keys', () {
      final badge = GamificationBadge.fromJson({
        'id': 'badge2',
        'category': 'social',
        'name': 'Friendly',
        'description': 'Add a friend',
        'emoji': '🙂',
      });

      expect(badge.rarity, 'common');
      expect(badge.xpReward, 0);
      expect(badge.shurikenReward, 0);
      expect(badge.isEarned, isFalse);
      expect(badge.progress, 0.0);
      expect(badge.earnedAt, isNull);
    });

    test('progress parses int as double', () {
      final badge = GamificationBadge.fromJson({
        'id': 'badge3',
        'category': 'c',
        'name': 'n',
        'description': 'd',
        'emoji': 'e',
        'progress': 1,
      });

      expect(badge.progress, 1.0);
      expect(badge.progress, isA<double>());
    });

    test('fromJson matches the real get_badges_for_user RPC row shape', () {
      final badge = GamificationBadge.fromJson({
        'id': 'streak_3',
        'category': 'Активность',
        'name': 'Разогрев',
        'description': 'Стрик 3 дня',
        'emoji': '🔥',
        'rarity': 'common',
        'xpReward': 20,
        'shurikenReward': 10,
        'isEarned': true,
        'progress': 1,
        'earnedAt': '2026-08-13T19:24:37.287867+00:00',
      });

      expect(badge.id, 'streak_3');
      expect(badge.category, 'Активность');
      expect(badge.name, 'Разогрев');
      expect(badge.emoji, '🔥');
      expect(badge.isEarned, isTrue);
      expect(badge.progress, 1.0);
      expect(badge.earnedAt, DateTime.utc(2026, 8, 13, 19, 24, 37, 287, 867));
    });

    test('fromJson keeps unearned badges locked with a null earnedAt', () {
      final badge = GamificationBadge.fromJson({
        'id': 'material_25',
        'category': 'Учёба',
        'name': 'Хранитель знаний',
        'description': '25 публичных материалов',
        'emoji': '🏛️',
        'rarity': 'epic',
        'xpReward': 100,
        'shurikenReward': 50,
        'isEarned': false,
        'progress': 0.24,
        'earnedAt': null,
      });

      expect(badge.isEarned, isFalse);
      expect(badge.progress, closeTo(0.24, 0.001));
      expect(badge.earnedAt, isNull);
    });
  });

  group('ActivityDay', () {
    test('fromJson maps the day and count columns', () {
      final day = ActivityDay.fromJson({'day': '2026-09-03', 'count': 3});

      expect(day.day, DateTime(2026, 9, 3));
      expect(day.count, 3);
      expect(day.isActive, isTrue);
    });

    test('fromJson defaults count to zero and stays inactive', () {
      final day = ActivityDay.fromJson({'day': '2026-09-01'});

      expect(day.count, 0);
      expect(day.isActive, isFalse);
    });
  });

  group('GamificationQuest', () {
    test('fromJson maps fields and computes period getters (daily)', () {
      final quest = GamificationQuest.fromJson({
        'id': 'q1',
        'period': 'daily',
        'emoji': '☀️',
        'title': 'Open the app',
        'target': 1,
        'xpReward': 10,
        'progress': 1,
        'isCompleted': true,
        'completedAt': '2026-06-12T08:00:00.000Z',
      });

      expect(quest.id, 'q1');
      expect(quest.period, 'daily');
      expect(quest.emoji, '☀️');
      expect(quest.title, 'Open the app');
      expect(quest.target, 1);
      expect(quest.xpReward, 10);
      expect(quest.progress, 1);
      expect(quest.isCompleted, isTrue);
      expect(quest.completedAt, DateTime.utc(2026, 6, 12, 8));
      expect(quest.isDaily, isTrue);
      expect(quest.isWeekly, isFalse);
    });

    test('fromJson defaults progress/isCompleted and computes weekly', () {
      final quest = GamificationQuest.fromJson({
        'id': 'q2',
        'period': 'weekly',
        'emoji': '📅',
        'title': 'Study 5 times',
        'target': 5,
        'xpReward': 50,
      });

      expect(quest.progress, 0);
      expect(quest.isCompleted, isFalse);
      expect(quest.completedAt, isNull);
      expect(quest.isDaily, isFalse);
      expect(quest.isWeekly, isTrue);
    });

    test('isDaily and isWeekly are both false for other period', () {
      final quest = GamificationQuest.fromJson({
        'id': 'q3',
        'period': 'special',
        'emoji': '⭐',
        'title': 'Event',
        'target': 3,
        'xpReward': 30,
      });

      expect(quest.isDaily, isFalse);
      expect(quest.isWeekly, isFalse);
    });
  });

  group('LeaderboardEntry', () {
    test('fromJson maps all fields', () {
      final entry = LeaderboardEntry.fromJson({
        'userId': 'u1',
        'displayName': 'Ivan Petrov',
        'xp': 2000,
        'level': 9,
        'streakDays': 5,
        'isCurrentUser': true,
      });

      expect(entry.userId, 'u1');
      expect(entry.displayName, 'Ivan Petrov');
      expect(entry.xp, 2000);
      expect(entry.level, 9);
      expect(entry.streakDays, 5);
      expect(entry.isCurrentUser, isTrue);
    });

    test('fromJson applies defaults for missing optional keys', () {
      final entry = LeaderboardEntry.fromJson({
        'userId': 'u2',
        'xp': 100,
      });

      expect(entry.displayName, 'Студент');
      expect(entry.level, 1);
      expect(entry.streakDays, 0);
      expect(entry.isCurrentUser, isFalse);
    });

    test('initials returns first letters of two name parts uppercased', () {
      final entry = LeaderboardEntry.fromJson({
        'userId': 'u',
        'displayName': 'ivan petrov',
        'xp': 1,
      });

      expect(entry.initials, 'IP');
    });

    test('initials uses first three+ part-aware (only first two used)', () {
      final entry = LeaderboardEntry.fromJson({
        'userId': 'u',
        'displayName': 'Anna Maria Smith',
        'xp': 1,
      });

      expect(entry.initials, 'AM');
    });

    test('initials returns single uppercased char for one-word name', () {
      final entry = LeaderboardEntry.fromJson({
        'userId': 'u',
        'displayName': 'cat',
        'xp': 1,
      });

      expect(entry.initials, 'C');
    });

    test('initials falls back to "?" for default name has two parts', () {
      final entry = LeaderboardEntry.fromJson({
        'userId': 'u',
        'xp': 1,
      });

      expect(entry.initials, 'С');
    });
  });

  group('SquadChallenge', () {
    test('fromJson maps all fields', () {
      final challenge = SquadChallenge.fromJson({
        'id': 'sc1',
        'title': 'Team Sprint',
        'description': 'Collect 100 points together',
        'rewardShurikens': 50,
        'target': 100,
        'progress': 40,
        'endsAt': '2030-01-01T00:00:00.000Z',
      });

      expect(challenge.id, 'sc1');
      expect(challenge.title, 'Team Sprint');
      expect(challenge.description, 'Collect 100 points together');
      expect(challenge.rewardShurikens, 50);
      expect(challenge.target, 100);
      expect(challenge.progress, 40);
      expect(challenge.endsAt, DateTime.utc(2030));
    });

    test('daysLeft is positive for a future endsAt', () {
      final future = DateTime.now().add(const Duration(days: 10));
      final challenge = SquadChallenge.fromJson({
        'id': 'sc2',
        'title': 't',
        'description': 'd',
        'rewardShurikens': 1,
        'target': 1,
        'progress': 0,
        'endsAt': future.toIso8601String(),
      });

      expect(challenge.daysLeft, inInclusiveRange(8, 10));
    });

    test('daysLeft clamps to 0 for a past endsAt', () {
      final past = DateTime.now().subtract(const Duration(days: 5));
      final challenge = SquadChallenge.fromJson({
        'id': 'sc3',
        'title': 't',
        'description': 'd',
        'rewardShurikens': 1,
        'target': 1,
        'progress': 0,
        'endsAt': past.toIso8601String(),
      });

      expect(challenge.daysLeft, 0);
    });
  });

  group('AcademicProfile', () {
    test('fromJson maps all fields', () {
      final profile = AcademicProfile.fromJson({
        'handle': '@ivan',
        'group': 'BBSO-01-23',
        'course': 2,
        'fullName': 'Ivan Petrov',
        'studentCardNumber': '123456',
        'cardValidUntil': '2027-08-31T00:00:00.000Z',
      });

      expect(profile.handle, '@ivan');
      expect(profile.group, 'BBSO-01-23');
      expect(profile.course, 2);
      expect(profile.fullName, 'Ivan Petrov');
      expect(profile.studentCardNumber, '123456');
      expect(profile.cardValidUntil, DateTime.utc(2027, 8, 31));
    });

    test('fromJson yields all-null on empty map', () {
      final profile = AcademicProfile.fromJson(const {});

      expect(profile.handle, isNull);
      expect(profile.group, isNull);
      expect(profile.course, isNull);
      expect(profile.fullName, isNull);
      expect(profile.studentCardNumber, isNull);
      expect(profile.cardValidUntil, isNull);
    });

    test('empty constant matches empty-map fromJson', () {
      expect(AcademicProfile.empty, AcademicProfile.fromJson(const {}));
    });
  });

  group('SemesterStats', () {
    test('fromJson maps fields with double parsing', () {
      final stats = SemesterStats.fromJson({
        'label': 'Autumn 2026',
        'moduleLabel': 'Module 1',
        'gpa': 4,
      });

      expect(stats.label, 'Autumn 2026');
      expect(stats.moduleLabel, 'Module 1');
      expect(stats.gpa, 4.0);
      expect(stats.gpa, isA<double>());
    });

    test('fromJson yields all-null on empty map', () {
      final stats = SemesterStats.fromJson(const {});

      expect(stats.label, isNull);
      expect(stats.moduleLabel, isNull);
      expect(stats.gpa, isNull);
    });

    test('empty constant is all null', () {
      expect(SemesterStats.empty, SemesterStats.fromJson(const {}));
    });
  });

  group('ProfileOverview', () {
    test('fromJson maps nested academic, semester and badge counts', () {
      final overview = ProfileOverview.fromJson({
        'academic': {'group': 'G1', 'course': 1},
        'semester': {'gpa': 4.5},
        'groupRank': 3,
        'groupSize': 28,
        'streakHistory': [true, false, true],
        'badgeCounts': {'earned': 7, 'total': 20},
      });

      expect(overview.academic.group, 'G1');
      expect(overview.academic.course, 1);
      expect(overview.semester.gpa, 4.5);
      expect(overview.groupRank, 3);
      expect(overview.groupSize, 28);
      expect(overview.streakHistory, [true, false, true]);
      expect(overview.earnedBadges, 7);
      expect(overview.totalBadges, 20);
    });

    test('fromJson applies defaults on empty map', () {
      final overview = ProfileOverview.fromJson(const {});

      expect(overview.academic, AcademicProfile.empty);
      expect(overview.semester, SemesterStats.empty);
      expect(overview.groupRank, isNull);
      expect(overview.groupSize, isNull);
      expect(overview.streakHistory, isEmpty);
      expect(overview.earnedBadges, 0);
      expect(overview.totalBadges, 0);
    });

    test('streakHistory maps any non-true element to false', () {
      final overview = ProfileOverview.fromJson({
        'streakHistory': [true, 1, 'yes', null, false],
      });

      expect(overview.streakHistory, [true, false, false, false, false]);
    });

    test('empty constant has empty streak history and zero counts', () {
      expect(ProfileOverview.empty.streakHistory, isEmpty);
      expect(ProfileOverview.empty.earnedBadges, 0);
      expect(ProfileOverview.empty.totalBadges, 0);
      expect(ProfileOverview.empty.academic, AcademicProfile.empty);
    });
  });

  group('ShurikenEntry', () {
    test('fromJson maps fields', () {
      final entry = ShurikenEntry.fromJson({
        'title': 'Daily login',
        'amount': 5,
        'emoji': '🎁',
        'createdAt': '2026-06-12T00:00:00.000Z',
      });

      expect(entry.title, 'Daily login');
      expect(entry.amount, 5);
      expect(entry.emoji, '🎁');
      expect(entry.createdAt, DateTime.utc(2026, 6, 12));
      expect(entry.isSpend, isFalse);
    });

    test('fromJson applies defaults including default emoji', () {
      final entry = ShurikenEntry.fromJson(const {});

      expect(entry.title, '');
      expect(entry.amount, 0);
      expect(entry.emoji, '✨');
      expect(entry.createdAt, isNull);
      expect(entry.isSpend, isFalse);
    });

    test('isSpend is true when amount is negative', () {
      final entry = ShurikenEntry.fromJson({
        'title': 'Bought theme',
        'amount': -10,
      });

      expect(entry.isSpend, isTrue);
    });

    test('isSpend is false when amount is exactly zero', () {
      final entry = ShurikenEntry.fromJson({'title': 't', 'amount': 0});

      expect(entry.isSpend, isFalse);
    });
  });

  group('UserSettings', () {
    test('fromJson maps all fields', () {
      final settings = UserSettings.fromJson({
        'notificationsEnabled': false,
        'scheduleChangeAlerts': false,
        'questReminders': false,
        'achievementAlerts': false,
        'leaderboardUpdates': true,
        'themeMode': 'dark',
        'accentColor': 'green',
        'density': 'compact',
        'showMascot': false,
        'profileVisibility': 'group',
        'anonymousReactions': false,
      });

      expect(settings.notificationsEnabled, isFalse);
      expect(settings.scheduleChangeAlerts, isFalse);
      expect(settings.questReminders, isFalse);
      expect(settings.achievementAlerts, isFalse);
      expect(settings.leaderboardUpdates, isTrue);
      expect(settings.themeMode, 'dark');
      expect(settings.accentColor, 'green');
      expect(settings.density, 'compact');
      expect(settings.showMascot, isFalse);
      expect(settings.profileVisibility, ProfileVisibility.group);
      expect(settings.anonymousReactions, isFalse);
    });

    test('fromJson applies defaults on empty map', () {
      final settings = UserSettings.fromJson(const {});

      expect(settings.notificationsEnabled, isTrue);
      expect(settings.scheduleChangeAlerts, isTrue);
      expect(settings.questReminders, isTrue);
      expect(settings.achievementAlerts, isTrue);
      expect(settings.leaderboardUpdates, isFalse);
      expect(settings.themeMode, 'system');
      expect(settings.accentColor, 'blue');
      expect(settings.density, 'default');
      expect(settings.showMascot, isTrue);
      expect(settings.profileVisibility, ProfileVisibility.everyone);
      expect(settings.anonymousReactions, isTrue);
    });

    test('ProfileVisibility.fromName parses known values, defaults safely', () {
      expect(
        ProfileVisibility.fromName('everyone'),
        ProfileVisibility.everyone,
      );
      expect(ProfileVisibility.fromName('group'), ProfileVisibility.group);
      expect(ProfileVisibility.fromName('nobody'), ProfileVisibility.nobody);
      expect(ProfileVisibility.fromName(null), ProfileVisibility.everyone);
      expect(ProfileVisibility.fromName('???'), ProfileVisibility.everyone);
    });

    test('copyWith overrides only provided fields', () {
      const settings = UserSettings();
      final updated = settings.copyWith(
        themeMode: 'dark',
        showMascot: false,
      );

      expect(updated.themeMode, 'dark');
      expect(updated.showMascot, isFalse);
      expect(updated.notificationsEnabled, isTrue);
      expect(updated.accentColor, 'blue');
      expect(updated.density, 'default');
    });

    test('copyWith with no args returns equal value', () {
      const settings = UserSettings(themeMode: 'light', accentColor: 'red');

      expect(settings.copyWith(), settings);
    });
  });

  group('JSON serialization', () {
    test('serializes nested profile data as JSON objects', () {
      const profile = UserGamificationProfile(
        userId: 'user',
        recentBadge: GamificationBadgeSummary(
          id: 'badge',
          name: 'Badge',
          emoji: '🏅',
        ),
      );

      expect(profile.toJson()['recentBadge'], {
        'id': 'badge',
        'name': 'Badge',
        'emoji': '🏅',
        'rarity': 'common',
      });
    });

    test('round-trips settings through generated JSON', () {
      const settings = UserSettings(
        notificationsEnabled: false,
        profileVisibility: .group,
        themeMode: 'dark',
      );

      expect(UserSettings.fromJson(settings.toJson()), settings);
    });

    test('serializes overview nested models explicitly', () {
      const overview = ProfileOverview(
        academic: AcademicProfile(group: 'G1'),
        semester: SemesterStats(gpa: 4.5),
        earnedBadges: 2,
        totalBadges: 5,
      );
      final json = overview.toJson();

      expect(json['academic'], containsPair('group', 'G1'));
      expect(json['semester'], containsPair('gpa', 4.5));
      expect(json['earnedBadges'], 2);
      expect(json['totalBadges'], 5);
    });
  });
}
