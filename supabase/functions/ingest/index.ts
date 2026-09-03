import { createClient, SupabaseClient } from "@supabase/supabase-js";
import { ingestAuthScope, requireIngestKey } from "./auth.ts";
import { corsHeaders, jsonResponse } from "./http.ts";
import {
  DatabaseIngestPayload,
  IngestPayload,
  validatePayload,
} from "./payload.ts";
import { storyMediaObject } from "./story_media.ts";

function ingestRpc(supabase: SupabaseClient, payload: DatabaseIngestPayload) {
  return payload.entity === "news_items"
    ? supabase.rpc("ingest_news_items", {
      p_organization_id: payload.organization_id,
      p_source: payload.source,
      p_items: payload.items,
      p_sync_run_id: payload.sync_run_id,
    })
    : supabase.rpc("ingest_schedule_payload", {
      p_organization_id: payload.organization_id,
      p_source: payload.source,
      p_targets: payload.targets,
      p_sync_run_id: payload.sync_run_id,
    });
}

function syncRpc(
  supabase: SupabaseClient,
  payload: Extract<IngestPayload, { entity: "sync_start" | "sync_finish" }>,
) {
  if (payload.entity === "sync_start") {
    return supabase.rpc("begin_content_sync", {
      p_organization_id: payload.organization_id,
      p_source: payload.source,
      p_source_type: payload.source_type,
      p_metadata: payload.metadata,
    });
  }
  if (payload.source !== null && payload.source_type !== null) {
    return supabase.rpc("finish_content_sync", {
      p_organization_id: payload.organization_id,
      p_sync_run_id: payload.sync_run_id,
      p_source: payload.source,
      p_source_type: payload.source_type,
      p_status: payload.status,
      p_checkpoint: payload.checkpoint,
      p_error_message: payload.error_message,
      p_metadata: payload.metadata,
    });
  }
  return supabase.rpc("finish_content_sync", {
    p_organization_id: payload.organization_id,
    p_sync_run_id: payload.sync_run_id,
    p_status: payload.status,
    p_checkpoint: payload.checkpoint,
    p_error_message: payload.error_message,
    p_metadata: payload.metadata,
  });
}

async function createStoryMediaUpload(
  supabase: SupabaseClient,
  payload: Extract<IngestPayload, { entity: "story_media_upload" }>,
) {
  const object = storyMediaObject(payload);
  const storage = supabase.storage.from(object.bucket);
  const { data, error } = await storage.createSignedUploadUrl(
    object.path,
    { upsert: true },
  );
  if (error) {
    return jsonResponse({ error: error.message }, 500);
  }
  const publicUrl = storage.getPublicUrl(object.path).data.publicUrl;
  return jsonResponse({
    ok: true,
    upload: {
      signed_url: data.signedUrl,
      public_url: publicUrl,
      bucket: object.bucket,
      path: object.path,
    },
  });
}

async function cleanupStoryMedia(
  supabase: SupabaseClient,
  payload: Extract<IngestPayload, { entity: "story_media_cleanup" }>,
) {
  const { data, error } = await supabase.rpc("list_expired_story_media", {
    p_organization_id: payload.organization_id,
    p_limit: 100,
  });
  if (error) return jsonResponse({ error: error.message }, 500);

  const paths = Array.isArray(data)
    ? data.flatMap((row) =>
      typeof row?.media_path === "string" ? [row.media_path] : []
    )
    : [];
  if (paths.length === 0) {
    return jsonResponse({ ok: true, removed: 0 });
  }

  const storage = supabase.storage.from("story-media");
  const { error: removeError } = await storage.remove(paths);
  if (removeError) return jsonResponse({ error: removeError.message }, 500);

  const { error: markError } = await supabase.rpc("mark_story_media_cleaned", {
    p_organization_id: payload.organization_id,
    p_paths: paths,
  });
  if (markError) return jsonResponse({ error: markError.message }, 500);
  return jsonResponse({ ok: true, removed: paths.length });
}

async function deleteStoryMedia(
  supabase: SupabaseClient,
  payload: Extract<IngestPayload, { entity: "story_media_delete" }>,
) {
  if (payload.paths.length === 0) {
    return jsonResponse({ ok: true, removed: 0 });
  }
  const { error } = await supabase.storage.from("story-media").remove(
    payload.paths,
  );
  if (error) return jsonResponse({ error: error.message }, 500);
  return jsonResponse({ ok: true, removed: payload.paths.length });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  let payload: IngestPayload;
  try {
    payload = validatePayload(await req.json());
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return jsonResponse({ error: message }, 400);
  }

  const authScope = payload.entity === "sync_start" ||
      payload.entity === "sync_finish"
    ? ingestAuthScope(payload.entity, payload.source_type, payload.source)
    : ingestAuthScope(
      payload.entity,
      payload.entity === "news_items" ? payload.source.source_type : undefined,
    );
  const authError = await requireIngestKey(
    req,
    payload.organization_id,
    authScope,
  );
  if (authError) return authError;

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return jsonResponse(
      { error: "SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY is not configured" },
      500,
    );
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  if (
    payload.entity === "community_catalog_targets" ||
    payload.entity === "community_observations"
  ) {
    const { data, error } = payload.entity === "community_catalog_targets"
      ? await supabase.rpc("get_community_sync_targets", {
        p_organization_id: payload.organization_id,
      })
      : await supabase.rpc("apply_community_observations", {
        p_organization_id: payload.organization_id,
        p_observations: payload.observations,
      });
    if (error) return jsonResponse({ error: error.message }, 500);
    return jsonResponse({ ok: true, result: data });
  }

  if (payload.entity === "story_media_upload") {
    return await createStoryMediaUpload(supabase, payload);
  }
  if (payload.entity === "story_media_cleanup") {
    return await cleanupStoryMedia(supabase, payload);
  }
  if (payload.entity === "story_media_delete") {
    return await deleteStoryMedia(supabase, payload);
  }

  if (payload.entity === "sync_start" || payload.entity === "sync_finish") {
    const { data, error } = await syncRpc(supabase, payload);
    if (error) {
      return jsonResponse(
        { error: error.message, details: error.details },
        500,
      );
    }
    return jsonResponse({ ok: true, result: data });
  }

  const { data, error } = await ingestRpc(supabase, payload);
  if (error) {
    return jsonResponse({ error: error.message, details: error.details }, 500);
  }
  return jsonResponse({ ok: true, result: data });
});
