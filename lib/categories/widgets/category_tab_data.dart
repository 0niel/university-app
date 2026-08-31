import 'package:flutter/widgets.dart';

class CategoryTabData {
  const CategoryTabData({required this.categoryName, this.onDoubleTap});

  final String categoryName;
  final VoidCallback? onDoubleTap;
}
