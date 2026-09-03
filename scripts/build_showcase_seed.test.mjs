import assert from "node:assert/strict";
import test from "node:test";
import { showcaseScreens } from "./build_showcase_seed.mjs";

const nodes = (value) => {
  if (Array.isArray(value)) return value.flatMap(nodes);
  if (!value || typeof value !== "object") return [];
  return [value, ...Object.values(value).flatMap(nodes)];
};

test("showcase visual controls use kit components and semantic colors", () => {
  const layout = new Set([
    "scaffold", "singleChildScrollView", "column", "row", "wrap",
    "sizedBox", "spacer", "expanded", "form", "conditional", "image",
  ]);
  const all = nodes(showcaseScreens);
  for (const node of all) {
    if (typeof node.type === "string") {
      assert.ok(node.type.startsWith("app") || layout.has(node.type), node.type);
    }
    for (const property of ["color", "tone", "emojiColor"]) {
      if (typeof node[property] === "string") {
        assert.ok(!node[property].startsWith("#"), node[property]);
      }
    }
  }
  assert.equal(all.filter((node) => node.type === "appInputField").length, 2);
  assert.ok(all.some((node) => node.type === "appText"));
  assert.equal(new Set(showcaseScreens.map((screen) => screen.path)).size, 8);
});
