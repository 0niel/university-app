import math
import re


def display_level(descriptor):
    for value in (descriptor.get("shortTitle"), descriptor.get("title")):
        if value is None:
            continue
        match = re.fullmatch(r"(?:Этаж\s+)?(-?\d+)", str(value).strip(), re.IGNORECASE)
        if match:
            return int(match[1])
    raise ValueError(f"Floor needs an explicit numeric display label: {descriptor}")


def source_meters_per_unit(plan):
    explicit = plan.get("meta", {}).get("metersPerUnit")
    if isinstance(explicit, (float, int)) and math.isfinite(explicit) and explicit > 0:
        return float(explicit)
    units = {"mm": 0.001, "cm": 0.01, "m": 1.0}
    unit = plan.get("unit")
    if unit not in units:
        raise ValueError(f"Unknown source metric unit: {unit}")
    return units[unit]


def _controls(layer, start_id, end_id, properties):
    start, end = layer["vertices"][start_id], layer["vertices"][end_id]
    reverse = (start["x"], start["y"]) > (end["x"], end["y"])
    left, right = (end, start) if reverse else (start, end)
    length = math.hypot(right["x"] - left["x"], right["y"] - left["y"]) or 1
    dx, dy = (right["x"] - left["x"]) / length, (right["y"] - left["y"]) / length

    def point(x, y):
        return left["x"] + dx * x - dy * y, -(left["y"] + dy * x + dx * y)

    near = max(20, min(100, length / 3))
    far = max(length - near, near)
    first = point(properties.get("bezierX1") or near, properties.get("bezierY1", 0))
    if properties.get("bezierX2", 0) == 0 and properties.get("bezierY2", 0) == 0:
        second = point(far, 0)
    else:
        second = point(properties.get("bezierX2") or far, properties.get("bezierY2", 0))
    return (second, first) if reverse else (first, second)


def area_polygons(layer):
    vertices = {key: (float(value["x"]), -float(value["y"])) for key, value in layer["vertices"].items()}
    curves = {}
    for line in layer["lines"].values():
        start, end = line["vertices"][:2]
        if line["properties"].get("isBezier"):
            curves[(start, end)] = _controls(layer, start, end, line["properties"])

    def polygon(area):
        ids = area["vertices"]
        if len(ids) < 3:
            raise ValueError("Native area has fewer than three vertices")
        points = [vertices[ids[0]]]
        for index, start_id in enumerate(ids):
            end_id = ids[(index + 1) % len(ids)]
            start, end = vertices[start_id], vertices[end_id]
            controls = curves.get((start_id, end_id))
            if controls is None and (end_id, start_id) in curves:
                controls = tuple(reversed(curves[(end_id, start_id)]))
            if controls is None:
                points.append(end)
                continue
            first, second = controls
            count = max(12, math.ceil(math.dist(start, end) / 25))
            for step in range(1, count + 1):
                t = step / count
                points.append(tuple(
                    (1 - t) ** 3 * start[axis] + 3 * (1 - t) ** 2 * t * first[axis]
                    + 3 * (1 - t) * t ** 2 * second[axis] + t ** 3 * end[axis]
                    for axis in (0, 1)
                ))
        return points[:-1]

    result = {}
    for area_id, area in layer["areas"].items():
        properties = area.get("properties", {})
        if properties.get("void") or properties.get("isVoid"):
            continue
        result[area_id] = {
            "id": area_id, "label": properties.get("name", "").strip(),
            "db_id": properties.get("dbId"), "polygon": polygon(area),
            "holes": [polygon(layer["areas"][key]) for key in area.get("holes", [])],
        }
    return result


def sample_wall(layer, line):
    start_id, end_id = line["vertices"][:2]
    start = (float(layer["vertices"][start_id]["x"]), -float(layer["vertices"][start_id]["y"]))
    end = (float(layer["vertices"][end_id]["x"]), -float(layer["vertices"][end_id]["y"]))
    if not line.get("properties", {}).get("isBezier"):
        return [start, end]
    first, second = _controls(layer, start_id, end_id, line["properties"])
    count = max(12, math.ceil(math.dist(start, end) / 25))
    result = [start]
    for step in range(1, count + 1):
        t = step / count
        result.append(tuple(
            (1 - t) ** 3 * start[axis] + 3 * (1 - t) ** 2 * t * first[axis]
            + 3 * (1 - t) * t ** 2 * second[axis] + t ** 3 * end[axis]
            for axis in (0, 1)
        ))
    return result


def bounding_box(points):
    return min(x for x, _ in points), min(y for _, y in points), max(x for x, _ in points), max(y for _, y in points)


def geometry_signature(points):
    return tuple(sorted(set((round(x, 1), round(y, 1)) for x, y in points)))


def same_geometry(left, right, tolerance=0.11):
    if any(abs(a - b) > tolerance for a, b in zip(bounding_box(left), bounding_box(right))):
        return False
    if geometry_signature(left) == geometry_signature(right):
        return True
    return all(min(math.dist(point, other) for other in right) <= tolerance for point in left) and all(
        min(math.dist(point, other) for other in left) <= tolerance for point in right
    )


def inside_ring(point, polygon):
    x, y = point
    inside = False
    previous = polygon[-1]
    for current in polygon:
        if (current[1] > y) != (previous[1] > y):
            crossing = (previous[0] - current[0]) * (y - current[1]) / (previous[1] - current[1]) + current[0]
            if x < crossing:
                inside = not inside
        previous = current
    return inside


def inside_area(point, area):
    return inside_ring(point, area["polygon"]) and not any(inside_ring(point, hole) for hole in area["holes"])


def interior_point(area, precomputed=None):
    candidate = precomputed.get("c", [])[:2] if precomputed else []
    if len(candidate) == 2 and inside_area(candidate, area):
        return tuple(candidate)
    min_x, min_y, max_x, max_y = bounding_box(area["polygon"])
    candidate = ((min_x + max_x) / 2, (min_y + max_y) / 2)
    if inside_area(candidate, area):
        return candidate
    for divisions in (16, 64, 256):
        for row in range(divisions):
            for column in range(divisions):
                candidate = (min_x + (column + 0.5) / divisions * (max_x - min_x), min_y + (row + 0.5) / divisions * (max_y - min_y))
                if inside_area(candidate, area):
                    return candidate
    raise ValueError(f"Cannot find interior point for native area {area['id']}")
