# Tenant service catalog

University-specific external services are data, not Flutter constants. The app
loads them through the public `get_organization_service_catalog` RPC using the
configured `APP_ORGANIZATION_ID` and the current locale.

Apply the Supabase migrations before releasing a tenant. The migration creates
the catalog, section, translation, and service tables in the private `core`
schema, enables RLS on every table, and exposes only the read-only RPC. Direct
client access to `core` is intentionally unavailable.

Each service needs a stable lowercase `slug`, an HTTPS destination, one of the
supported `color_key` values (`colorful01` through `colorful07`), and an
`icon_key`. The Flutter mapper provides `business`, `computer`, `dormitory`,
`download`, `help`, `idea`, `library`, `payments`, `rocket`, `shield`,
`support`, and `work`; unknown icons safely fall back to a link icon.

Use `organization_service_sections` to control grouping, titles, ordering, and
locale-specific section names. Use `organization_service_translations` and
`organization_service_section_translations` for localized titles and
descriptions. Deactivate a row instead of deleting it when a service is
temporarily unavailable.

The migration seeds the existing MIREA links as `mirea`; new universities start
with an empty catalog and can configure only the services they actually offer.
