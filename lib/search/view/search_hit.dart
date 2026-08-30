import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/search/widgets/item_type.dart';

class SearchHit {
  const SearchHit({
    required this.name,
    required this.type,
    required this.tagLabel,
    required this.onPressed,
    this.subtitle,
  });

  final String name;
  final ItemType type;
  final String tagLabel;
  final String? subtitle;
  final VoidCallback onPressed;
}
