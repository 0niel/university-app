import 'package:campus_repository/campus_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Mentor telegramHandle', () {
    test('fromJson maps telegramHandle when present', () {
      final mentor = Mentor.fromJson(const <String, dynamic>{
        'userId': 'u1',
        'fullName': 'Anna P',
        'telegramHandle': 'anna_mentor',
      });

      expect(mentor.telegramHandle, 'anna_mentor');
    });

    test('fromJson leaves telegramHandle null when absent', () {
      final mentor = Mentor.fromJson(const <String, dynamic>{
        'userId': 'u1',
        'fullName': 'Anna P',
      });

      expect(mentor.telegramHandle, isNull);
    });

    test('round-trips through toJson', () {
      const mentor = Mentor(
        userId: 'u1',
        fullName: 'Anna P',
        telegramHandle: 'anna_mentor',
      );

      expect(Mentor.fromJson(mentor.toJson()), mentor);
    });
  });

  group('MentorRequest replyTelegramHandle', () {
    test('exposes the mentor handle for an outgoing request', () {
      const request = MentorRequest(
        id: 'r1',
        mentorUserId: 'mentor-1',
        requesterId: 'requester-1',
        isIncoming: false,
        mentorTelegramHandle: 'mentor_ninja',
      );

      expect(request.replyTelegramHandle, 'mentor_ninja');
    });

    test('is null for an incoming request even with a mentor handle', () {
      const request = MentorRequest(
        id: 'r1',
        mentorUserId: 'mentor-1',
        requesterId: 'requester-1',
        mentorTelegramHandle: 'mentor_ninja',
      );

      expect(request.replyTelegramHandle, isNull);
    });

    test('is null when the mentor never set a handle', () {
      const request = MentorRequest(
        id: 'r1',
        mentorUserId: 'mentor-1',
        requesterId: 'requester-1',
        isIncoming: false,
      );

      expect(request.replyTelegramHandle, isNull);
    });
  });
}
