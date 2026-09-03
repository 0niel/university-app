String normalizeScheduleSearch(String value) => value
    .trim()
    .toLowerCase()
    .replaceAll('ё', 'е')
    .replaceAll(RegExp('[^a-zа-я0-9]'), '');
