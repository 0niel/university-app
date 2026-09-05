enum DrawingTool { pen, marker, eraser }

enum DrawingStrokeWidth { thin, medium, thick }

extension DrawingStrokeWidthValue on DrawingStrokeWidth {
  double value(DrawingTool tool) {
    final base = switch (this) {
      DrawingStrokeWidth.thin => 4.0,
      DrawingStrokeWidth.medium => 8.0,
      DrawingStrokeWidth.thick => 14.0,
    };
    return switch (tool) {
      DrawingTool.pen => base,
      DrawingTool.marker => base * 1.8,
      DrawingTool.eraser => base * 2.5,
    };
  }
}
