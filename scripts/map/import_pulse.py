import argparse
from collections import Counter
import hashlib
import importlib.util
import json
from pathlib import Path
import re
from urllib.parse import parse_qs, urlparse
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "scripts/map/source"
OUTPUT = ROOT / "packages/app_ui/assets/maps/pulse"
_GEOMETRY_SPEC = importlib.util.spec_from_file_location("pulse_native_geometry", Path(__file__).with_name("pulse_native_geometry.py"))
_GEOMETRY = importlib.util.module_from_spec(_GEOMETRY_SPEC)
_GEOMETRY_SPEC.loader.exec_module(_GEOMETRY)
_LOCATIONS_SPEC = importlib.util.spec_from_file_location("campus_locations", Path(__file__).with_name("campus_locations.py"))
_LOCATIONS = importlib.util.module_from_spec(_LOCATIONS_SPEC)
_LOCATIONS_SPEC.loader.exec_module(_LOCATIONS)
CAMPUSES = {
    "v-78": ("Вернадского 78", "В-78", "Москва, проспект Вернадского, 78", range(5)),
    "v-86": ("Вернадского 86", "В-86", "Москва, проспект Вернадского, 86", range(8)),
    "s-20": ("Стромынка 20", "С-20", "Москва, улица Стромынка, 20", range(1, 5)),
}
NUMBER = r"-?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?"
PAIR = re.compile(rf"({NUMBER})\s*,\s*({NUMBER})")
PALETTE = {
    "#141414": "#F4F7FC",
    "rgb(29, 29, 29)": "#E0E7F0",
    "rgb(126, 126, 126)": "#7D8DA6",
    "#ffffff": "#25344D",
    "#fff": "#25344D",
    "white": "#25344D",
}


def sha(value):
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def kind_for(label):
    normalized = label.casefold()
    for terms, kind in (
        (("туалет", "санузел"), "toilet"),
        (("столов", "буфет", "кафе"), "cafeteria"),
        (("банкомат",), "atm"),
        (("медпункт",), "medical"),
        (("библиот", "читальный"), "library"),
        (("вход",), "entrance"),
        (("гардероб",), "cloakroom"),
        (("лифт",), "elevator"),
        (("лестниц",), "stairs"),
    ):
        if any(term in normalized for term in terms):
            return kind
    return "room"


def canonicalize(campus, level, record):
    expected_name = CAMPUSES[campus][0]
    if record.get("visible_campus") != expected_name:
        raise ValueError(f"{campus}/{level}: campus label does not match source")
    if record.get("visible_floor") != f"Этаж {level}":
        raise ValueError(f"{campus}/{level}: visible floor does not match")
    parsed = urlparse(record["url"])
    if parsed.scheme != "https" or parsed.netloc != "pulse.mirea.ru" or parsed.path != "/services/maps":
        raise ValueError("Unexpected source URL")
    source_id = parse_qs(parsed.query)["campus"][0]
    source_url = f"https://pulse.mirea.ru/services/maps?campus={source_id}"
    raw_svg = record["svg"]
    if "[Truncated]" in raw_svg or ("svg_length" in record and len(raw_svg) != record["svg_length"]):
        raise ValueError("Truncated source SVG")
    original = ET.fromstring(raw_svg)
    if original.tag != "svg":
        raise ValueError("Unexpected SVG namespace or root")
    for element in original.iter():
        if element.tag not in {"svg", "g", "path", "line"}:
            raise ValueError(f"Source SVG element requires importer review: {element.tag}")
        if "transform" in element.attrib:
            raise ValueError("Source transform requires importer review")
        if element.tag == "path" and any(
            command not in "MLZ" for command in re.findall(r"[A-DF-Za-df-z]", element.attrib.get("d", ""))
        ):
            raise ValueError("Source path command requires importer review")
    min_x, min_y, width, height = map(float, original.attrib["viewBox"].split())
    if min(width, height) <= 0:
        raise ValueError("Invalid source dimensions")
    scale = 2000 / max(width, height)
    width, height = round(width * scale, 6), round(height * scale, 6)
    floor_id = f"{campus}-floor{level}"
    root = ET.Element("svg", {
        "xmlns": "http://www.w3.org/2000/svg",
        "viewBox": f"0 0 {width} {height}",
        "width": str(width), "height": str(height),
    })
    ET.SubElement(root, "title").text = f"{expected_name} · этаж {level} · Пульс РТУ МИРЭА"
    ET.SubElement(root, "desc").text = f"Источник планов: {source_url}"
    ET.SubElement(root, "rect", {"width": str(width), "height": str(height), "fill": "#F9FBFE"})
    container = ET.SubElement(root, "g", {
        "transform": f"matrix({scale:.12f} 0 0 {scale:.12f} {-min_x * scale:.12f} {-min_y * scale:.12f})"
    })
    rooms = []
    occurrences = Counter()
    for child in original:
        label = child.attrib.get("aria-label", "")
        if child.tag == "g" and child.attrib.get("role") == "button" and label.startswith("Помещение "):
            label = label.removeprefix("Помещение ").strip()
            points = [
                (float(x), float(y))
                for path in child.iter("path")
                for x, y in PAIR.findall(path.attrib.get("d", ""))
            ]
            if not points:
                raise ValueError(f"Missing room geometry: {campus}/{level}/{label}")
            normalized_label = " ".join(label.casefold().split())
            occurrences[normalized_label] += 1
            ordinal = occurrences[normalized_label]
            room_id = f"pulse-{floor_id}-{sha(normalized_label)[:12]}"
            if ordinal > 1:
                room_id += f"-{ordinal}"
            x = ((min(p[0] for p in points) + max(p[0] for p in points)) / 2 - min_x) * scale
            y = ((min(p[1] for p in points) + max(p[1] for p in points)) / 2 - min_y) * scale
            if not 0 <= x <= width + 0.001 or not 0 <= y <= height + 0.001:
                raise ValueError(f"Room outside plan: {room_id}")
            child.set("data-object", room_id)
            child.set("data-name", label)
            rooms.append({
                "id": room_id, "floor_id": floor_id, "label": label,
                "kind": kind_for(label), "x": round(x, 6), "y": round(y, 6),
                "equipment": [], "menu": [], "source_url": source_url,
                "source_id_kind": "derived_label_occurrence",
            })
        for element in child.iter():
            for attr in list(element.attrib):
                if attr in ("style", "role", "tabindex") or attr.startswith("aria-") or attr.startswith("on"):
                    del element.attrib[attr]
            for attr in ("fill", "stroke"):
                value = element.attrib.get(attr, "")
                if value.lower() in PALETTE:
                    element.set(attr, PALETTE[value.lower()])
            if "stroke-width" in element.attrib:
                element.set("stroke-width", f"{max(float(element.attrib['stroke-width']), 1.5 / scale):.9f}")
            if element.tag in ("text", "tspan"):
                element.set("fill", "#25344D")
        container.append(child)
    svg = ET.tostring(root, encoding="unicode")
    return {
        "id": floor_id, "level": level, "label": f"Этаж {level}",
        "width": width, "height": height, "svg": svg, "anchors": [],
        "source_url": source_url, "source_svg_sha256": sha(raw_svg),
        "source_view_box": original.attrib["viewBox"],
        "source_coordinate_scale": scale, "captured_at": record["captured_at"],
    }, rooms, source_id


def prepare_native_campus(campus, capture, source=SOURCE):
    if capture.get("campus") != campus:
        raise ValueError("Native capture campus does not match")
    source_url = capture["source_url"]
    parsed = urlparse(source_url)
    if parsed.scheme != "https" or parsed.netloc != "pulse.mirea.ru" or parsed.path != "/services/maps":
        raise ValueError("Unexpected native source URL")
    source_campus_id = parse_qs(parsed.query)["campus"][0]
    if source_campus_id != capture.get("source_campus_id"):
        raise ValueError("Native capture source ID does not match URL")
    plan = capture["plan"]
    meters_per_source_unit = _GEOMETRY.source_meters_per_unit(plan)
    source_plan_sha256 = sha(json.dumps(plan, ensure_ascii=False, sort_keys=True, separators=(",", ":")))
    floor_mappings, room_mappings, floors, rooms = {}, {}, [], []
    descriptors = plan["meta"]["building"]["floors"]
    levels = [_GEOMETRY.display_level(descriptor) for descriptor in descriptors]
    if len(set(levels)) != len(levels):
        raise ValueError("Duplicate display floor levels")
    for descriptor, level in sorted(zip(descriptors, levels), key=lambda pair: pair[1]):
        layer_id = descriptor["layerId"]
        layer = plan["layers"][layer_id]
        source_path = source / f"{campus}_{level}.json"
        rendered = json.loads(source_path.read_text(encoding="utf-8"))
        floor, legacy_rooms, rendered_source_id = canonicalize(campus, level, rendered)
        if rendered_source_id != source_campus_id:
            raise ValueError("Rendered floor and native plan have different campus IDs")
        native_areas = _GEOMETRY.area_polygons(layer)
        available = {area_id: area for area_id, area in native_areas.items() if area["label"]}
        if len(available) != len(legacy_rooms):
            raise ValueError(f"Native/rendered room count changed for {campus}/{level}; refresh floor capture")
        min_x, min_y, _, _ = map(float, floor["source_view_box"].split())
        scale = floor["source_coordinate_scale"]
        mapping = {
            "id": floor["id"], "min_x": min_x, "min_y": min_y,
            "scale": scale, "width": floor["width"], "height": floor["height"],
            "level": level, "meters_per_unit": meters_per_source_unit / scale,
        }
        floor_mappings[layer_id] = mapping
        floor.update({
            "source_layer_id": layer_id, "source_internal_level": descriptor.get("number"),
            "source_plan_sha256": source_plan_sha256, "source_unit": plan["unit"],
            "meters_per_unit": mapping["meters_per_unit"],
            "label": descriptor.get("title") or f"Этаж {level}",
        })
        ET.register_namespace("", "http://www.w3.org/2000/svg")
        svg = ET.fromstring(floor["svg"])
        legacy_by_id = {room["id"]: room for room in legacy_rooms}
        for element in svg.iter():
            legacy_id = element.attrib.get("data-object")
            if legacy_id is None:
                continue
            previous = legacy_by_id[legacy_id]
            points = [
                (float(x), float(y)) for shape in element.iter()
                if shape.tag.endswith("}path") or shape.tag == "path"
                for x, y in PAIR.findall(shape.attrib.get("d", ""))
            ]
            candidates = []
            for area_id, area in available.items():
                if area["label"] != previous["label"]:
                    continue
                native_points = area["polygon"] + [point for hole in area["holes"] for point in hole]
                if _GEOMETRY.same_geometry(points, native_points):
                    candidates.append(area_id)
            if len(candidates) != 1:
                raise ValueError(f"Native shape mapping is not unique for {campus}/{level}/{previous['label']}: {candidates}")
            area_id = candidates[0]
            area = available.pop(area_id)
            room_id = f"{campus}--{layer_id}--{area_id}"
            room_mappings[(layer_id, area_id)] = room_id
            element.set("data-object", room_id)
            point = _GEOMETRY.interior_point(area, plan.get("meta", {}).get("precomputed", {}).get("rooms", {}).get(area_id))
            x, y = (point[0] - min_x) * scale, (point[1] - min_y) * scale
            if not 0 <= x <= floor["width"] or not 0 <= y <= floor["height"]:
                raise ValueError(f"Native room anchor lies outside floor: {room_id}")
            room = {
                **previous, "id": room_id, "x": round(x, 6), "y": round(y, 6),
                "legacy_ids": [legacy_id], "source_id_kind": "native_area",
                "source_layer_id": layer_id, "source_room_id": area_id,
            }
            if area["db_id"]:
                room["source_db_id"] = area["db_id"]
                room["source_url"] = source_url + "&room=" + area["db_id"]
            rooms.append(room)
        if available:
            raise ValueError("Some named native rooms have no rendered geometry")
        floor["svg"] = ET.tostring(svg, encoding="unicode")
        floors.append(floor)
    title, short_title, address, _ = CAMPUSES[campus]
    document = {
        "id": campus, "organization_id": "mirea", "title": title,
        "short_title": short_title, "address": address, "revision": 2,
        "source_url": source_url, "source_label": "Пульс РТУ МИРЭА",
        "source_campus_id": source_campus_id, "updated_at": capture["captured_at"],
        "source_captured_at": capture["captured_at"],
        "source_plan_sha256": source_plan_sha256, "source_capture_method": capture["capture_method"],
        **_LOCATIONS.location_for(short_title),
        "floors": floors, "rooms": rooms,
        "source_limitations": [
            "Geographic anchors are unknown until the building is aligned with verified control points.",
            "Room equipment, menus, accessibility and schedule bindings are unknown until verified.",
        ],
    }
    return document, floor_mappings, room_mappings


def _native_document(campus, capture, source):
    document, floor_mappings, room_mappings = prepare_native_campus(campus, capture, source)
    path = Path(__file__).with_name("build_pulse_graph.py")
    if not path.is_file():
        raise RuntimeError("Native map publication requires build_pulse_graph.py; existing assets are unchanged")
    specification = importlib.util.spec_from_file_location("build_pulse_graph", path)
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    graph, stats = module.build_graph(capture["plan"], campus, floor_mappings, room_mappings)
    if not graph.get("nodes") or not graph.get("edges"):
        raise ValueError("Native campus routing graph is empty")
    document["graph"] = graph
    document["graph_import_stats"] = stats
    return document


def _rendered_document(campus, source):
    title, short_title, address, levels = CAMPUSES[campus]
    floors, rooms, source_ids = [], [], set()
    for level in levels:
        record = json.loads((source / f"{campus}_{level}.json").read_text(encoding="utf-8"))
        floor, floor_rooms, source_id = canonicalize(campus, level, record)
        floors.append(floor)
        rooms.extend(floor_rooms)
        source_ids.add(source_id)
    if len(source_ids) != 1:
        raise ValueError(f"Mixed source campus IDs for {campus}")
    source_id = source_ids.pop()
    return {
        "id": campus, "organization_id": "mirea", "title": title,
        "short_title": short_title, "address": address, "revision": 1,
        "source_url": f"https://pulse.mirea.ru/services/maps?campus={source_id}",
        "source_label": "Пульс РТУ МИРЭА", "source_campus_id": source_id,
        "updated_at": max(floor["captured_at"] for floor in floors),
        "source_captured_at": max(floor["captured_at"] for floor in floors),
        **_LOCATIONS.location_for(short_title),
        "source_capture_method": "authenticated_rendered_svg",
        "floors": floors, "rooms": rooms, "graph": {"nodes": [], "edges": []},
        "source_limitations": [
            "Rendered SVG export has no original database room IDs; identifiers derive from labels and occurrence order.",
            "No source graph or georeference anchors were exported; navigation and geographic alignment require reviewed data.",
            "Room equipment, menus, accessibility and schedule bindings are unknown until verified.",
        ],
    }


def build(source=SOURCE, output=OUTPUT):
    output.mkdir(parents=True, exist_ok=True)
    catalog = {"schema_version": 1, "organization_id": "mirea", "campuses": []}
    provenance = {"schema_version": 2, "source_label": "Пульс РТУ МИРЭА", "campuses": []}
    pending_files = {}
    for campus in CAMPUSES:
        native_path = source / f"{campus}_plan.json"
        document = _native_document(campus, json.loads(native_path.read_text(encoding="utf-8")), source) if native_path.is_file() else _rendered_document(campus, source)
        floors, rooms = document["floors"], document["rooms"]
        filename = f"campus_{campus}.json"
        serialized = json.dumps(document, ensure_ascii=False, separators=(",", ":")) + "\n"
        pending_files[filename] = serialized
        catalog["campuses"].append({
            "id": campus, "title": document["title"], "short_title": document["short_title"],
            "revision": document["revision"], "asset": f"packages/app_ui/assets/maps/pulse/{filename}",
            "source_url": document["source_url"], "source_label": document["source_label"],
            "source_captured_at": document["source_captured_at"],
            **{key: document[key] for key in ("latitude", "longitude", "location_source", "source_plan_sha256") if key in document},
        })
        entry = {
            "id": campus, "source_campus_id": document["source_campus_id"], "source_url": document["source_url"],
            "capture_method": document["source_capture_method"],
            "floor_count": len(floors), "room_shape_count": len(rooms),
            "captured_at": document["updated_at"], "asset": filename, "sha256": sha(serialized),
            "graph_nodes": len(document["graph"]["nodes"]), "graph_edges": len(document["graph"]["edges"]),
            "location_source": document["location_source"],
            "floors": [{k: f[k] for k in ("id", "level", "source_svg_sha256", "captured_at")} for f in floors],
        }
        if "source_plan_sha256" in document:
            entry["source_plan_sha256"] = document["source_plan_sha256"]
            entry["graph_import_stats"] = document["graph_import_stats"]
        provenance["campuses"].append(entry)
        print(f"{campus}: {len(floors)} floors, {len(rooms)} room shapes, {len(serialized.encode('utf-8'))} bytes")
    for filename, target in (("catalog.json", catalog), ("provenance.json", provenance)):
        existing_path = output / filename
        if existing_path.is_file():
            existing = json.loads(existing_path.read_text(encoding="utf-8"))
            target["campuses"].extend(entry for entry in existing.get("campuses", []) if entry.get("id") not in CAMPUSES)
        pending_files[filename] = json.dumps(target, ensure_ascii=False, indent=2) + "\n"
    for filename, payload in pending_files.items():
        (output / filename).write_text(payload, encoding="utf-8", newline="\n")
    return provenance


def export_sql(output, destination):
    statements = ["begin;", "set local standard_conforming_strings = on;"]
    catalog = json.loads((output / "catalog.json").read_text(encoding="utf-8"))
    campuses = [entry["id"] for entry in catalog["campuses"]]
    if not campuses or len(set(campuses)) != len(campuses):
        raise ValueError("Publication requires a nonempty catalog with unique campus IDs")
    for campus in campuses:
        if not isinstance(campus, str) or not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", campus):
            raise ValueError("Invalid publication campus ID")
        payload = (output / f"campus_{campus}.json").read_text(encoding="utf-8").strip()
        document = json.loads(payload)
        if document.get("id") != campus or document.get("organization_id") != "mirea":
            raise ValueError("Publication document does not match catalog campus and organization")
        delimiter = f"$pulse_{sha(payload)[:16]}$"
        if delimiter in payload:
            raise ValueError("Unexpected SQL delimiter collision")
        statements.append(
            f"select app_api_v1.publish_map_campus('{campus}', 'mirea', "
            f"{delimiter}{payload}{delimiter}::jsonb, 0);"
        )
    statements.append("commit;")
    destination.write_text("\n\n".join(statements) + "\n", encoding="utf-8", newline="\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert reviewed native Pulse plans and floor captures into map catalog assets.")
    parser.add_argument("--source", type=Path, default=SOURCE)
    parser.add_argument("--output", type=Path, default=OUTPUT)
    parser.add_argument("--sql", type=Path, help="Write a reviewable initial-publication SQL transaction; never executes it.")
    args = parser.parse_args()
    build(args.source, args.output)
    if args.sql:
        export_sql(args.output, args.sql)
