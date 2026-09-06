import copy
import unittest

from build_pulse_graph import PRECOMPUTED_VERSION, build_graph


def fixture(*, closed=False, door=True, opening=False):
    vertices = {}
    areas = {}
    for area_id, left, right in (("a", 0, 1000), ("b", 1000, 2000)):
        keys = []
        for index, (x, y) in enumerate(((left, 0), (right, 0), (right, 1000), (left, 1000))):
            key = f"{area_id}{index}"
            vertices[key] = {"x": x, "y": -y}
            keys.append(key)
        areas[area_id] = {"vertices": keys, "properties": {"name": area_id.upper()}}
    lines = {"wall": {"vertices": ["a1", "a2"], "properties": {}}}
    holes = {"door": {"line": "wall", "offset": .5, "properties": {"width": {"length": 80}, "closed": closed}}} if door else {}
    if opening:
        vertices["opening-top"] = {"x": 1000, "y": -450}
        vertices["opening-bottom"] = {"x": 1000, "y": -550}
        lines = {"upper": {"vertices": ["a1", "opening-top"], "properties": {}},
                 "lower": {"vertices": ["opening-bottom", "a2"], "properties": {}}}
    layer = {"vertices": vertices, "areas": areas, "lines": lines, "holes": holes, "items": {}}
    plan = {"unit": "cm", "layers": {"floor-0": layer}, "meta": {"precomputed": {
        "version": PRECOMPUTED_VERSION,
        "rooms": {"a": {"c": [500, 500, 300], "n": [200, 500, 800, 500], "e": [0, 1]},
                  "b": {"c": [1500, 500, 300], "n": [1200, 500, 1800, 500], "e": [0, 1]}},
        "floors": {"floor-0": {"d": [["a", "b", "door"]] if door else [],
                               "w": [] if door else [["a", "b", 1000, 500, 1.5707963267948966, 1000, 0]]}},
    }, "building": {"transitions": []}}}
    floors = {"floor-0": {"id": "campus-floor0", "min_x": 0, "min_y": 0, "scale": .5, "level": 0}}
    rooms = {("floor-0", "a"): "room-a", ("floor-0", "b"): "room-b"}
    return plan, floors, rooms


def connected(graph, first_room="room-a", second_room="room-b"):
    starts = {node["id"] for node in graph["nodes"] if node.get("room_id") == first_room}
    targets = {node["id"] for node in graph["nodes"] if node.get("room_id") == second_room}
    reached = set(starts)
    while True:
        before = len(reached)
        for edge in graph["edges"]:
            if edge["from_node_id"] in reached or edge["to_node_id"] in reached:
                reached.update((edge["from_node_id"], edge["to_node_id"]))
        if len(reached) == before:
            return bool(reached & targets)


class PulseGraphTest(unittest.TestCase):
    def test_actual_door_connects_anchors_using_source_scale(self):
        plan, floors, rooms = fixture()
        graph, stats = build_graph(plan, "test", floors, rooms)
        self.assertTrue(connected(graph))
        self.assertEqual(stats["doors"], 1)
        self.assertEqual(sum("room_id" in node for node in graph["nodes"]), 2)
        door = next(edge for edge in graph["edges"] if edge["kind"] == "door")
        self.assertEqual(door["distance_meters"], .5)
        anchor = next(node for node in graph["nodes"] if node.get("room_id") == "room-a")
        self.assertEqual((anchor["x"], anchor["y"]), (250, 250))

    def test_closed_door_cannot_be_routed(self):
        plan, floors, rooms = fixture(closed=True)
        graph, stats = build_graph(plan, "test", floors, rooms)
        self.assertFalse(connected(graph))
        self.assertEqual(stats["closed_doors_excluded"], 1)

    def test_thick_wall_doorway_crosses_full_wall_without_cutting_corners(self):
        plan, floors, rooms = fixture()
        plan["layers"]["floor-0"]["lines"]["wall"]["properties"]["thickness"] = {"length": 120}
        graph, stats = build_graph(plan, "test", floors, rooms)
        self.assertTrue(connected(graph))
        self.assertEqual(stats["doors"], 1)
        door = next(edge for edge in graph["edges"] if edge["kind"] == "door")
        self.assertEqual(door["distance_meters"], 1.3)

    def test_skeleton_cannot_run_inside_actual_thick_wall(self):
        plan, floors, rooms = fixture()
        layer = plan["layers"]["floor-0"]
        layer["vertices"].update({"thick-a": {"x": 180, "y": -200}, "thick-b": {"x": 180, "y": -800}})
        layer["lines"]["thick-wall"] = {"vertices": ["thick-a", "thick-b"], "properties": {"thickness": {"length": 60}}}
        _, stats = build_graph(plan, "test", floors, rooms)
        self.assertEqual(stats["rejected_source_edges"], 1)

    def test_shared_wall_candidate_is_not_a_passage(self):
        plan, floors, rooms = fixture(door=False)
        graph, stats = build_graph(plan, "test", floors, rooms)
        self.assertFalse(connected(graph))
        self.assertEqual(stats["blocked_boundaries_excluded"], 1)

    def test_shared_boundary_with_real_gap_is_passable(self):
        plan, floors, rooms = fixture(door=False, opening=True)
        graph, stats = build_graph(plan, "test", floors, rooms)
        self.assertTrue(connected(graph))
        self.assertEqual(stats["verified_openings"], 1)

    def test_source_skeleton_crossing_obstacle_is_rejected(self):
        plan, floors, rooms = fixture()
        layer = plan["layers"]["floor-0"]
        layer["vertices"].update({"obstacle-a": {"x": 400, "y": -300}, "obstacle-b": {"x": 400, "y": -700}})
        layer["lines"]["obstacle"] = {"vertices": ["obstacle-a", "obstacle-b"], "properties": {}}
        graph, stats = build_graph(plan, "test", floors, rooms)
        self.assertEqual(stats["rejected_source_edges"], 1)
        self.assertTrue(all(not (edge["from_node_id"].endswith("a:n0") and edge["to_node_id"].endswith("a:n1")) for edge in graph["edges"]))

    def test_portals_need_declared_matching_endpoints_and_no_fake_meters(self):
        plan, floors, rooms = fixture()
        plan["layers"]["floor-1"] = copy.deepcopy(plan["layers"]["floor-0"])
        floors["floor-1"] = {**floors["floor-0"], "id": "campus-floor1", "level": 1}
        rooms[("floor-1", "a")] = "upstairs-a"
        rooms[("floor-1", "b")] = "upstairs-b"
        plan["meta"]["precomputed"]["floors"]["floor-1"] = copy.deepcopy(plan["meta"]["precomputed"]["floors"]["floor-0"])
        plan["meta"]["building"]["transitions"] = [{"id": "staircase", "kind": "stairs", "fromLayer": "floor-0", "toLayer": "floor-1"}]
        for floor, endpoint in (("floor-0", "from"), ("floor-1", "to")):
            plan["layers"][floor]["items"]["stairs"] = {"type": "stairs-portal", "x": 500, "y": -500,
                "properties": {"transitionId": "staircase", "endpoint": endpoint}}
        graph, stats = build_graph(plan, "test", floors, rooms)
        self.assertTrue(connected(graph, "room-a", "upstairs-a"))
        transition = next(edge for edge in graph["edges"] if edge["kind"] == "stairs")
        self.assertNotIn("distance_meters", transition)
        self.assertEqual(transition["traversal_cost"], 20)
        self.assertEqual(stats["floor_transitions"], 1)
        plan["meta"]["building"]["transitions"] = []
        graph, _ = build_graph(plan, "test", floors, rooms)
        self.assertFalse(connected(graph, "room-a", "upstairs-a"))

    def test_unknown_precomputed_version_fails_instead_of_guessing(self):
        plan, floors, rooms = fixture()
        plan["meta"]["precomputed"]["version"] = "future-version"
        with self.assertRaisesRegex(ValueError, "Unsupported"):
            build_graph(plan, "test", floors, rooms)


if __name__ == "__main__":
    unittest.main()
