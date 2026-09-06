import argparse
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import re
import xml.etree.ElementTree as ET

import numpy as np
from shapely.geometry import Polygon


ROOT = Path(__file__).resolve().parents[2]
ASSETS = ROOT / 'packages/app_ui/assets/maps/pulse'
EARTH_RADIUS = 6378137.0


def project(longitude, latitude):
    return np.array([EARTH_RADIUS * math.radians(longitude),
                     EARTH_RADIUS * math.log(math.tan(math.pi / 4 + math.radians(latitude) / 2))])


def unproject(point):
    return [math.degrees(2 * math.atan(math.exp(point[1] / EARTH_RADIUS)) - math.pi / 2),
            math.degrees(point[0] / EARTH_RADIUS)]


def load_osm(path):
    if path.suffix == '.json':
        return json.loads(path.read_text(encoding='utf-8'))['elements']
    root = ET.parse(path).getroot()
    nodes = {node.attrib['id']: {'lat': float(node.attrib['lat']), 'lon': float(node.attrib['lon'])}
             for node in root.findall('node')}
    elements = []
    for element in root:
        if element.tag not in ('node', 'way', 'relation'):
            continue
        tags = {tag.attrib['k']: tag.attrib['v'] for tag in element.findall('tag')}
        if not tags:
            continue
        item = {'id': int(element.attrib['id']), 'type': element.tag, 'tags': tags}
        if element.tag == 'way':
            item['geometry'] = [nodes[node.attrib['ref']] for node in element.findall('nd')
                                if node.attrib['ref'] in nodes]
        if element.tag == 'node':
            item.update(nodes[element.attrib['id']])
        elements.append(item)
    return elements


def ref_key(value):
    value = str(value).upper().translate(str.maketrans('ABCEHKMOPTXY', 'АВСЕНКМОРТХУ'))
    return re.sub(r'[\s._–—-]+', '', value)


def feature_polygon(element):
    points = [project(point['lon'], point['lat']) for point in element.get('geometry', [])]
    if len(points) < 4:
        return None
    polygon = Polygon(points)
    if not polygon.is_valid:
        polygon = polygon.buffer(0)
    return polygon if not polygon.is_empty else None


def room_pairs(campus, elements):
    floors = {floor['id']: floor['level'] for floor in campus['floors']}
    source = defaultdict(list)
    geographic = defaultdict(list)
    for room in campus['rooms']:
        source[(floors[room['floor_id']], ref_key(room['label']))].append(room)
    for element in elements:
        tags = element.get('tags', {})
        if tags.get('indoor') != 'room' or not tags.get('ref'):
            continue
        level = tags.get('level:ref', tags.get('level', ''))
        if not re.fullmatch(r'-?\d+', level):
            continue
        polygon = feature_polygon(element)
        if polygon is None:
            continue
        geographic[(int(level), ref_key(tags['ref']))].append((element, polygon))
    pairs = []
    for key, rooms in source.items():
        matches = geographic.get(key, [])
        if len(rooms) != 1 or len(matches) != 1:
            continue
        room = rooms[0]
        element, polygon = matches[0]
        pairs.append({'room_id': room['id'], 'floor_id': room['floor_id'], 'label': room['label'],
                      'source': [room['x'], room['y']],
                      'osm_type': element['type'], 'osm_id': element['id'],
                      'target': [polygon.centroid.x, polygon.centroid.y]})
    return pairs


def robust_affine(pairs, latitude, threshold_meters=8):
    if len(pairs) < 6:
        raise ValueError('At least six independent room matches are required')
    source = np.array([pair['source'] for pair in pairs])
    target = np.array([pair['target'] for pair in pairs])
    origin = target.mean(axis=0)
    target -= origin
    design = np.column_stack([source, np.ones(len(source))])
    ground = math.cos(math.radians(latitude))
    generator = np.random.default_rng(20260907)
    best = None
    for _ in range(4000):
        indices = generator.choice(len(source), 3, replace=False)
        if abs(np.linalg.det(design[indices])) < 1:
            continue
        model = np.linalg.solve(design[indices], target[indices])
        errors = np.linalg.norm(design @ model - target, axis=1) * ground
        inliers = errors <= threshold_meters
        score = (int(inliers.sum()), -float(np.median(errors[inliers])))
        if best is None or score > best[0]:
            best = score, inliers, model
    if best is None or best[0][0] < 6:
        raise ValueError('No stable affine consensus')
    inliers = best[1]
    for _ in range(5):
        model = np.linalg.lstsq(design[inliers], target[inliers], rcond=None)[0]
        errors = np.linalg.norm(design @ model - target, axis=1) * ground
        updated = errors <= threshold_meters
        if np.array_equal(updated, inliers):
            break
        inliers = updated
    model[2] += origin
    singular = np.linalg.svd(model[:2], compute_uv=False) * ground
    return model, inliers, errors, singular


def write_preview(campus, model, elements, workdir, floor=None, excluded_regions=()):
    floor = floor or next(floor for floor in campus['floors'] if floor['level'] == 1)
    corners = np.array([[0, 0, 1], [floor['width'], 0, 1],
                        [0, floor['height'], 1], [floor['width'], floor['height'], 1]]) @ model
    minimum = corners.min(axis=0)
    maximum = corners.max(axis=0)
    width, height = maximum - minimum
    root = ET.fromstring(floor['svg'])
    children = []
    for child in root:
        if child.tag.split('}')[-1] == 'rect' and child.attrib.get('width') == str(floor['width']):
            continue
        children.append(ET.tostring(child, encoding='unicode'))
    transform = f'matrix({model[0,0]} {-model[0,1]} {model[1,0]} {-model[1,1]} {model[2,0]-minimum[0]} {maximum[1]-model[2,1]})'
    clip = f'M0 0H{floor["width"]}V{floor["height"]}H0Z'
    for region in excluded_regions:
        x, y, w, h = (region[key] for key in ('x', 'y', 'width', 'height'))
        clip += f'M{x} {y}h{w}v{h}h{-w}Z'
    svg = f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}"><style>path,rect,line,polygon,polyline,circle,ellipse{{stroke:#005bd8!important;stroke-width:1!important;fill:none!important;vector-effect:non-scaling-stroke}}[data-object] path,[data-object] rect{{fill:#2389e533!important}}text{{display:none}}</style><defs><clipPath id="geographic-clip"><path d="{clip}" clip-rule="evenodd"/></clipPath></defs><g transform="{transform}"><g clip-path="url(#geographic-clip)">'
    svg += ''.join(children) + '</g></g></svg>'
    svg_path = workdir / f'overlay-{campus["id"]}.svg'
    svg_path.write_text(svg, encoding='utf-8')
    return {'id': campus['id'], 'title': campus['title'], 'svg': svg_path.name,
            'bounds': [unproject(minimum), unproject(maximum)],
            'center': unproject((minimum + maximum) / 2)}


def write_preview_page(previews, workdir):
    html = '''<!doctype html><html lang="ru"><meta charset="utf-8"><title>Проверка привязки кампусов</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
<style>html,body{margin:0;height:100%;font:14px system-ui}#map{height:100%}#tools{position:absolute;z-index:1000;top:12px;left:64px;padding:10px;background:white;border-radius:8px;box-shadow:0 1px 8px #0003}select,input{font:inherit;vertical-align:middle}</style>
<div id="map"></div><div id="tools"><select id="campus"></select> <label>План <input id="opacity" type="range" min="0" max="1" step=".05" value=".75"></label><div>Примерная привязка · синий: исходный план · подложка: OpenStreetMap</div></div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script><script>
const plans=PREVIEWS;const map=L.map('map');L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:20,attribution:'© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a> · Планы: <a href="https://pulse.mirea.ru/services/maps">Пульс МИРЭА</a>'}).addTo(map);
let layer;async function show(id){const plan=plans.find(p=>p.id===id);if(layer)map.removeLayer(layer);const xml=await fetch(plan.svg).then(r=>r.text());const svg=new DOMParser().parseFromString(xml,'image/svg+xml').documentElement;layer=L.svgOverlay(svg,plan.bounds,{opacity:Number(document.getElementById('opacity').value),interactive:false}).addTo(map);map.fitBounds(plan.bounds,{padding:[40,40]});window.activePlan=id;}
for(const p of plans){const opt=document.createElement('option');opt.value=p.id;opt.textContent=p.title;campus.append(opt)}campus.onchange=()=>show(campus.value);opacity.oninput=()=>layer?.setOpacity(Number(opacity.value));show(plans[0].id);window.georefMap=map;
</script></html>'''.replace('PREVIEWS', json.dumps(previews, ensure_ascii=False))
    (workdir / 'index.html').write_text(html, encoding='utf-8')


def floor_anchors(floor, model):
    return [dict(x=x, y=y, latitude=unproject(np.array([x, y, 1]) @ model)[0],
                 longitude=unproject(np.array([x, y, 1]) @ model)[1])
            for x, y in ((0, 0), (floor['width'], 0), (0, floor['height']))]


def model_from_anchors(anchors):
    return np.linalg.solve(np.array([[a['x'], a['y'], 1] for a in anchors[:3]]),
                           np.array([project(a['longitude'], a['latitude']) for a in anchors[:3]]))


def floor_fingerprint(floor):
    payload = {key: value for key, value in floor.items() if key not in ('anchors', 'georeference')}
    return hashlib.sha256(json.dumps(payload, ensure_ascii=False, sort_keys=True,
                                     separators=(',', ':')).encode('utf-8')).hexdigest()


def room_registration(campus, report):
    errors = np.array([pair['residual_meters'] for pair in report['pairs']])
    stats = {'kind': 'matched_room_centers', 'count': len(errors),
             'consensus_count': report['inliers'],
             'median_meters': float(np.median(errors)),
             'p95_meters': float(np.quantile(errors, .95)),
             'max_meters': float(max(errors)), 'geodetic_accuracy_meters': None}
    summary = (f'Совмещено по {len(errors)} одноимённым помещениям OpenStreetMap. '
               f'Медианное расхождение {stats["median_meters"]:.1f} м; '
               f'95% сопоставлений — до {stats["p95_meters"]:.1f} м.')
    limitations = ['Расхождение с OSM не является геодезической точностью. Привязка не измерена на местности.']
    if campus['id'] == 'v-78':
        limitations.append('В библиотеке и части северных корпусов старые контуры OSM расходятся с актуальным планом. Единая привязка этажа не устраняет эти искажения.')
    return {'campus_id': campus['id'], 'method': 'room_reference_robust_affine',
            'summary': summary, 'limitations': limitations, 'residuals': stats,
            'sources': [{'label': 'OpenStreetMap: помещения',
                         'url': f'https://www.openstreetmap.org/#map=19/{campus["latitude"]}/{campus["longitude"]}'},
                        {'label': 'История картирования МИРЭА',
                         'url': 'https://community.openstreetmap.org/t/topic/118432'}],
            'osm_sha256': report['osm_sha256'],
            'floors': [{'floor_id': floor['id'], 'anchors': floor_anchors(floor, np.array(report['matrix'])),
                        'floor_geometry_sha256': floor_fingerprint(floor)}
                       for floor in campus['floors']], 'control_pairs': report['pairs']}


def footprint_registration(fitted):
    campus = json.loads((ASSETS / f'campus_{fitted["campus_id"]}.json').read_text(encoding='utf-8'))
    stats = fitted['reference_fit']
    boundary = stats['symmetric_boundary_residual_m']
    summary = (f'Совмещено по внешнему контуру здания OpenStreetMap. '
               f'Совпадение площадей {stats["iou"] * 100:.0f}%; '
               f'медианное расхождение границ {boundary["median"]:.1f} м.')
    limitations = ['Остаток совмещения контуров не является геодезической точностью. Опорные точки на местности не измерены.',
                   'Остальные этажи наследуют общую систему координат исходного плана; отдельно с городской картой они не сверялись.']
    if fitted['campus_id'] == 'v-86':
        limitations.extend(['Привязан основной корпус. Отдельный блок с неподтверждённым положением скрыт только на городской карте.',
                            'Северная оконечность крыла расходится с OSM примерно на 20 м.'])
    floors = []
    for floor in campus['floors']:
        fit = next(row for row in fitted['floors'] if row['floor_id'] == floor['id'])
        result = {'floor_id': floor['id'], 'anchors': fit['anchors'][:3],
                  'floor_geometry_sha256': floor_fingerprint(floor)}
        if fitted['campus_id'] == 'v-86':
            box = fitted['excluded_native_bounds_m']
            min_x, min_y, _, _ = map(float, floor['source_view_box'].split())
            scale = floor['source_coordinate_scale']
            margin = 1.0
            result['excluded_regions'] = [{
                'x': (box[0] * 100 - min_x) * scale - margin,
                'y': (box[1] * 100 - min_y) * scale - margin,
                'width': (box[2] - box[0]) * 100 * scale + margin * 2,
                'height': (box[3] - box[1]) * 100 * scale + margin * 2,
            }]
        floors.append(result)
    return {'campus_id': fitted['campus_id'], 'method': 'building_footprint_affine',
            'summary': summary, 'limitations': limitations,
            'residuals': {'kind': 'symmetric_building_boundary', 'iou': stats['iou'],
                          'median_meters': boundary['median'], 'p95_meters': boundary['p95'],
                          'max_meters': boundary['max'], 'geodetic_accuracy_meters': None},
            'sources': [{'label': 'OpenStreetMap: контур здания', 'url': fitted['osm']['source_url']}],
            'osm_sha256': fitted['osm']['snapshot_sha256'], 'floors': floors,
            'control_pairs': fitted['boundary_correspondences']}


def apply_registrations(registrations):
    if len(registrations) != 4 or {row['campus_id'] for row in registrations} != {'v-78', 'v-86', 's-20', 'mp-1'}:
        raise ValueError('Exactly one registration for each of the four campuses is required')
    provenance_path = ASSETS / 'provenance.json'
    provenance = json.loads(provenance_path.read_text(encoding='utf-8'))
    pending = []
    for registration in registrations:
        path = ASSETS / f'campus_{registration["campus_id"]}.json'
        campus = json.loads(path.read_text(encoding='utf-8'))
        unchanged = json.loads(json.dumps(campus))
        floors = {floor['floor_id']: floor for floor in registration['floors']}
        for floor in campus['floors']:
            fitted = floors[floor['id']]
            if fitted['floor_geometry_sha256'] != floor_fingerprint(floor):
                raise ValueError(f'Floor geometry changed since registration: {floor["id"]}')
            floor['anchors'] = fitted['anchors'][:3]
            floor['georeference'] = {
                'status': 'approximate', 'method': registration['method'],
                'checked_at': '2026-09-07T00:00:00Z',
                'summary': registration['summary'],
                'limitations': registration['limitations'],
                'sources': [*registration['sources'],
                            {'label': ('Планы University App · МП-1' if campus['id'] == 'mp-1'
                                       else 'Планы: Пульс МИРЭА'), 'url': campus['source_url']}],
                'residuals': registration['residuals'],
                'osm_sha256': registration['osm_sha256'],
                'anchor_kind': 'affine_model_control_not_surveyed',
                'excluded_regions': fitted.get('excluded_regions', []),
            }
        for before, after in zip(unchanged['floors'], campus['floors']):
            for key in ('anchors', 'georeference'):
                before.pop(key, None)
            check = {key: value for key, value in after.items() if key not in ('anchors', 'georeference')}
            if before != check:
                raise ValueError('Georeferencing must not alter floor geometry or navigation scale')
        if {key: value for key, value in unchanged.items() if key != 'floors'} != {
                key: value for key, value in campus.items() if key != 'floors'}:
            raise ValueError('Georeferencing must not alter other campus metadata or graph')
        payload = json.dumps(campus, ensure_ascii=False, separators=(',', ':')) + '\n'
        encoded = payload.encode('utf-8')
        pending.append((path, encoded))
        record = next(row for row in provenance['campuses'] if row['id'] == campus['id'])
        record['sha256'] = hashlib.sha256(encoded).hexdigest()
        record['georeference'] = {'status': 'approximate', 'checked_at': '2026-09-07',
                                  'evidence': 'scripts/map/source/georeference_registration.json'}
    for path, encoded in pending:
        path.write_bytes(encoded)
    payload = json.dumps(provenance, ensure_ascii=False, indent=2) + '\n'
    provenance_path.write_bytes(payload.encode('utf-8'))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--workdir', type=Path, default=ROOT / 'output/campus-map/georeference')
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--apply-evidence', type=Path)
    args = parser.parse_args()
    if args.apply_evidence:
        evidence = json.loads(args.apply_evidence.read_text(encoding='utf-8'))
        apply_registrations(evidence['campuses'])
        return evidence['campuses']
    reports = []
    previews = []
    registrations = []
    for campus_id in ('v-78', 'mp-1', 'v-86', 's-20'):
        campus = json.loads((ASSETS / f'campus_{campus_id}.json').read_text(encoding='utf-8'))
        path = args.workdir / f'osm-{campus_id}.json'
        if not path.exists():
            path = path.with_suffix('.osm')
        elements = load_osm(path)
        pairs = room_pairs(campus, elements)
        report = {'campus_id': campus_id, 'matched_rooms': len(pairs), 'osm_sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
        if len(pairs) >= 6:
            model, inliers, errors, singular = robust_affine(pairs, campus['latitude'])
            report.update({'matrix': model.tolist(), 'inliers': int(inliers.sum()),
                           'median_residual_meters': float(np.median(errors[inliers])),
                           'p95_residual_meters': float(np.quantile(errors[inliers], .95)),
                           'max_residual_meters': float(max(errors[inliers])),
                           'axis_scale_meters': singular.tolist(),
                           'by_floor': {floor['id']: sum(bool(ok) and pair['floor_id'] == floor['id'] for pair, ok in zip(pairs, inliers)) for floor in campus['floors']}})
            for pair, ok, error in zip(pairs, inliers, errors):
                pair.update({'inlier': bool(ok), 'residual_meters': float(error)})
            previews.append(write_preview(campus, model, elements, args.workdir))
        report['pairs'] = pairs
        (args.workdir / f'fit-{campus_id}.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print(json.dumps({key: value for key, value in report.items() if key not in ('pairs', 'matrix')}, ensure_ascii=True))
        reports.append(report)
        if 'matrix' in report:
            registrations.append(room_registration(campus, report))
    footprint_path = ROOT / 'scripts/map/source/georeference_footprint_fits.json'
    if footprint_path.exists():
        for fitted in json.loads(footprint_path.read_text(encoding='utf-8'))['campuses']:
            registration = footprint_registration(fitted)
            registrations.append(registration)
            campus = json.loads((ASSETS / f'campus_{fitted["campus_id"]}.json').read_text(encoding='utf-8'))
            floor = next(f for f in campus['floors'] if f['id'] == fitted['reference_floor_id'])
            registered_floor = next(f for f in registration['floors'] if f['floor_id'] == floor['id'])
            previews.append(write_preview(campus, model_from_anchors(registered_floor['anchors']), [], args.workdir,
                                          floor, registered_floor.get('excluded_regions', [])))
    evidence_path = ROOT / 'scripts/map/source/georeference_registration.json'
    evidence_path.write_text(json.dumps({'schema_version': 1, 'campuses': registrations},
                                        ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    if args.apply:
        if len(registrations) != 4:
            raise ValueError('All four campus registrations are required before applying')
        apply_registrations(registrations)
    write_preview_page(previews, args.workdir)
    return reports


if __name__ == '__main__':
    main()
