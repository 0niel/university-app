// Per-section loaders and removers for moderated content.

import type { SupabaseClient } from "@supabase/supabase-js";
import type { ModerationInput } from "./classifier.ts";

// deno-lint-ignore no-explicit-any
export type CoreClient = SupabaseClient<any, any, any>;

export type ContentType =
  | "lost_found"
  | "marketplace"
  | "event"
  | "mentor"
  | "poll";

export interface LoadedContent {
  input: ModerationInput;
  authorId: string | null;
  organizationId: string | null;
}

const LOST_FOUND_BUCKET = "lost-found-images";
const MARKETPLACE_BUCKET = "marketplace-media";

type Row = Record<string, unknown>;

function str(row: Row, key: string): string {
  const value = row[key];
  if (typeof value === "string") return value;
  if (Array.isArray(value)) return value.map(String).join(", ");
  return value == null ? "" : String(value);
}

export async function loadContent(
  supabase: CoreClient,
  type: ContentType,
  id: string,
): Promise<LoadedContent | null> {
  switch (type) {
    case "lost_found": {
      const { data } = await supabase
        .from("lost_found_items")
        .select(
          "author_id, organization_id, item_name, description, status, category, location",
        )
        .eq("id", id)
        .maybeSingle();
      if (!data) return null;
      return {
        authorId: str(data, "author_id") || null,
        organizationId: str(data, "organization_id") || null,
        input: {
          kind: "lost & found",
          title: str(data, "item_name"),
          body: str(data, "description"),
          extra: {
            status: str(data, "status"),
            category: str(data, "category"),
            location: str(data, "location"),
          },
        },
      };
    }
    case "marketplace": {
      const { data } = await supabase
        .from("marketplace_listings")
        .select(
          "seller_id, organization_id, title, description, price, category, is_free",
        )
        .eq("id", id)
        .maybeSingle();
      if (!data) return null;
      return {
        authorId: str(data, "seller_id") || null,
        organizationId: str(data, "organization_id") || null,
        input: {
          kind: "marketplace",
          title: str(data, "title"),
          body: str(data, "description"),
          extra: {
            price: data.is_free ? "free" : `${str(data, "price")} RUB`,
            category: str(data, "category"),
          },
        },
      };
    }
    case "event": {
      const { data } = await supabase
        .from("campus_events")
        .select(
          "created_by, organization_id, title, description, category, place, starts_at",
        )
        .eq("id", id)
        .maybeSingle();
      if (!data) return null;
      return {
        authorId: str(data, "created_by") || null,
        organizationId: str(data, "organization_id") || null,
        input: {
          kind: "campus events",
          title: str(data, "title"),
          body: str(data, "description"),
          extra: {
            category: str(data, "category"),
            place: str(data, "place"),
            starts_at: str(data, "starts_at"),
          },
        },
      };
    }
    case "mentor": {
      const { data } = await supabase
        .from("mentor_profiles")
        .select("user_id, organization_id, topics, bio, level, formats, price")
        .eq("user_id", id)
        .maybeSingle();
      if (!data) return null;
      return {
        authorId: str(data, "user_id") || null,
        organizationId: str(data, "organization_id") || null,
        input: {
          kind: "mentorship profile",
          title: str(data, "topics"),
          body: str(data, "bio"),
          extra: {
            level: str(data, "level"),
            formats: str(data, "formats"),
            price: str(data, "price"),
          },
        },
      };
    }
    case "poll": {
      const { data } = await supabase
        .from("polls")
        .select(
          "author_id, organization_id, title, question, description, category, is_anonymous, poll_questions(position, text, kind, poll_options(position, text))",
        )
        .eq("id", id)
        .maybeSingle();
      if (!data) return null;
      const questions = (data.poll_questions as Row[] | null) ?? [];
      questions.sort((a, b) => Number(a.position) - Number(b.position));
      const lines: string[] = [];
      for (const question of questions) {
        lines.push(`Q: ${str(question, "text")} (${str(question, "kind")})`);
        const options = (question.poll_options as Row[] | null) ?? [];
        options.sort((a, b) => Number(a.position) - Number(b.position));
        for (const option of options) lines.push(`  - ${str(option, "text")}`);
      }
      const body = [str(data, "description"), ...lines]
        .filter(Boolean)
        .join("\n");
      return {
        authorId: str(data, "author_id") || null,
        organizationId: str(data, "organization_id") || null,
        input: {
          kind: "poll",
          title: str(data, "title") || str(data, "question"),
          body,
          extra: {
            category: str(data, "category"),
            anonymous: data.is_anonymous ? "yes" : "no",
          },
        },
      };
    }
  }
}

export async function removeContent(
  supabase: CoreClient,
  type: ContentType,
  id: string,
): Promise<void> {
  switch (type) {
    case "lost_found": {
      const { data, error } = await supabase
        .from("lost_found_items")
        .delete()
        .eq("id", id)
        .select("images")
        .maybeSingle();
      if (error) throw error;
      const images = Array.isArray(data?.images)
        ? (data?.images as unknown[])
        : [];
      await removeObjects(
        supabase,
        LOST_FOUND_BUCKET,
        images.map((image) => storagePath(String(image), LOST_FOUND_BUCKET)),
      );
      return;
    }
    case "marketplace": {
      const { data, error } = await supabase
        .from("marketplace_listings")
        .delete()
        .eq("id", id)
        .select("media")
        .maybeSingle();
      if (error) throw error;
      const media = Array.isArray(data?.media)
        ? (data?.media as unknown[])
        : [];
      await removeObjects(
        supabase,
        MARKETPLACE_BUCKET,
        media
          .map((item) => (item as Row)?.path)
          .filter((path): path is string => typeof path === "string"),
      );
      return;
    }
    case "event": {
      const { error } = await supabase.from("campus_events").delete().eq(
        "id",
        id,
      );
      if (error) throw error;
      return;
    }
    case "mentor": {
      const { error } = await supabase.from("mentor_profiles").delete().eq(
        "user_id",
        id,
      );
      if (error) throw error;
      return;
    }
    case "poll": {
      const { error } = await supabase.from("polls").delete().eq("id", id);
      if (error) throw error;
      return;
    }
  }
}

function storagePath(value: string, bucket: string): string {
  const marker = `/${bucket}/`;
  const index = value.indexOf(marker);
  return index >= 0 ? value.slice(index + marker.length) : value;
}

async function removeObjects(
  supabase: CoreClient,
  bucket: string,
  paths: string[],
): Promise<void> {
  const unique = [...new Set(paths.filter(Boolean))];
  if (unique.length === 0) return;
  const { error } = await supabase.storage.from(bucket).remove(unique);
  if (error) console.warn(`storage cleanup failed (${bucket}):`, error.message);
}
