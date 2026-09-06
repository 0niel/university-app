int mapPlaceLandmarkPriority(String kind) => switch (kind) {
  'entrance' || 'exit' => 6000,
  'cafeteria' || 'cafe' || 'canteen' || 'food' => 5000,
  'medical' || 'first_aid' => 4500,
  'library' => 4000,
  'elevator' || 'lift' => 3000,
  'stairs' || 'staircase' => 2000,
  _ => 0,
};
