# Campus floor source

The current В-78, В-86 and Стромынка-20 floor plans were captured from **[Пульс РТУ МИРЭА](https://pulse.mirea.ru/services/maps)** on 6 September 2026 using an authorized browser session. Full native `GetCampus` responses supplement the rendered floor SVGs with original room identities, declared doors and inter-floor transitions, interior navigation data and metric units. The source credit and campus link are included in every campus document and shown in the map interface.

| Local campus | Source campus | Visible floors | Selectable room shapes |
| --- | --- | --- | --- |
| В-78 | [Вернадского 78](https://pulse.mirea.ru/services/maps?campus=019f9340-d2cc-7c8a-8472-2cbcc2dd3de3) | 0–4 | 1169 |
| В-86 | [Вернадского 86](https://pulse.mirea.ru/services/maps?campus=01a023a4-e394-7f10-a979-16f396473e1e) | 0–7 | 587 |
| С-20 | [Стромынка 20](https://pulse.mirea.ru/services/maps?campus=01a038f2-df0e-7324-9c5a-73b1766851af) | 1–4 | 436 |

There are **17 Pulse floors and 2192 selectable geometries**. Shape counts are not counts of unique room numbers: the source contains several shapes with the same label, including separate toilets and parts of larger rooms. The complete catalog also contains МП-1, for a total of **23 floors and 2680 selectable places**.

## Files and reproducibility

- `scripts/map/source/{campus}_{floor}.json`: original rendered SVG, exact source URL, visible campus/floor labels and UTC capture time. No cookies, access tokens or account profile data are stored.
- `scripts/map/source/{campus}_plan.json`: full authorized `GetCampus` plan with capture timestamp and source identifiers.
- `scripts/map/import_pulse.py` and `pulse_native_geometry.py`: deterministic offline conversion into the application's own campus, floor, room and coordinate model.
- `scripts/map/build_pulse_graph.py`: routing graph generation from native rooms, doors and transitions, invoked by the importer before publishing generated assets.
- `packages/app_ui/assets/maps/pulse/catalog.json`: packaged catalog used when the remote catalog is unavailable.
- `packages/app_ui/assets/maps/pulse/campus_*.json`: full documents compatible with `get_map_campus` and `publish_map_campus`.
- `packages/app_ui/assets/maps/pulse/provenance.json`: source IDs, timestamps and SHA-256 hashes of original SVGs and generated documents.

Use Python 3.12 or newer for native graph generation (the pinned NumPy dependency requires it). Install the graph dependencies in the selected Python environment, then run from the repository root:

```powershell
python -m pip install -r scripts/map/requirements.txt
python scripts/map/import_pulse.py
python -m unittest discover -s scripts/map -p 'test_*.py'
fvm flutter test --no-pub test/map/data/pulse_bundle_test.dart
```

The normalizer rejects mismatched visible campus/floor labels, truncated XML and room centers outside the plan. It preserves the source paths and doors, maps them to an origin of `(0, 0)`, and scales each plan's longest dimension to 2000 display units. Every room coordinate uses the same transformation. The application caches structural paths and renders outlines at a constant screen width, with room labels adapted to zoom. Original SVGs remain unchanged in the source captures; normalized SVGs also remain available to other renderers and editors.

Canonical room IDs are `{campus}--{sourceLayerId}--{sourceAreaId}`. They remain stable when a room's display label or geometry changes. `source_room_id`, `source_layer_id` and the separate Pulse `source_db_id` preserve provenance; a Pulse database ID is not assumed to be an application's own schedule classroom ID. Previous IDs derived from label and occurrence order are preserved in `legacy_ids`. Every selectable rendered polygon is matched uniquely to the native area using its label and full outer/hole geometry; a mismatch fails the import rather than assigning a nearby room. `data-object` attributes match the canonical room IDs exactly.

Display floor levels come from `shortTitle` or `title`, not internal layer numbers. For example, В-86 native `floor-3` has internal number `3` but is displayed as **Этаж 1**. All three native captures declare centimetres; canonical `meters_per_unit` is `0.01 / source_coordinate_scale`. Source vertices `(x,y)` become SVG `(x,-y)`, then receive the same origin shift and scaling as the preserved SVG geometry.

`source_captured_at` records the source response timestamp independently of the server publication time in `updated_at`. Catalog entries also preserve the source timestamp and native plan hash so remote publication revisions and bundled source versions do not share one revision counter.

## МП-1 and campus locations

МП-1 is converted from the [existing University App floor assets](https://github.com/0niel/university-app/tree/master/packages/app_ui/assets/maps/mp-1), with the distinct credit **Планы University App · МП-1**. Its six floors contain 488 selectable places. `scripts/map/import_mp1.py` preserves original paths and verifies the room-label transcriptions against source glyph hashes. These plans do not supply a measured routing graph or metric scale; those fields are not invented. Refreshing Pulse preserves the МП-1 catalog entry.

All four campus center coordinates come from the application's existing `packages/rtu_mirea_schedule_api_client/lib/src/campuses.dart` catalog. `scripts/map/campus_locations.py` matches its explicit `shortName`, latitude and longitude constants and records the source path and hash in `location_source`. Campus centers support the city-map view and an initial alignment position. They are separate from Pulse provenance. Floor overlays use the approximate OpenStreetMap registration described below, independently of these catalog centers.

## Refreshing from Pulse

The website's public application code identifies the gRPC-web methods `rtu_tc.map.api.MapService/ListCampuses` and `GetCampus`. `GetCampus` returns a title and a JSON plan. An anonymous `ListCampuses` request returned HTTP 401 on the capture date. Use an authorized existing session or an explicitly provided official export; do not embed credentials or bypass authentication.

Save only the decoded map response, using a wrapper with `campus`, `source_campus_id`, `source_url`, `captured_at`, `capture_method` and `plan`. The native plan includes unnamed circulation areas as well as named rooms; those areas must be retained for route generation even when excluded from the searchable room catalog. Preserve the source's blocked/closed connection information. Shared-boundary candidates do not establish a walkable opening on their own.

For a rendered capture, select the named campus and each visible floor through the website. Read `svg[aria-label="План этажа"]` as `outerHTML`, and include:

```json
{
  "campus": "v-86",
  "floor": 1,
  "visible_campus": "Вернадского 86",
  "visible_floor": "Этаж 1",
  "url": "https://pulse.mirea.ru/services/maps?campus=01a023a4-e394-7f10-a979-16f396473e1e",
  "captured_at": "2026-09-06T00:00:00.000Z",
  "svg_length": 0,
  "svg": "<svg>...</svg>"
}
```

The timestamp and SVG length in this example must be replaced with the actual values. Transfer large SVGs in chunks smaller than the browser tool's per-string limit and verify the reassembled length; some rendered plans exceed 370 KB. The optional `scripts/map/capture_server.py` runs a temporary local form on `127.0.0.1:58422` that accepts same-origin captures and saves only the allowed campus/floor filenames. Stop it after capture. Re-run the normalizer and tests after replacing a complete campus's captures.

## Publication

The importer performs no network calls or Supabase writes. To prepare a transaction for review:

```powershell
python scripts/map/import_pulse.py --sql "$env:TEMP\pulse-map-publish.sql"
```

This produces one service-only `app_api_v1.publish_map_campus` call for every canonical campus in the catalog, including МП-1, inside one transaction. The expected revision is `0`, so it cannot overwrite an existing published revision. Apply the map migration and review the generated transaction in the intended database before executing it with an authorized administrative workflow. Production publication is separate from local asset generation.

## Unavailable source fields

Geographic control points are absent from the Pulse source. On 2026-09-07 the floor drawings were approximately registered to public OpenStreetMap geometry. Three generated affine control points per floor encode each fitted model; they are not surveyed observations. The geographic screen identifies approximate alignment, exposes sources and limitations, and retains visible OpenStreetMap attribution. Native room geometry, navigation graphs and `meters_per_unit` remain unchanged.

| Campus | Registration evidence | Observed discrepancy against OSM |
| --- | --- | --- |
| МП-1 | 410 unique room references across six floors | Median 0.33 m; 95th percentile 1.28 m |
| В-78 | 510 unique room references; robust affine consensus of 304 | All-match median 6.43 m; 95th percentile 25.55 m |
| В-86 | Main building [relation 7331729](https://www.openstreetmap.org/relation/7331729), first-floor footprint | Area intersection/union 75.9%; symmetric boundary median 1.47 m; 95th percentile 6.89 m |
| Стромынка, 20 | [Relation 15743979](https://www.openstreetmap.org/relation/15743979), second-floor footprint | Area intersection/union 92.2%; symmetric boundary median 0.24 m; 95th percentile 2.54 m |

These residuals measure agreement with OSM, not absolute geodetic accuracy. Room-reference and boundary residuals are different metrics and are not interchangeable. The [OSM mapper's account](https://community.openstreetmap.org/t/topic/118432) documents earlier indoor mapping from MIREA plans and local drawing distortions. В-78 has larger mismatches around the library and northern blocks. В-86 has a roughly 20 m mismatch at the northern wing tip; its detached rectangular block cannot be reliably aligned by the same affine transform and is excluded only from the geographic overlay. Indoor access to that block remains available. Other floors of В-86 and Стромынка inherit their native drawing coordinate frame; their partial footprints were not independently fitted.

`scripts/map/source/georeference_registration.json` records the room and boundary correspondences, final floor anchors, coordinate-frame fingerprints, fit statistics and limitations. `georeference_footprint_fits.json` retains building IDs, OSM snapshot hashes, sampled boundary correspondences and footprint transforms without bundling the full OSM dataset. `scripts/map/align_campus_maps.py --apply-evidence scripts/map/source/georeference_registration.json` reproduces the final anchors and metadata using the pinned dependencies in `scripts/map/requirements.txt`, without requiring `output/` files. It rejects source-floor geometry changes and preserves all graph, room and navigation-scale fields. Recomputing fits from OSM snapshots uses `align_campus_maps.py` and `fit_campus_footprints.py`; the relevant snapshot IDs and capture times are recorded in the evidence. Original plans remain attributed to [Пульс МИРЭА](https://pulse.mirea.ru/services/maps).

Room equipment, accessibility, schedules, menus and opening hours are not inferred from shapes. Only categories clearly present in labels, such as toilets, canteens and entrances, are imported. A source capture is not an on-site verification of room status or safety.
