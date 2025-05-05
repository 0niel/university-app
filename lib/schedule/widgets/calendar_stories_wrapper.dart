import 'package:flutter/material.dart';

/// A wrapper for CalendarStoriesAppBar to use it in non-sliver contexts
class CalendarStoriesWrapper extends StatelessWidget {
  const CalendarStoriesWrapper({super.key, required this.isStoriesVisible, required this.onStoriesLoaded});

  final bool isStoriesVisible;
  final ValueChanged<bool> onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    return const CalendarStoriesPlaceholder();
  }
}

/// A placeholder widget to show when stories are not visible
class CalendarStoriesPlaceholder extends StatelessWidget {
  const CalendarStoriesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8); // Placeholder spacing
  }
}
