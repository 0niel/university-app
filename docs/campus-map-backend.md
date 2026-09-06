# Campus map backend

The migration `20260906124603_campus_map_catalog_and_community.sql` adds a published campus catalog, floor plans, places, a routing graph, review proposals, revision history, private saved places, and observations tied to the displayed revision. It does not publish source data or grant moderator access automatically.

API implementations live in `app_api_v1`. The ten client operations are exposed through `public` security-invoker wrappers, matching the application's existing PostgREST gateway. The client and HTTP verification use this public schema; the service-only `publish_map_campus` function has no public wrapper. Public reads expose only published documents. Writes require an existing, non-anonymous authenticated user; proposals and observations also require the campus organization profile. Moderator permissions come exclusively from `core.map_moderators`, managed through trusted server access. An author cannot review their own proposal.

| RPC | Parameters | Result |
| --- | --- | --- |
| `get_map_catalog` | `p_organization_id text = 'mirea'` | `{schema_version, campuses:[summary]}` |
| `get_map_campus` | `p_campus_id text` | Published document with `id`, `organization_id`, `revision`, `updated_at`, `can_moderate`; null if unavailable |
| `get_map_room` | `p_campus_id text`, `p_room_id text`, `p_date date = current_date` | `{room,date,timezone,schedule_linked,schedule,verification,revision,can_moderate}` |
| `submit_map_proposal` | `p_campus_id text`, `p_base_revision bigint`, `p_entity_type text`, `p_entity_id text`, `p_patch jsonb`, `p_reason text` | Compact proposal summary |
| `get_map_proposals` | `p_campus_id text`, `p_status text = 'pending'`, `p_limit integer = 50` | `{can_moderate,proposals:[summary]}`; own proposals for students, organization queue for moderators |
| `get_map_proposal` | `p_proposal_id uuid` | Complete proposal with its patch; author or organization moderator only |
| `review_map_proposal` | `p_proposal_id uuid`, `p_decision text`, `p_note text = null` | Reviewed proposal summary; decisions `approved` or `rejected` |
| `get_map_bookmarks` | none | `{bookmarks:[{campus_id,room_id,room_label,campus_title,saved_at}]}` |
| `set_map_bookmark` | `p_campus_id text`, `p_room_id text`, `p_saved boolean` | `{saved}` |
| `confirm_map_room` | `p_campus_id text`, `p_room_id text`, `p_base_revision bigint`, `p_confirmed boolean = true` | `{confirmation_count,last_confirmed_at,confirmed_by_me}` |
| `publish_map_campus` | `p_campus_id text`, `p_organization_id text`, `p_document jsonb`, `p_expected_revision bigint = 0` | `{id,revision,updated_at}`; service role only |

The catalog contains title, short title, address, coordinates, source attribution, revision, update time, floor count and room count; it never includes floor SVG data.

## Published document

```json
{
  "title": "Campus title",
  "short_title": "В-78",
  "address": "Campus address",
  "latitude": 55.0,
  "longitude": 37.0,
  "source_url": "https://pulse.mirea.ru/services/maps",
  "source_label": "Пульс РТУ МИРЭА",
  "floors": [{
    "id": "floor-id", "label": "1", "level": 1,
    "width": 1000, "height": 1000,
    "svg": "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1000 1000\"></svg>",
    "anchors": []
  }],
  "rooms": [{
    "id": "room-id", "floor_id": "floor-id", "label": "101",
    "kind": "classroom", "x": 100, "y": 200,
    "equipment": [], "menu": []
  }],
  "graph": {"nodes": [], "edges": []}
}
```

This example illustrates the schema, not a real building or surveyed location. Source imports must preserve their actual coordinates and geometry. Campus `latitude` and `longitude` can both be omitted or null when the source provides only indoor plans; a partial or invalid coordinate pair is rejected. A floor can use `image_url` instead of inline SVG. An optional `meters_per_unit` must be positive; anchors contain `x`, `y`, `latitude`, `longitude`. Navigation nodes use native floor coordinates. Cross-floor edges require stairs, elevator, ramp, escalator, or outdoor type. Routing must not invent connections or assume wheelchair accessibility.

Edges use `from_node_id`, `to_node_id`, `kind`, `bidirectional`, `closed`, and `wheelchair_accessible`. A known `distance_meters` is finite and nonnegative; zero is valid for coincident doorway connectors. Unknown physical distance is omitted or null and requires a positive, dimensionless `traversal_cost`. The cost can also accompany a known distance as an explicit routing preference. An optional `duration_seconds` is finite and nonnegative only when known from the source. Routing costs are never displayed as metres or seconds. If any route leg has unknown physical distance or duration, the corresponding total must remain unavailable instead of fabricating a vertical length or ETA. No graph-level metric field is required, and existing distance-only documents remain compatible.

Room metadata supports `description`, `equipment` as strings, `opening_hours` as text, `menu` as objects containing `name`, optional `price`, `currency`, and `available`, plus `menu_date`, `expires_at`, `capacity`, and `accessibility` as text. A menu date is `YYYY-MM-DD`; expiry must contain an explicit timezone. Expired menus remain historical source data; the client labels them as stale instead of treating them as current inventory.

Source imports may retain up to 100 previous room identifiers in `legacy_ids`. Aliases must be nonempty strings and cannot identify another room or shadow another canonical ID. Room reads resolve these aliases to the canonical room. Saved-place reads return canonical IDs and deduplicate previous aliases; removing a canonical saved place also removes its legacy rows. New community patches cannot change these source identity mappings.

## Proposals and moderation

`entity_type` is `room`, `place_create`, `floor`, `graph`, `campus`, or `report`. Room and floor IDs are their stable IDs; graph and campus edits use the campus ID. A patch shallowly merges an allowed set of fields. Stable IDs and original source attribution cannot be changed by community patches. The full resulting document is validated before a proposal is accepted and again before publication. An approval requires the original revision to remain current and atomically appends a revision snapshot. SQLSTATE `40001` tells clients to reload; stale edits are never silently rebased. Rejection requires an explanation of at least five characters.

The forward migration `20260906215041_invalidate_changed_floor_georeference.sql` prevents changed floor anchors from retaining the previous alignment's accuracy claims. An actual anchor change replaces `georeference` with `status: community`, `method: community_alignment`, and an explanation that accuracy has not been measured. Previous residuals, verification dates, external evidence links and model hashes are removed. Excluded regions remain because their coordinates refer to the unchanged source plan. Changing `svg`, `image_url`, `width` or `height` also removes these exclusions and clears old anchors unless the proposal explicitly provides anchors for the replacement plan. Unchanged values, floor labels, levels and navigation scale leave alignment metadata intact. Community patches cannot supply their own verification metadata. Approval remains subject to the same permissions, revision check and atomic history write.

`campus_map_georeference_contract.sql` reproduces the stale-evidence failure on the original function and passes after the forward migration in isolated PostgreSQL 17. It covers unchanged patches, source replacement, exclusion preservation, forged metadata rejection, pending/public separation and approved revision history. The existing campus map contract also passes with the replacement function.

`place_create` proposes a new room or service POI. Use a new UUID string as `p_entity_id` and a patch containing `floor_id`, `x`, `y`, `label`, `kind`, and optional room metadata. The patch must not contain `id`; the server supplies it from the proposed entity ID. The floor must already belong to this campus and the coordinates must fit its bounds. An existing room ID cannot be overwritten. The new place stays private until approval, and publication does not invent navigation edges. Editing the position of an existing room continues to use a `room` patch with `x` and `y` on its current floor. Actual coordinate changes atomically detach previous graph `room_id` associations and matching room labels while retaining corridor geometry. Detached nodes become `junction` waypoints, so former room labels are not offered as route endpoints. The server sets `navigation_needs_review: true` on the moved room until a reviewed graph patch reconnects it. Room patches cannot clear this flag. Identical coordinate values leave navigation unchanged.

A report uses `{category,details,source_url?}`, where category is `plan`, `route`, `accessibility`, or `other`. Its target is an existing campus, floor, or room. Approving a report acknowledges review without modifying geometry or increasing the published revision. A separate concrete patch is required to fix the map.

Proposal summaries contain `id`, `campus_id`, `base_revision`, `entity_type`, `entity_id`, `patch_keys`, `patch_bytes`, `has_full_patch: false`, `reason`, `status`, `created_at`, `reviewed_at`, `review_note`, `is_mine`, and `can_review`. They do not expose account IDs or the full patch. `patch_bytes` is computed by PostgreSQL on insertion. `get_map_proposal` returns the same metadata with `has_full_patch: true` and the complete `patch`, after independently checking author or moderator access. Submission and moderation responses also use the compact form. The client loads details before enabling moderation actions; graph previews show node and edge counts without serializing the full graph into text widgets. Legacy client fixtures that already contain a full patch remain supported.

Patches may occupy up to 16 MiB as PostgreSQL JSONB text; published campus documents remain limited to 32 MiB. The real В-78 graph exceeds 8 MiB, so a smaller patch limit would prevent its community editing. Submission is limited to 20 proposals per hour and 100 pending proposals per user.

Saved places are private and limited to 500 per user. Room observations count each user once for the current published revision. Confirming requires the revision the user actually viewed. Changing the campus revision invalidates previous observations for current display; observations never bypass moderation or claim that navigation geometry was professionally surveyed.

## Timetable resolution

Room details read the canonical `core.schedule_item` model for the requested date in `Europe/Moscow`. An explicit `schedule_classroom_id` must belong to the same organization. Without an explicit link, resolution requires exactly one canonical campus whose normalized name equals the map's normalized `short_title`, followed by exactly one classroom in that campus and organization whose normalized name equals the room label. Normalization only folds case and whitespace. Duplicate or missing candidates produce `schedule_linked: false`, so an empty unlinked timetable must not be presented as proof of availability.

## Deployment and verification

Apply the migration through the project's established Supabase CLI workflow when deployment is authorized. Assign actual moderator user IDs explicitly in `core.map_moderators`, and import verified source documents using `publish_map_campus` from a trusted server context. Pass `p_expected_revision = 0` for a new campus and the last observed revision for updates. Keep source attribution to [Пульс РТУ МИРЭА](https://pulse.mirea.ru/services/maps) visible in the application. No provider credentials belong in a map document or client.

`supabase/tests/campus_map_contract.sql` is a transaction-scoped executable PostgreSQL contract. It exercises publication boundaries, private data, moderation permissions, self-review rejection, stale revisions, graph/SVG rejection, source identity preservation, timetable uniqueness, bookmarks, and version-bound observations. The migration and contract have been run in an isolated PostgreSQL 17 container using minimal fixtures for the existing project schemas. This is local SQL verification, not a production migration, full project migration replay, or physical indoor navigation validation.

The four current documents in `packages/app_ui/assets/maps/pulse/` were also published through the service-only RPC in that isolated database on 2026-09-06. Exact readback preserved every public JSON field, SVG, room, source identity, and graph edge. The three native Pulse campuses contain 17 floors, 2,192 room shapes, 25,296 nodes and 64,487 edges. The retained МП-1 catalog adds six floors and 488 room shapes with no invented routing graph. All 86 native portal edges with unknown physical distance retained their explicit routing costs. Anonymous catalog and campus reads succeeded, and actual legacy room aliases resolved to their canonical source IDs. Campus geographic centers retain their existing University App catalog provenance; floor alignment anchors remain unknown where absent from the source. The reviewed four-campus SQL export has SHA-256 `b03a5b547ad4e8bd1ddbe86aede6642b65b6ced5e1cc4f38697cffa950476285`. These checks do not publish the documents to the linked project.

`supabase/tests/campus_map_native_graph_contract.sql` runs after importing the real native documents into an isolated test database. It measures the В-78 graph with PostgreSQL `octet_length(patch::text)`, submits the full patch as an authenticated author, checks that the queue stays below 4 KiB, retrieves the exact full detail, approves it as a different moderator, and checks publication plus immutable revision history. The transaction rolls back all test changes. On 2026-09-07 this exercised a 9,053,801-byte graph patch successfully. The main contract also rejects detail reads by other students and by accounts in another organization.

The following read-only query fingerprints the anonymous published document while excluding volatile server metadata. It checks the SQL RPC path and does not substitute for an HTTP transport check.

```sql
begin read only;
set local role anon;
select id, encode(sha256(convert_to(
  (app_api_v1.get_map_campus(id) - array['revision','updated_at','can_moderate'])::text,
  'UTF8')), 'hex') as public_document_sha256
from (values ('mp-1'),('s-20'),('v-78'),('v-86')) campuses(id)
order by id;
rollback;
```

| Campus | Local verified public-document SHA-256 |
| --- | --- |
| `mp-1` | `3109cb8da62123c29a4af5e161365de4f02a178b3e8ce70d7b93c0cf57f6976e` |
| `s-20` | `9906e91780279692940b722cb16fa9c87a8c03e86c809eb6a513b57f6fd76011` |
| `v-78` | `c2e8e5d78bdeb54b0295b7029b9952f0f4d3db5d589ba963ccc09e0a69bd877d` |
| `v-86` | `30e8504e426bb0afb193f7cc34cb1e70880902a0a14ef4666b89965b222375ce` |

## Production deployment, 7 September 2026

Migration `20260906124603` (SHA-256 `d2d4a95f71e80b17793d98900ff1f04670a2ef1bd04f2842759f38394cf065c4`) was applied to the linked `Mirea Ninja` project, `ejzybbyjwtzbibrrwrli`, using Supabase CLI 2.116.0. The deployment directory used migration history fetched from that project because older repository migration versions differ from production history. No existing history records were repaired or replayed.

All four campus documents were published atomically at revision 1 in the transaction started at `2026-09-06T21:15:06.484289Z`. The seed transferred bounded text fragments through a temporary table, verified each reconstructed document's checksum, and called `publish_map_campus` with expected revision 0. This avoided Management API request-size limits and excessive CLI parsing of individual multi-megabyte SQL literals. The temporary table was dropped on commit.

Production reads under `SET LOCAL ROLE anon` returned all four campuses. Full readback of every public document matched the reviewed bundle exactly after excluding server metadata: 23 floors, 2,680 places, 25,296 navigation nodes and 64,487 edges. Checks also confirmed RLS on all six map tables, no direct table reads for client roles, and publication restricted to `service_role`. Moderator accounts require explicit assignment; the migration does not grant that privilege automatically.

Migration `20260906215041` (SHA-256 `c8de815227bcbf0091afe4b92e7eead189a0780732a68b29e423f004af054b4d`) was subsequently applied through the same linked CLI workflow. It invalidates historical alignment evidence when a community edit changes control points or the underlying plan. All four documents were then updated atomically to revision 2 at `2026-09-06T21:58:24.127333Z`. The update checked the observed revision and the stored document checksum before replacing only each floor's `anchors` and `georeference`. Full anonymous SQL readback matched the current bundles; all 23 floors retain their original room geometry, graphs and metric scale.

The subsequent МП-1 revision 3 corrects only the source label in its alignment details to **Планы University App · МП-1**; the other three campuses remain at revision 2. Anonymous readback of all four documents matches the bundles after this correction.

The manual **Verify campus map API** workflow checks the HTTP Data API from the protected release environment using the existing public client configuration. `tool/verify_campus_map_api.py` compares the complete published documents and catalog, validates anonymous permissions, and limits response sizes and request time. The RPC schema version is checked separately from the source document format; server revision and update metadata are excluded from content fingerprints. Credentials and response bodies are never printed. A successful SQL readback alone does not establish HTTP transport availability.
