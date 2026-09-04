// moderate-content — LLM auto-moderation for user-generated content.
//
// Called by DB triggers / pg_cron via pg_net (internal.dispatch_moderation_job)
// with { job_id }. Loads the content, classifies it through OpenRouter,
// records a decision in core.moderation_decisions and deletes destructive
// spam. Deployed with verify_jwt=false; auth is a shared secret header.
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
import { createClient } from "@supabase/supabase-js";
import { classify, type ModerationInput } from "./classifier.ts";
import {
  type ContentType,
  type CoreClient,
  loadContent,
  removeContent,
} from "./content.ts";

const MAX_ATTEMPTS = 6;
const DEFAULT_REMOVE_THRESHOLD = 0.85;

interface JobRow {
  id: string;
  content_type: ContentType;
  content_id: string;
  status: string;
  attempts: number;
}

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

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { db: { schema: "core" } },
  );

  const job = await claimJob(supabase, body.job_id);
  if (!job) return json({ skipped: true, reason: "job not pending" });

  try {
    const outcome = await processJob(supabase, job, apiKey);
    await supabase
      .from("moderation_jobs")
      .update({
        status: "done",
        last_error: null,
        updated_at: new Date().toISOString(),
      })
      .eq("id", job.id);
    return json({ job_id: job.id, ...outcome });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`moderation job ${job.id} failed:`, message);
    const failed = job.attempts >= MAX_ATTEMPTS;
    const backoffMinutes = Math.min(60, 2 ** job.attempts);
    await supabase
      .from("moderation_jobs")
      .update({
        status: failed ? "failed" : "pending",
        last_error: message.slice(0, 500),
        next_attempt_at: new Date(Date.now() + backoffMinutes * 60_000)
          .toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq("id", job.id);
    return json({ job_id: job.id, error: message }, 500);
  }
});

async function claimJob(
  supabase: CoreClient,
  jobId: string,
): Promise<JobRow | null> {
  const { data: job } = await supabase
    .from("moderation_jobs")
    .select("id, content_type, content_id, status, attempts")
    .eq("id", jobId)
    .maybeSingle();
  if (!job || job.status !== "pending") return null;
  const { data: claimed } = await supabase
    .from("moderation_jobs")
    .update({
      attempts: job.attempts + 1,
      updated_at: new Date().toISOString(),
    })
    .eq("id", jobId)
    .eq("attempts", job.attempts)
    .select("id, content_type, content_id, status, attempts")
    .maybeSingle();
  return (claimed as JobRow | null) ?? null;
}

async function processJob(
  supabase: CoreClient,
  job: JobRow,
  apiKey: string,
): Promise<Record<string, unknown>> {
  const loaded = await loadContent(supabase, job.content_type, job.content_id);
  if (!loaded) return { skipped: true, reason: "content gone" };

  const excerpt = `${loaded.input.title}\n${loaded.input.body}`.slice(0, 1000);
  const hash = await sha256(
    JSON.stringify([loaded.input.title, loaded.input.body, loaded.input.extra]),
  );

  const { data: previous } = await supabase
    .from("moderation_decisions")
    .select("id, verdict")
    .eq("content_type", job.content_type)
    .eq("content_id", job.content_id)
    .eq("content_hash", hash)
    .limit(1)
    .maybeSingle();
  if (previous) {
    return {
      skipped: true,
      reason: "already judged",
      verdict: previous.verdict,
    };
  }

  const result = await classify(loaded.input, apiKey);
  const dryRun = (Deno.env.get("MODERATION_DRY_RUN") ?? "").toLowerCase() ===
    "true";
  const threshold = Number(
    Deno.env.get("MODERATION_REMOVE_THRESHOLD") ?? DEFAULT_REMOVE_THRESHOLD,
  );
  const shouldRemove = result.verdict === "remove" &&
    result.confidence >= threshold;

  let action: "none" | "deleted" | "flagged" | "dry_run" = "none";
  if (shouldRemove) {
    action = dryRun ? "dry_run" : "deleted";
  } else if (result.verdict !== "allow") {
    action = "flagged";
  }

  const { error: insertError } = await supabase
    .from("moderation_decisions")
    .insert({
      content_type: job.content_type,
      content_id: job.content_id,
      author_id: loaded.authorId,
      organization_id: loaded.organizationId,
      content_hash: hash,
      content_excerpt: excerpt,
      verdict: result.verdict,
      category: result.category,
      confidence: Number(result.confidence.toFixed(3)),
      reason: result.reason,
      model: result.model,
      action,
      latency_ms: result.latencyMs,
    });
  if (insertError) throw insertError;

  if (action === "deleted") {
    await removeContent(supabase, job.content_type, job.content_id);
  }

  return {
    verdict: result.verdict,
    category: result.category,
    confidence: result.confidence,
    action,
    model: result.model,
  };
}

async function sha256(text: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(text),
  );
  return [...new Uint8Array(digest)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
