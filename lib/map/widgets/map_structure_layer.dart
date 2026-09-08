import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/services/map_scale_repaint.dart';
import 'package:rtu_mirea_app/map/services/map_viewport_painter.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:xml/xml.dart';

class MapStructureLayer extends StatefulWidget {
  const MapStructureLayer({
    required this.svg,
    required this.size,
    this.openingsOnly = false,
    this.transform,
    this.viewportSize,
    super.key,
  });

  final String svg;
  final Size size;
  final bool openingsOnly;
  final ValueListenable<Matrix4>? transform;
  final Size? viewportSize;

  @override
  State<MapStructureLayer> createState() => _MapStructureLayerState();
}

class _MapStructureLayerState extends State<MapStructureLayer> {
  late MapStructureLayers _layers;
  late final MapScaleRepaint _scale;

  @override
  void initState() {
    super.initState();
    _layers = MapStructureLayers.fromSvg(widget.svg);
    _scale = MapScaleRepaint(widget.transform);
  }

  @override
  void didUpdateWidget(MapStructureLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scale.updateTransform(widget.transform);
    if (oldWidget.svg != widget.svg) {
      _layers = MapStructureLayers.fromSvg(widget.svg);
    }
  }

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  CustomPainter _painter(AppColors colors) {
    final painter = _StructurePainter(
      widget.openingsOnly ? _layers.openingShapes : _layers.foundationShapes,
      colors,
      openingsOnly: widget.openingsOnly,
      scale: _scale,
    );
    return widget.viewportSize == null
        ? painter
        : MapViewportPainter(
            painter: painter,
            sceneSize: widget.size,
            transform: widget.transform,
          );
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: RepaintBoundary(
      child: SizedBox.fromSize(
        size: widget.viewportSize ?? widget.size,
        child: CustomPaint(
          painter: _painter(context.colors),
        ),
      ),
    ),
  );
}

class MapStructureLayers {
  const MapStructureLayers._(
    this.foundation,
    this.openings,
    this.foundationShapes,
    this.openingShapes,
  );

  factory MapStructureLayers.fromSvg(String svg) {
    final cached = _cache.remove(svg);
    if (cached != null) {
      _cache[svg] = cached;
      return cached;
    }
    final root = XmlDocument.parse(svg).rootElement;
    if (root.name.local != 'svg') {
      throw const FormatException('Structural map layer requires SVG');
    }
    final viewBox = _viewBox(root);
    final foundation = _split(root, viewBox, openingsOnly: false)!;
    final openings = _split(root, viewBox, openingsOnly: true)!;
    final result = MapStructureLayers._(
      foundation.toXmlString(),
      openings.toXmlString(),
      _parseShapes(foundation, viewBox),
      _parseShapes(openings, viewBox),
    );
    _cache[svg] = result;
    while (_cache.length > 4) {
      _cache.remove(_cache.keys.first);
    }
    return result;
  }

  static final _cache = <String, MapStructureLayers>{};

  final String foundation;
  final String openings;
  final List<MapStructureShape> foundationShapes;
  final List<MapStructureShape> openingShapes;

  static List<MapStructureShape> _parseShapes(XmlElement root, Rect viewBox) {
    final clipsById = {
      for (final clip in root.descendants.whereType<XmlElement>())
        if (clip.name.local == 'clipPath' && clip.getAttribute('id') != null)
          clip.getAttribute('id')!: clip,
    };
    final result = <MapStructureShape>[];
    void visit(
      XmlElement element,
      Matrix4 parent,
      _StructureStyle inherited,
      List<Path> clips,
    ) {
      if (_definitions.contains(element.name.local)) return;
      final style = inherited.inherit(element);
      if (!style.displayed) return;
      final matrix = parent.multiplied(SvgRoomParser.elementTransform(element));
      final clipId = RegExp(
        r'^url\(\s*#([^\s)]+)\s*\)$',
      ).firstMatch(_attribute(element, 'clip-path') ?? '')?.group(1);
      final clipElement = clipsById[clipId];
      final activeClips = clipElement == null
          ? clips
          : [...clips, _clipPath(clipElement, element, matrix)];
      final path = SvgRoomParser.elementPath(element, includeLines: true);
      if (path != null && style.visible) {
        result.add(
          MapStructureShape(
            path: path.transform(matrix.storage),
            fill: element.name.local != 'line' && style.fill,
            stroke: style.stroke,
            fillOpacity: style.opacity * style.fillOpacity,
            strokeOpacity: style.opacity * style.strokeOpacity,
            clips: List.unmodifiable(activeClips),
          ),
        );
      }
      for (final child in element.childElements) {
        visit(child, matrix, style, activeClips);
      }
    }

    visit(
      root,
      Matrix4.identity()..translateByDouble(-viewBox.left, -viewBox.top, 0, 1),
      const _StructureStyle(),
      const [],
    );
    return List.unmodifiable(result);
  }

  static Path _clipPath(
    XmlElement definition,
    XmlElement target,
    Matrix4 targetMatrix,
  ) {
    var matrix = targetMatrix;
    if (definition.getAttribute('clipPathUnits') == 'objectBoundingBox') {
      final bounds = _combinedGeometry(
        target,
        Matrix4.identity(),
        includeRootTransform: false,
      ).getBounds();
      matrix = matrix.multiplied(
        Matrix4.identity()
          ..translateByDouble(bounds.left, bounds.top, 0, 1)
          ..scaleByDouble(bounds.width, bounds.height, 1, 1),
      );
    }
    return _combinedGeometry(definition, matrix);
  }

  static Path _combinedGeometry(
    XmlElement element,
    Matrix4 parent, {
    bool includeRootTransform = true,
  }) {
    final matrix = includeRootTransform
        ? parent.multiplied(SvgRoomParser.elementTransform(element))
        : parent;
    final local = SvgRoomParser.elementPath(element, includeLines: true);
    final clipRule = [element, ...element.ancestors.whereType<XmlElement>()]
        .map((node) => _attribute(node, 'clip-rule'))
        .whereType<String>()
        .firstOrNull;
    if (local != null && clipRule == 'evenodd') {
      local.fillType = PathFillType.evenOdd;
    }
    var result = local?.transform(matrix.storage) ?? Path();
    for (final child in element.childElements) {
      result = Path.combine(
        PathOperation.union,
        result,
        _combinedGeometry(child, matrix),
      );
    }
    return result;
  }

  static const _definitions = {
    'defs',
    'symbol',
    'clipPath',
    'mask',
    'pattern',
    'marker',
    'linearGradient',
    'radialGradient',
    'filter',
    'style',
    'title',
    'desc',
    'metadata',
  };
  static const _graphics = {
    'path',
    'rect',
    'circle',
    'ellipse',
    'polygon',
    'polyline',
    'image',
    'use',
    'text',
    'tspan',
  };

  static XmlElement? _split(
    XmlElement element,
    Rect viewBox, {
    required bool openingsOnly,
  }) {
    if (element.getAttribute('data-object') != null ||
        _background(element, viewBox)) {
      return null;
    }
    final tag = element.name.local;
    if (_definitions.contains(tag)) return element.copy();
    if (tag == 'line') return openingsOnly ? element.copy() : null;
    if (openingsOnly && _graphics.contains(tag)) return null;
    if (!openingsOnly && element.childElements.isEmpty) return element.copy();

    final copy = element.copy()..children.clear();
    for (final child in element.children) {
      if (child is XmlElement) {
        final retained = _split(child, viewBox, openingsOnly: openingsOnly);
        if (retained != null) copy.children.add(retained);
      } else if (!openingsOnly || tag == 'svg') {
        copy.children.add(child.copy());
      }
    }
    if (tag != 'svg' && copy.childElements.isEmpty && openingsOnly) return null;
    return copy;
  }

  static bool _background(XmlElement element, Rect viewBox) {
    if (element.name.local != 'rect' ||
        element.parentElement?.name.local != 'svg' ||
        element.getAttribute('transform') != null ||
        element.getAttribute('fill') == 'none') {
      return false;
    }
    final stroke = element.getAttribute('stroke');
    if (stroke != null && stroke != 'none') return false;
    double attribute(String name, [double fallback = 0]) =>
        double.tryParse(element.getAttribute(name) ?? '') ?? fallback;
    return (attribute('x') - viewBox.left).abs() < .000001 &&
        (attribute('y') - viewBox.top).abs() < .000001 &&
        (attribute('width', -1) - viewBox.width).abs() < .000001 &&
        (attribute('height', -1) - viewBox.height).abs() < .000001;
  }

  static Rect _viewBox(XmlElement root) {
    final values = (root.getAttribute('viewBox') ?? '')
        .trim()
        .split(RegExp(r'[\s,]+'))
        .map(double.tryParse)
        .toList();
    if (values.length != 4 ||
        values.any((value) => value == null || !value.isFinite)) {
      throw const FormatException('Structural map requires a finite viewBox');
    }
    return Rect.fromLTWH(values[0]!, values[1]!, values[2]!, values[3]!);
  }
}

class MapStructureShape {
  MapStructureShape({
    required this.path,
    required this.fill,
    required this.stroke,
    required this.fillOpacity,
    required this.strokeOpacity,
    required this.clips,
  }) : bounds = path.getBounds();

  final Path path;
  final Rect bounds;
  final bool fill;
  final bool stroke;
  final double fillOpacity;
  final double strokeOpacity;
  final List<Path> clips;
}

class _StructureStyle {
  const _StructureStyle({
    this.fill = true,
    this.stroke = false,
    this.opacity = 1,
    this.fillOpacity = 1,
    this.strokeOpacity = 1,
    this.displayed = true,
    this.visible = true,
  });

  final bool fill;
  final bool stroke;
  final double opacity;
  final double fillOpacity;
  final double strokeOpacity;
  final bool displayed;
  final bool visible;

  _StructureStyle inherit(XmlElement element) {
    bool paint(String attribute, {required bool inherited}) {
      final value = _attribute(element, attribute);
      return value == null || value == 'inherit'
          ? inherited
          : value != 'none' && value != 'transparent';
    }

    double alpha(String attribute, double inherited) {
      final value = _attribute(element, attribute);
      if (value == null) return inherited;
      final number = value.endsWith('%')
          ? (double.tryParse(value.substring(0, value.length - 1)) ?? 100) / 100
          : double.tryParse(value) ?? inherited;
      return number.isFinite ? number.clamp(0, 1) : inherited;
    }

    final visibility = _attribute(element, 'visibility');
    return _StructureStyle(
      fill: paint('fill', inherited: fill),
      stroke:
          paint('stroke', inherited: stroke) &&
          double.tryParse(_attribute(element, 'stroke-width') ?? '1') != 0,
      opacity: opacity * alpha('opacity', 1),
      fillOpacity: alpha('fill-opacity', fillOpacity),
      strokeOpacity: alpha('stroke-opacity', strokeOpacity),
      displayed: displayed && _attribute(element, 'display') != 'none',
      visible: visibility == null || visibility == 'inherit'
          ? visible
          : visibility != 'hidden' && visibility != 'collapse',
    );
  }
}

String? _attribute(XmlElement element, String name) {
  for (final part
      in (element.getAttribute('style') ?? '').split(';').reversed) {
    final separator = part.indexOf(':');
    if (separator >= 0 && part.substring(0, separator).trim() == name) {
      return part.substring(separator + 1).trim();
    }
  }
  return element.getAttribute(name)?.trim();
}

class _StructurePainter extends CustomPainter {
  _StructurePainter(
    this.shapes,
    this.colors, {
    required this.openingsOnly,
    required this.scale,
  }) : super(repaint: scale);

  final List<MapStructureShape> shapes;
  final AppColors colors;
  final bool openingsOnly;
  final ValueListenable<double> scale;

  @override
  void paint(Canvas canvas, Size size) {
    final visible = canvas.getLocalClipBounds().inflate(2 / scale.value);
    final outline = openingsOnly
        ? colors.surface
        : Color.alphaBlend(
            colors.muted2.withValues(alpha: .72),
            colors.surface,
          );
    final fill = Paint();
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = (openingsOnly ? 1.2 : 1) / scale.value;
    for (final shape in shapes) {
      if (!shape.bounds.overlaps(visible)) continue;
      if (shape.clips.isNotEmpty) {
        canvas.save();
        shape.clips.forEach(canvas.clipPath);
      }
      if (shape.fill && shape.fillOpacity > 0) {
        canvas.drawPath(
          shape.path,
          fill..color = colors.surface.withValues(alpha: shape.fillOpacity),
        );
      }
      if (shape.stroke && shape.strokeOpacity > 0) {
        canvas.drawPath(
          shape.path,
          stroke..color = outline.withValues(alpha: shape.strokeOpacity),
        );
      }
      if (shape.clips.isNotEmpty) canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_StructurePainter old) =>
      old.shapes != shapes ||
      old.colors != colors ||
      old.openingsOnly != openingsOnly ||
      old.scale != scale;
}
