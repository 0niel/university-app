/// The supported lesson types.
enum LessonType {
  /// Seminar or default practical lesson.
  practice,

  /// Lecture (theoretical lesson).
  lecture,

  /// Laboratory lesson in a special room.
  laboratory,

  /// Individual lesson.
  individual,

  /// Physical education lesson (sport).
  physicalEducation,

  /// Consultation lesson.
  consultation,

  /// Exam lesson (session).
  exam,

  /// Credit lesson (session).
  credit,

  /// Course work lesson.
  courseWork,

  /// Course project lesson.
  courseProject,

  /// Unknown lesson type.
  other,
}
