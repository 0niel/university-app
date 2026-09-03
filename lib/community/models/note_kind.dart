enum NoteKind {
  lecture,
  practice,
  lab,
  doc;

  static NoteKind fromTitle(String title) {
    final text = title.toLowerCase();
    if (text.contains('лаб') || text.contains('lab')) return lab;
    if (text.contains('лек') || text.contains('lect')) return lecture;
    if (text.contains('практ') ||
        text.contains('семин') ||
        text.contains('pract') ||
        text.contains('semin')) {
      return practice;
    }
    return doc;
  }
}
