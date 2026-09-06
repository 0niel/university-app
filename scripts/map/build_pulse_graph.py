import math
from collections import Counter, defaultdict

from shapely import make_valid
from shapely.geometry import LineString, Point, Polygon
from shapely.ops import unary_union
from shapely.strtree import STRtree

from pulse_native_geometry import area_polygons, interior_point, sample_wall, source_meters_per_unit


PRECOMPUTED_VERSION = "3|10|40000|25|16|120|70|-0.866|12|25|45|40|1000000"
TOLERANCE = 0.15


def _point(value):
    return float(value["x"]), -float(value["y"])


def _line_points(layer, line):
    return [_point(layer["vertices"][key]) for key in line["vertices"][:2]]


def _wall_thickness(line):
    value = line.get("properties", {}).get("thickness", {}).get("length", 5)
    if not isinstance(value, (int, float)) or not math.isfinite(value) or value < 0:
        raise ValueError("Invalid source wall thickness")
    return max(float(value), 0.01)


class FloorGeometry:
    def __init__(self, layer):
        self.areas = area_polygons(layer)
        self.polygons = {
            key: make_valid(Polygon(area["polygon"], area["holes"]))
            for key, area in self.areas.items()
        }
        self.coverage = {key: polygon.buffer(TOLERANCE) for key, polygon in self.polygons.items()}
        self.doors = {}
        openings = defaultdict(list)
        for key, door in layer.get("holes", {}).items():
            line = layer["lines"].get(door["line"])
            if line is None:
                continue
            start, end = _line_points(layer, line)
            offset = door.get("offset", 0.5)
            position = tuple(a + (b - a) * offset for a, b in zip(start, end))
            width = door.get("properties", {}).get("width", {}).get("length", 80)
            if not isinstance(width, (int, float)) or not math.isfinite(width) or width <= 0:
                raise ValueError("Invalid source doorway width")
            closed = bool(door.get("properties", {}).get("closed"))
            angle = math.atan2(end[1] - start[1], end[0] - start[0])
            thickness = _wall_thickness(line)
            self.doors[key] = {
                "point": position, "width": width, "closed": closed,
                "angle": angle, "wall_thickness": thickness,
            }
            if not closed:
                along, normal = (math.cos(angle), math.sin(angle)), (-math.sin(angle), math.cos(angle))
                corners = [tuple(position[i] + direction * along[i] * width / 2
                                  + side * normal[i] * (thickness / 2 + TOLERANCE)
                                  for i in (0, 1))
                           for direction, side in ((-1, -1), (1, -1), (1, 1), (-1, 1))]
                openings[door["line"]].append(Polygon(corners))
        walls = []
        for key, line in layer["lines"].items():
            points = sample_wall(layer, line)
            if len(set(points)) < 2:
                continue
            geometry = LineString(points).buffer(_wall_thickness(line) / 2, cap_style="flat")
            if openings[key]:
                geometry = geometry.difference(unary_union(openings[key]))
            if not geometry.is_empty:
                walls.append(geometry)
        self.walls = walls
        self.wall_tree = STRtree(walls)

    def clear(self, start, end, area_id=None):
        path = Point(start) if start == end else LineString([start, end])
        if area_id is not None and not self.coverage[area_id].covers(path):
            return False
        return len(self.wall_tree.query(path, predicate="intersects")) == 0

    def sides(self, first, second, point, angle, reach=25):
        normal = -math.sin(angle), math.cos(angle)
        candidates = [tuple(point[i] + sign * normal[i] * reach for i in (0, 1)) for sign in (1, -1)]
        for a, b in (candidates, candidates[::-1]):
            if self.coverage[first].covers(Point(a)) and self.coverage[second].covers(Point(b)):
                return a, b
        return None

    def opening(self, row):
        first, second, x, y, angle, width, gap = row
        direction = math.cos(angle), math.sin(angle)
        count = max(1, math.ceil(width / 10))
        runs, run = [], []
        for index in range(count + 1):
            along = width * (index / count - 0.5)
            position = x + direction[0] * along, y + direction[1] * along
            sides = self.sides(first, second, position, angle, max(25, gap / 2 + 10))
            if sides is not None and self.clear(*sides):
                run.append((along, position, sides))
            else:
                if run:
                    runs.append(run)
                run = []
        if run:
            runs.append(run)
        if not runs:
            return None
        longest = max(runs, key=lambda values: values[-1][0] - values[0][0])
        if longest[-1][0] - longest[0][0] < 40:
            return None
        return longest[len(longest) // 2][2]


def build_graph(plan, campus_id, floor_mappings, room_mappings):
    precomputed = plan.get("meta", {}).get("precomputed", {})
    if precomputed.get("version") != PRECOMPUTED_VERSION:
        raise ValueError("Unsupported Pulse navigation precomputation version")
    meters = source_meters_per_unit(plan)
    stats = Counter()
    nodes, edges, points, area_nodes, anchors = {}, [], {}, defaultdict(list), {}
    geometries, edge_pairs, connectors = {}, set(), defaultdict(list)

    def node(layer_id, area_id, suffix, position, *, room=False, kind=None, label=None):
        key = f"{campus_id}:{layer_id}:{area_id}:{suffix}"
        mapping = floor_mappings[layer_id]
        value = {"id": key, "floor_id": mapping["id"],
                 "x": round((position[0] - mapping["min_x"]) * mapping["scale"], 6),
                 "y": round((position[1] - mapping["min_y"]) * mapping["scale"], 6)}
        if room and (room_id := room_mappings.get((layer_id, area_id))):
            value["room_id"] = room_id
        if label:
            value["label"] = label
        if kind:
            value["kind"] = kind
        nodes[key] = value
        points[key] = tuple(position)
        area_nodes[(layer_id, area_id)].append(key)
        return key

    def edge(first, second, kind="corridor", *, transition_cost=None, closed=False, source=None):
        pair = tuple(sorted((first, second)))
        if first == second or pair in edge_pairs:
            return
        edge_pairs.add(pair)
        value = {"id": f"{campus_id}:edge:{len(edges)}", "from_node_id": first,
                 "to_node_id": second, "kind": kind, "bidirectional": True}
        if transition_cost is None:
            value["distance_meters"] = round(math.dist(points[first], points[second]) * meters, 6)
        else:
            value["traversal_cost"] = transition_cost
        if closed:
            value["closed"] = True
        if source:
            value["source_id"] = source
        edges.append(value)

    def attach(layer_id, area_id, key):
        geometry = geometries[layer_id]
        candidates = sorted(area_nodes[(layer_id, area_id)], key=lambda other: math.dist(points[key], points[other]))
        attached = 0
        for other in candidates:
            if other == key:
                continue
            if geometry.clear(points[key], points[other], area_id):
                edge(key, other)
                attached += 1
                if attached == 8:
                    break
        if attached == 0:
            stats["unattached_points"] += 1

    for layer_id, layer in plan["layers"].items():
        geometry = FloorGeometry(layer)
        geometries[layer_id] = geometry
        for area_id, area in geometry.areas.items():
            cached = precomputed.get("rooms", {}).get(area_id, {})
            flat = cached.get("n", [])
            source_nodes = {}
            for index in range(0, len(flat), 2):
                position = tuple(flat[index:index + 2])
                if not geometry.coverage[area_id].covers(Point(position)):
                    stats["rejected_source_nodes"] += 1
                    continue
                source_nodes[index // 2] = node(layer_id, area_id, f"n{index // 2}", position)
            source_edges = cached.get("e", [])
            for index in range(0, len(source_edges), 2):
                a, b = (source_nodes.get(value) for value in source_edges[index:index + 2])
                if a is not None and b is not None and geometry.clear(points[a], points[b], area_id):
                    edge(a, b)
                    stats["source_skeleton_edges"] += 1
                else:
                    stats["rejected_source_edges"] += 1
            anchor_position = interior_point(area, cached)
            anchor = node(layer_id, area_id, "anchor", anchor_position, room=True, label=area["label"])
            anchors[(layer_id, area_id)] = anchor
            attach(layer_id, area_id, anchor)
        floor_cache = precomputed.get("floors", {}).get(layer_id, {})
        for first, second, door_id in floor_cache.get("d", []):
            door = geometry.doors.get(door_id)
            if door is None or first not in geometry.areas or second not in geometry.areas:
                stats["missing_doors"] += 1
                continue
            if door["closed"]:
                stats["closed_doors_excluded"] += 1
                continue
            sides = geometry.sides(first, second, door["point"], door["angle"], max(25, door["wall_thickness"] / 2 + 5))
            if sides is None or not geometry.clear(*sides):
                stats["unverified_doors"] += 1
                continue
            a = node(layer_id, first, f"door:{door_id}", sides[0], kind="door")
            b = node(layer_id, second, f"door:{door_id}", sides[1], kind="door")
            edge(a, b, "door", source=door_id)
            connectors[(layer_id, first)].append(a)
            connectors[(layer_id, second)].append(b)
            stats["doors"] += 1
        for index, row in enumerate(floor_cache.get("w", [])):
            first, second = row[:2]
            if first not in geometry.areas or second not in geometry.areas:
                continue
            sides = geometry.opening(row)
            if sides is None:
                stats["blocked_boundaries_excluded"] += 1
                continue
            a = node(layer_id, first, f"opening:{index}", sides[0], kind="passage")
            b = node(layer_id, second, f"opening:{index}", sides[1], kind="passage")
            edge(a, b, source=f"opening:{first}:{second}")
            connectors[(layer_id, first)].append(a)
            connectors[(layer_id, second)].append(b)
            stats["verified_openings"] += 1

    building = plan.get("meta", {}).get("building", {})
    declarations = {item["id"]: item for item in building.get("transitions", []) + building.get("connectors", [])}
    portals = defaultdict(dict)
    for layer_id, layer in plan["layers"].items():
        geometry = geometries[layer_id]
        for item_id, item in layer.get("items", {}).items():
            properties = item.get("properties", {})
            transition_id = properties.get("transitionId") or properties.get("connectorId")
            if not item.get("type", "").endswith("-portal") or transition_id not in declarations:
                continue
            endpoint = properties.get("endpoint", "from")
            declaration = declarations[transition_id]
            if endpoint not in ("from", "to") or declaration.get(f"{endpoint}Layer") != layer_id:
                stats["invalid_portal_endpoints"] += 1
                continue
            position = _point(item)
            candidates = [key for key, polygon in geometry.coverage.items() if polygon.covers(Point(position))]
            if not candidates:
                stats["unmapped_portals"] += 1
                continue
            area_id = min(candidates, key=lambda key: geometry.polygons[key].area)
            kind = declaration.get("kind", "stairs")
            if kind not in ("stairs", "elevator", "ramp", "escalator"):
                raise ValueError(f"Unknown portal kind {kind}")
            key = node(layer_id, area_id, f"portal:{item_id}", position, kind=kind)
            connectors[(layer_id, area_id)].append(key)
            portals[transition_id][endpoint] = key
    for transition_id, endpoints in portals.items():
        if set(endpoints) != {"from", "to"}:
            stats["incomplete_transitions"] += 1
            continue
        declaration = declarations[transition_id]
        first, second = endpoints["from"], endpoints["to"]
        delta = abs(floor_mappings[declaration["fromLayer"]]["level"] - floor_mappings[declaration["toLayer"]]["level"])
        edge(first, second, declaration.get("kind", "stairs"), transition_cost=20 * max(1, delta), source=transition_id)
        stats["floor_transitions"] += 1
    for (layer_id, area_id), keys in connectors.items():
        for key in keys:
            attach(layer_id, area_id, key)
        for index, first in enumerate(keys):
            for second in keys[index + 1:]:
                if geometries[layer_id].clear(points[first], points[second], area_id):
                    edge(first, second)

    adjacency = defaultdict(set)
    for value in edges:
        adjacency[value["from_node_id"]].add(value["to_node_id"])
        adjacency[value["to_node_id"]].add(value["from_node_id"])
    seen, components = set(), []
    for key in nodes:
        if key in seen:
            continue
        pending, component = [key], []
        seen.add(key)
        while pending:
            current = pending.pop()
            component.append(current)
            for other in adjacency[current] - seen:
                seen.add(other)
                pending.append(other)
        components.append(component)
    stats["nodes"] = len(nodes)
    stats["edges"] = len(edges)
    stats["components"] = len(components)
    stats["largest_component_nodes"] = max(map(len, components), default=0)
    stats["named_room_anchors"] = sum("room_id" in value for value in nodes.values())
    stats["isolated_named_rooms"] = sum("room_id" in nodes[key] and not adjacency[key] for key in nodes)
    return {"nodes": list(nodes.values()), "edges": edges}, dict(stats)
