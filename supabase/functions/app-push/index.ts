import {
  createPushWebhook,
  pushWebhookDependencies,
} from "../_shared/push_webhook.ts";

Deno.serve(createPushWebhook("app", pushWebhookDependencies));
