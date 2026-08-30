int monthCellLoadLevel(int lessonCount) {
  if (lessonCount <= 0) return 0;
  if (lessonCount > 5) return 3;
  if (lessonCount >= 3) return 2;
  return 1;
}
