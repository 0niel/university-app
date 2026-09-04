// moderate-content — LLM auto-moderation for user-generated content.
//
// Called by DB triggers / pg_cron via pg_net (internal.dispatch_moderation_job)
// with { job_id }. Claims the job through app_api_v1.moderation_begin,
// classifies the content through OpenRouter and closes the job with
// moderation_finish (which records the decision and deletes destructive
// spam). Deployed with verify_jwt=false; auth is a shared secret header.
//
//   supabase secrets set OPENROUTER_API_KEY=<key> \
//     MODERATION_WEBHOOK_SECRET=<random> \
//     [MODERATION_MODELS=google/gemini-3.8-flash,google/gemini-3.5-flash-lite] \
//     [MODERATION_REMOVE_THRESHOLD=0.85] [MODERATION_DRY_RUN=true]
//   insert into internal.app_config(key, value) values
//     ('moderation_url', 'https://<ref>.supabase.co/functions/v1/moderate-content'),
//     ('moderation_secret', '<the same random>');
//
// Ad-hoc check without side effects:
//   POST { "classify": { "kind": "marketplace", "title": "...", "body": "..." } }
import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { classify, type ModerationInput } from "./classifier.ts";

const DEFAULT_REMOVE_THRESHOLD = 0.85;

type Action = "none" | "deleted" | "flagged" | "dry_run";

interface BeginResult {
  status: "ok" | "skipped";
  reason?: string;
  verdict?: string;
  job?: { id: string; content_type: string; content_id: string };
  content?: ModerationInput & {
    author_id: string | null;
    organization_id: string | null;
  };
  content_hash?: string;
}

interface RemovedObjects {
  bucket: string;
  paths: string[];
}

// deno-lint-ignore no-explicit-any
type ApiClient = SupabaseClient<any, any, any>;

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const secret = Deno.env.get("MODERATION_WEBHOOK_SECRET");
  if (!secret || req.headers.get("x-moderation-secret") !== secret) {
    return json({ error: "Unauthorized" }, 401);
  }

  const apiKey = Deno.env.get("OPENROUTER_API_KEY");
  if (!apiKey) {
    return json({ error: "OPENROUTER_API_KEY secret is not set" }, 503);
  }

  let body: { job_id?: unknown; classify?: unknown };
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON" }, 400);
  }

  if (body.classify && typeof body.classify === "object") {
    const probe = body.classify as Partial<ModerationInput>;
    const result = await classify(
      {
        kind: String(probe.kind ?? "post"),
        title: String(probe.title ?? ""),
        body: String(probe.body ?? ""),
        extra: probe.extra,
      },
      apiKey,
    );
    return json(result);
  }

  if (typeof body.job_id !== "string") {
    return json({ error: "job_id is required" }, 400);
  }
  const jobId = body.job_id;

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { db: { schema: "app_api_v1" } },
  );

  const { data: begin, error: beginError } = await supabase.rpc(
    "moderation_begin",
    { p_job_id: jobId },
  );
  if (beginError) {
    console.error(`moderation_begin ${jobId} failed:`, beginError.message);
    return json({ job_id: jobId, error: beginError.message }, 500);
  }
  const started = begin as BeginResult;
  if (started.status !== "ok" || !started.content || !started.content_hash) {
    return json({ job_id: jobId, skipped: true, ...started });
  }

  try {
    const outcome = await judge(supabase, jobId, started, apiKey);
    return json({ job_id: jobId, ...outcome });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`moderation job ${jobId} failed:`, message);
    await supabase.rpc("moderation_fail", {
      p_job_id: jobId,
      p_error: message,
    });
    return json({ job_id: jobId, error: message }, 500);
  }
});

async function judge(
  supabase: ApiClient,
  jobId: string,
  started: BeginResult,
  apiKey: string,
): Promise<Record<string, unknown>> {
  const content = started.content!;
  const result = await classify(
    {
      kind: content.kind,
      title: content.title,
      body: content.body,
      extra: content.extra,
    },
    apiKey,
  );

  const dryRun = (Deno.env.get("MODERATION_DRY_RUN") ?? "").toLowerCase() ===
    "true";
  const threshold = Number(
    Deno.env.get("MODERATION_REMOVE_THRESHOLD") ?? DEFAULT_REMOVE_THRESHOLD,
  );
  const shouldRemove = result.verdict === "remove" &&
    result.confidence >= threshold;

  let action: Action = "none";
  if (shouldRemove) {
    action = dryRun ? "dry_run" : "deleted";
  } else if (result.verdict !== "allow") {
    action = "flagged";
  }

  const { data: removed, error: finishError } = await supabase.rpc(
    "moderation_finish",
    {
      p_job_id: jobId,
      p_decision: {
        verdict: result.verdict,
        category: result.category,
        confidence: Number(result.confidence.toFixed(3)),
        reason: result.reason,
        model: result.model,
        action,
        latency_ms: result.latencyMs,
        content_hash: started.content_hash,
        content_excerpt: `${content.title}\n${content.body}`.slice(0, 1000),
        author_id: content.author_id,
        organization_id: content.organization_id,
      },
    },
  );
  if (finishError) throw finishError;

  if (action === "deleted") {
    await removeObjects(supabase, removed as RemovedObjects | null);
  }

  return {
    verdict: result.verdict,
    category: result.category,
    confidence: result.confidence,
    action,
    model: result.model,
  };
}

async function removeObjects(
  supabase: ApiClient,
  removed: RemovedObjects | null,
): Promise<void> {
  if (!removed?.bucket || !Array.isArray(removed.paths)) return;
  const marker = `/${removed.bucket}/`;
  const paths = [
    ...new Set(
      removed.paths
        .filter((path): path is string => typeof path === "string" && !!path)
        .map((path) => {
          const index = path.indexOf(marker);
          return index >= 0 ? path.slice(index + marker.length) : path;
        }),
    ),
  ];
  if (paths.length === 0) return;
  const { error } = await supabase.storage.from(removed.bucket).remove(paths);
  if (error) {
    console.warn(`storage cleanup failed (${removed.bucket}):`, error.message);
  }
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
