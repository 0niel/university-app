enum LessonRowState {
  plain,
  past,
  current,
  next,
  moved,
  cancelled,
  exam,
  own;

  static const LessonRowState custom = LessonRowState.own;
}
