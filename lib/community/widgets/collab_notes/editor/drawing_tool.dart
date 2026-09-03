enum DrawingTool { pen, marker, eraser }

enum DrawingStrokeWidth { thin, medium, thick }

extension DrawingStrokeWidthValue on DrawingStrokeWidth {
  double value(DrawingTool tool) {
    final base = switch (this) {
      DrawingStrokeWidth.thin => 4.0,
      DrawingStrokeWidth.medium => 8.0,
      DrawingStrokeWidth.thick => 14.0,
    };
    return tool == .marker ? base * 1.8 : base;
  }
}
