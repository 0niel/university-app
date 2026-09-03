/// Synchronizes public Telegram channels into the news feed.
///
/// Scrapes t.me/s/<channel> web previews (no Telegram credentials needed),
/// converts posts to news blocks and writes them through the same
/// begin/ingest/finish RPC path the ingest boundary uses. Scheduled by
/// pg_cron via `internal.request_telegram_feed_sync`.

import { createClient, SupabaseClient } from "@supabase/supabase-js";
import { buildNewsBlocks, extractTitle } from "./blocks.ts";
import {
  fetchPreviewPage,
  TelegramChannelInfo,
  TelegramPost,
} from "./telegram.ts";

interface ChannelConfig {
  username: string;
  category: string;
}

interface ChannelResult {
  channel: string;
  status: "succeeded" | "failed" | "skipped";
  items: number;
  lastMessageId?: number;
  error?: string;
}

const DEFAULT_CHANNELS = "rtumirea_official,CenterCareer_RTU_MIREA,priem_mirea";
const MAX_PAGES_PER_RUN = 6;

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function configuredChannels(): ChannelConfig[] {
  const raw = Deno.env.get("TELEGRAM_FEED_CHANNELS") ?? DEFAULT_CHANNELS;
  return raw
    .split(",")
    .map((entry) => entry.trim())
    .filter(Boolean)
    .map((entry) => {
      const [username, category] = entry.split(":");
      return { username, category: category?.trim() || "telegram" };
    });
}

async function rpc<T>(
  supabase: SupabaseClient,
  name: string,
  params: Record<string, unknown>,
): Promise<T> {
  const { data, error } = await supabase.rpc(name, params);
  if (error) {
    throw new Error(`${name} failed: ${error.message}`);
  }
  return data as T;
}

function sourcePayload(
  channel: TelegramChannelInfo,
  category: string,
): Record<string, unknown> {
  return {
    source_type: "telegram",
    source_external_id: channel.username,
    source_name: channel.title || `@${channel.username}`,
    source_url: `https://t.me/${channel.username}`,
    category,
    is_active: true,
    metadata: {
      ...(channel.subscribers ? { subscribers: channel.subscribers } : {}),
      ...(channel.imageUrl ? { avatar_url: channel.imageUrl } : {}),
      metadata_checked_at: new Date().toISOString(),
    },
  };
}

function itemPayload(
  post: TelegramPost,
  channel: TelegramChannelInfo,
): Record<string, unknown> {
  const title = extractTitle(post, channel);
  return {
    external_id: String(post.id),
    title,
    summary: post.text.slice(0, 500) || null,
    published_at: post.publishedAt,
    original_url: post.url,
    news_blocks: buildNewsBlocks(post, channel),
    raw_data: {
      id: post.id,
      channel: post.channel,
      text: post.text,
      media: post.media,
      link_preview: post.linkPreview ?? null,
    },
    metadata: {
      views: post.views ?? null,
      media_count: post.media.length,
    },
  };
}

/// Loads posts newer than [afterId], paging backwards through the preview.
async function collectPosts(
  username: string,
  afterId: number | null,
  backfillPages: number,
): Promise<{ channel: TelegramChannelInfo; posts: TelegramPost[] }> {
  const collected = new Map<number, TelegramPost>();
  let page = await fetchPreviewPage(username);
  const channel = page.channel;
  let pages = 1;
  const maxPages = afterId == null
    ? Math.min(backfillPages, MAX_PAGES_PER_RUN)
    : MAX_PAGES_PER_RUN;

  while (true) {
    for (const post of page.posts) {
      if (afterId == null || post.id > afterId) collected.set(post.id, post);
    }
    const oldest = page.posts[0]?.id;
    const reachedCheckpoint = afterId != null &&
      oldest != null && oldest <= afterId;
    if (
      reachedCheckpoint || page.posts.length === 0 || pages >= maxPages ||
      oldest == null || oldest <= 1
    ) {
      break;
    }
    page = await fetchPreviewPage(username, oldest);
    pages += 1;
  }

  const posts = [...collected.values()].sort((a, b) => a.id - b.id);
  return { channel, posts };
}

async function syncChannel(
  supabase: SupabaseClient,
  organizationId: string,
  config: ChannelConfig,
  backfillPages: number,
): Promise<ChannelResult> {
  const source = `telegram:${config.username}`;
  let syncRunId: string | null = null;
  try {
    const begin = await rpc<{
      sync_run_id: string;
      checkpoint: Record<string, unknown>;
    }>(supabase, "begin_content_sync", {
      p_organization_id: organizationId,
      p_source: source,
      p_source_type: "telegram",
      p_metadata: { connector: "sync-telegram-feed" },
    });
    syncRunId = begin.sync_run_id;

    const checkpoint = begin.checkpoint ?? {};
    const lastMessageId = checkpoint.cursor_type === "telegram_message_id" &&
        typeof checkpoint.last_message_id === "number"
      ? checkpoint.last_message_id
      : null;

    const { channel, posts } = await collectPosts(
      config.username,
      lastMessageId,
      backfillPages,
    );

    await rpc(supabase, "ingest_news_items", {
      p_organization_id: organizationId,
      p_source: sourcePayload(channel, config.category),
      p_items: posts.map((post) => itemPayload(post, channel)),
      p_sync_run_id: syncRunId,
    });

    const newLast = posts.length > 0
      ? posts[posts.length - 1].id
      : lastMessageId ?? 0;
    await rpc(supabase, "finish_content_sync", {
      p_organization_id: organizationId,
      p_sync_run_id: syncRunId,
      p_status: "succeeded",
      p_checkpoint: {
        version: 1,
        cursor_type: "telegram_message_id",
        last_message_id: newLast,
      },
      p_metadata: { items: posts.length },
    });

    return {
      channel: config.username,
      status: "succeeded",
      items: posts.length,
      lastMessageId: newLast,
    };
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    if (message.includes("already running")) {
      return {
        channel: config.username,
        status: "skipped",
        items: 0,
        error: message,
      };
    }
    if (syncRunId) {
      try {
        await rpc(supabase, "finish_content_sync", {
          p_organization_id: organizationId,
          p_sync_run_id: syncRunId,
          p_status: "failed",
          p_error_message: message,
        });
      } catch (_finishError) {
        // The failure below is the primary signal; lease expiry recovers runs.
      }
    }
    return {
      channel: config.username,
      status: "failed",
      items: 0,
      error: message,
    };
  }
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  const secret = Deno.env.get("TELEGRAM_SYNC_SECRET");
  if (!secret) {
    return jsonResponse({ error: "TELEGRAM_SYNC_SECRET is not set" }, 500);
  }
  if (req.headers.get("x-sync-secret") !== secret) {
    return jsonResponse({ error: "Unauthorized" }, 401);
  }

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

  let body: Record<string, unknown> = {};
  try {
    body = await req.json();
  } catch (_error) {
    // Cron posts an empty body; defaults apply.
  }

  const organizationId = typeof body.organization_id === "string" &&
      body.organization_id
    ? body.organization_id
    : Deno.env.get("APP_ORGANIZATION_ID") ?? "mirea";
  const backfillPages = typeof body.backfill_pages === "number"
    ? Math.max(1, Math.min(body.backfill_pages, MAX_PAGES_PER_RUN))
    : 3;
  const channels = Array.isArray(body.channels)
    ? (body.channels as string[]).map((entry) => {
      const [username, category] = String(entry).split(":");
      return { username, category: category?.trim() || "telegram" };
    })
    : configuredChannels();

  const results: ChannelResult[] = [];
  for (const channel of channels) {
    results.push(
      await syncChannel(supabase, organizationId, channel, backfillPages),
    );
  }

  const failed = results.filter((result) => result.status === "failed");
  return jsonResponse(
    { ok: failed.length === 0, results },
    failed.length === 0 ? 200 : 500,
  );
});
