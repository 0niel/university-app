import argparse
import copy
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import re
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'packages/app_ui/assets/maps/mp-1'
OUTPUT = ROOT / 'packages/app_ui/assets/maps/pulse'
LABELS = Path(__file__).with_name('source') / 'mp1_labels.json'
SOURCE_URL = 'https://github.com/0niel/university-app/tree/master/packages/app_ui/assets/maps/mp-1'
LEVELS = (-1, 1, 2, 3, 4, 5)
SHAPES = {'rect', 'path', 'circle', 'ellipse', 'line', 'polygon', 'polyline'}
NUMBER = re.compile(r'[-+]?(?:\d*\.\d+|\d+\.?\d*)(?:[eE][-+]?\d+)?')
_LOCATIONS_SPEC = importlib.util.spec_from_file_location('campus_locations', Path(__file__).with_name('campus_locations.py'))
_LOCATIONS = importlib.util.module_from_spec(_LOCATIONS_SPEC)
_LOCATIONS_SPEC.loader.exec_module(_LOCATIONS)


def sha(value):
    return hashlib.sha256(value.encode('utf-8')).hexdigest()


def multiply(a, b):
    return (a[0]*b[0]+a[2]*b[1], a[1]*b[0]+a[3]*b[1],
            a[0]*b[2]+a[2]*b[3], a[1]*b[2]+a[3]*b[3],
            a[0]*b[4]+a[2]*b[5]+a[4], a[1]*b[4]+a[3]*b[5]+a[5])


def transform(value):
    matrix = (1, 0, 0, 1, 0, 0)
    for match in re.finditer(r'([a-zA-Z]+)\s*\(([^)]*)\)', value):
        name, raw = match.groups()
        v = [float(x) for x in NUMBER.findall(raw)]
        if not all(math.isfinite(x) for x in v):
            raise ValueError('Non-finite transform')
        if name == 'matrix' and len(v) == 6:
            part = tuple(v)
        elif name == 'translate' and len(v) in (1, 2):
            part = (1, 0, 0, 1, v[0], v[1] if len(v) == 2 else 0)
        elif name == 'scale' and len(v) in (1, 2):
            part = (v[0], 0, 0, v[-1], 0, 0)
        elif name == 'rotate' and len(v) in (1, 3):
            c, s = math.cos(math.radians(v[0])), math.sin(math.radians(v[0]))
            x, y = v[1:] if len(v) == 3 else (0, 0)
            part = (c, s, -s, c, x-c*x+s*y, y-s*x-c*y)
        else:
            raise ValueError(f'Unreviewed transform: {name}')
        matrix = multiply(matrix, part)
    if re.sub(r'([a-zA-Z]+)\s*\(([^)]*)\)', '', value).strip():
        raise ValueError('Malformed transform')
    return matrix


def outer_groups(root, class_name):
    parents = {child: parent for parent in root.iter() for child in parent}
    result = []
    for element in root.iter('g'):
        if element.get('class') != class_name:
            continue
        ancestor = parents.get(element)
        while ancestor is not None and ancestor.get('class') != class_name:
            ancestor = parents.get(ancestor)
        if ancestor is None:
            result.append(element)
    return result


def expand_uses(root):
    references = {element.get('id'): element for element in root.iter() if element.get('id')}

    def visit(parent, active=()):
        for index, child in enumerate(list(parent)):
            if child.tag != 'use':
                visit(child, active)
                continue
            href = child.get('href', '')
            if not href.startswith('#') or href[1:] not in references or href in active:
                raise ValueError('Invalid or cyclic local SVG reference')
            wrapper = ET.Element('g', {k: v for k, v in child.attrib.items() if k not in {'href', 'x', 'y'}})
            offset = ET.SubElement(wrapper, 'g', {'transform': f"translate({child.get('x', '0')} {child.get('y', '0')})"})
            clone = copy.deepcopy(references[href[1:]])
            for element in clone.iter():
                element.attrib.pop('id', None)
            offset.append(clone)
            parent.remove(child)
            parent.insert(index, wrapper)
            visit(wrapper, (*active, href))

    visit(root)


def room_bounds(group, parents):
    rectangles = list(group.iter('rect'))
    if not rectangles:
        raise ValueError('Semantic room has no reviewed geometry')
    points = []
    for rectangle in rectangles:
        chain, current = [], rectangle
        while current is not None:
            chain.append(current)
            current = parents.get(current)
        matrix = (1, 0, 0, 1, 0, 0)
        for element in reversed(chain):
            matrix = multiply(matrix, transform(element.get('transform', '')))
        x, y, w, h = (float(rectangle.get(k, '0')) for k in ('x', 'y', 'width', 'height'))
        if not all(math.isfinite(v) for v in (x, y, w, h)) or min(w, h) <= 0:
            raise ValueError('Invalid room rectangle')
        points.extend((matrix[0]*px+matrix[2]*py+matrix[4], matrix[1]*px+matrix[3]*py+matrix[5])
                      for px, py in ((x, y), (x+w, y), (x, y+h), (x+w, y+h)))
    return (min(x for x, _ in points), min(y for _, y in points),
            max(x for x, _ in points), max(y for _, y in points))


def geometry_key(group):
    keys = ('x', 'y', 'width', 'height', 'rx', 'ry', 'transform')
    return json.dumps([(element.tag, [(key, element.get(key)) for key in keys if element.get(key)])
                       for element in group.iter() if element.tag in {'g', 'rect'}], separators=(',', ':'))


def canonicalize(level, source_text, labels):
    if level not in LEVELS or '<!DOCTYPE' in source_text or '<!ENTITY' in source_text:
        raise ValueError('Unexpected floor source')
    original = ET.fromstring(source_text)
    for element in original.iter():
        element.tag = element.tag.split('}')[-1]
        element.attrib = {key.split('}')[-1]: value for key, value in element.attrib.items()}
        if element.tag not in SHAPES | {'svg', 'g', 'defs', 'clipPath', 'use', 'filter',
                                      'feFlood', 'feColorMatrix', 'feOffset', 'feGaussianBlur',
                                      'feComposite', 'feBlend'}:
            raise ValueError(f'Unreviewed SVG element: {element.tag}')
        if any(key.lower().startswith('on') for key in element.attrib):
            raise ValueError('Active SVG is unsupported')
        if element.get('href') and not element.get('href').startswith('#'):
            raise ValueError('External SVG reference is unsupported')
        if any('url(' in value and not re.fullmatch(r'url\(#[\w-]+\)', value)
               for value in element.attrib.values()):
            raise ValueError('External SVG resource is unsupported')
    viewbox = list(map(float, original.attrib['viewBox'].split()))
    if (len(viewbox) != 4 or not all(math.isfinite(value) for value in viewbox)
            or viewbox[:2] != [0, 0] or min(viewbox[2:]) <= 0):
        raise ValueError('Unexpected source coordinates')
    scale = 2000 / max(viewbox[2:])
    width, height = (round(value*scale, 6) for value in viewbox[2:])
    floor_id = f'mp-1-floor{0 if level == -1 else level}'
    source_asset = f'packages/app_ui/assets/maps/mp-1/{level}.svg'
    root = ET.Element('svg', {'xmlns': 'http://www.w3.org/2000/svg', 'viewBox': f'0 0 {width:g} {height:g}',
                              'width': f'{width:g}', 'height': f'{height:g}', 'fill': original.get('fill', 'none')})
    scaled = ET.SubElement(root, 'g', {'transform': f'scale({scale:.12g})'})
    scaled.extend(list(original))
    expand_uses(root)
    parents = {child: parent for parent in root.iter() for child in parent}
    label_by_group = {row['source_group']: row for row in labels}
    rooms, seen = [], set()
    groups = outer_groups(root, 'Room')
    for kind, semantic_groups in (('room', groups), ('stairs', outer_groups(root, 'Ladder'))):
        for index, group in enumerate(semantic_groups):
            bounds = room_bounds(group, parents)
            geometry = geometry_key(group) + json.dumps(bounds)
            identifier = f'{floor_id}--{kind}--{sha(geometry)[:16]}'
            if identifier in seen:
                if kind != 'stairs':
                    raise ValueError(f'Duplicate room geometry: {level}/{index}')
                next(room for room in rooms if room['id'] == identifier).setdefault('source_duplicate_groups', []).append(index)
                continue
            seen.add(identifier)
            record = {'id': identifier, 'floor_id': floor_id, 'kind': kind, 'equipment': [], 'menu': [],
                      'source_asset': source_asset, 'source_url': SOURCE_URL, 'source_group': index,
                      'source_geometry_sha256': sha(geometry)}
            label = 'Лестница'
            if kind == 'room':
                glyphs = [element for element in group.iter('path')
                          if element.get('fill', '').lower() in {'#fff', '#ffffff', 'white'}]
                if (len(glyphs) != 1 or len(list(group.iter('path'))) != 1
                        or any(element.tag in SHAPES - {'rect', 'path'} for element in group.iter())):
                    raise ValueError('Room geometry or labels require review')
                glyph = glyphs[0]
                mapped = label_by_group.get(index)
                if mapped and mapped['glyph_sha256'] == sha(glyph.get('d', '')):
                    label = mapped['label']
                    record['label_status'] = 'source_vector_transcription'
                    record['source_label_path'] = glyph.get('d')
                    record['source_label_sha256'] = mapped['glyph_sha256']
                    parents[glyph].remove(glyph)
                else:
                    raise ValueError(f'{level}/{index}: source glyph changed; review its transcription')
                if label == 'Туалет':
                    record['kind'] = 'toilet'
            record['label'] = label
            bounds = room_bounds(group, parents)
            if bounds[0] < -0.01 or bounds[1] < -0.01 or bounds[2] > width+0.01 or bounds[3] > height+0.01:
                raise ValueError('Room geometry escapes source viewBox')
            record.update(x=round((bounds[0]+bounds[2])/2, 6), y=round((bounds[1]+bounds[3])/2, 6))
            group.set('data-object', identifier)
            group.set('data-name', label)
            rooms.append(record)
    floor = {'id': floor_id, 'label': 'Цоколь' if level == -1 else f'{level} этаж', 'level': level,
             'width': width, 'height': height, 'anchors': [], 'svg': ET.tostring(root, encoding='unicode'),
             'source_asset': source_asset, 'source_sha256': sha(source_text)}
    return floor, rooms


def build(output=OUTPUT):
    labels = json.loads(LABELS.read_text(encoding='utf-8'))['floors']
    floors, rooms = [], []
    for level in LEVELS:
        floor, places = canonicalize(level, (SOURCE / f'{level}.svg').read_text(encoding='utf-8'), labels[str(level)])
        floors.append(floor)
        rooms.extend(places)
    campus = {'schema_version': 1, 'organization_id': 'mirea', 'id': 'mp-1', 'title': 'Малая Пироговская, 1',
              'short_title': 'МП-1', 'address': 'Москва, улица Малая Пироговская, 1', 'revision': 1,
              'source_url': SOURCE_URL, 'source_label': 'Планы University App · МП-1',
              **_LOCATIONS.location_for('МП-1'),
              'floors': floors, 'rooms': rooms, 'graph': {'nodes': [], 'edges': []},
              'provenance': {'source': 'existing_repository_svg_assets', 'label_method': 'visual_transcription_of_original_vector_paths',
                             'physical_verification': False, 'routing_available': False}}
    output.mkdir(parents=True, exist_ok=True)
    (output / 'campus_mp-1.json').write_text(json.dumps(campus, ensure_ascii=False, separators=(',', ':'))+'\n', encoding='utf-8')
    return {'id': campus['id'], 'title': campus['title'], 'short_title': campus['short_title'],
            'revision': campus['revision'], 'asset': 'packages/app_ui/assets/maps/pulse/campus_mp-1.json',
            **{key: campus[key] for key in ('latitude', 'longitude', 'location_source')},
            'source_url': SOURCE_URL, 'source_label': campus['source_label']}


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, default=OUTPUT)
    args = parser.parse_args()
    print(json.dumps(build(args.output), ensure_ascii=False, indent=2))
