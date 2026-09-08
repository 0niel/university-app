int mapPlaceLandmarkPriority(String kind) => switch (kind) {
  'entrance' || 'exit' => 6000,
  'cafeteria' || 'cafe' || 'canteen' || 'food' => 5000,
  'medical' || 'first_aid' => 4500,
  'library' => 4000,
  'elevator' || 'lift' || 'ramp' => 5500,
  'stairs' || 'staircase' || 'escalator' => 5400,
  _ => 0,
};
