import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";
import { fileURLToPath } from "node:url";

import { SettingsManager } from "@earendil-works/pi-coding-agent";
import { DefaultPackageManager } from "../../node_modules/@earendil-works/pi-coding-agent/dist/core/package-manager.js";

import { continuationPrompt } from "../extensions/continue-after-compaction.ts";
import { guardGitCommand } from "../extensions/git-guard.ts";
import { environmentSecrets, redactText } from "../extensions/redact-secrets.ts";
import { assistantText } from "../extensions/save-markdown.ts";
import { deepgramKeychainLocation, resolveDeepgramApiKey } from "../extensions/dictate/deepgram-auth.ts";
import { validateDeepgramApiKey } from "../../../bin/pi-deepgram-key.mjs";

test("daily settings select Codex Sol with medium effort and reserve Astra with low effort", () => {
  const settings = JSON.parse(readFileSync(new URL("../settings.json", import.meta.url), "utf8"));
  const manager = SettingsManager.inMemory(settings);

  assert.equal(manager.getDefaultProvider(), "openai-codex");
  assert.equal(manager.getDefaultModel(), "gpt-6-sol");
  assert.equal(manager.getDefaultThinkingLevel(), "medium");
  assert.equal(settings.modelThinkingLevels["openai-codex/gpt-6-sol"], "medium");
  assert.equal(settings.modelThinkingLevels["openai-codex/gpt-6-astra"], "low");
  assert.notEqual(settings.compaction?.enabled, false);
});

test("resource discovery disables automatic continuation without removing useful extensions", async () => {
  const settings = JSON.parse(readFileSync(new URL("../settings.json", import.meta.url), "utf8"));
  const agentDir = fileURLToPath(new URL("../", import.meta.url));
  const manager = new DefaultPackageManager({
    cwd: agentDir,
    agentDir,
    settingsManager: SettingsManager.inMemory({ ...settings, packages: [] }, { projectTrusted: false }),
  });
  const resources = await manager.resolve(async () => "error");
  const enabled = (suffix: string) => resources.extensions.find((entry) => entry.path.endsWith(suffix))?.enabled;

  assert.equal(enabled("/extensions/continue-after-compaction.ts"), false);
  for (const suffix of ["git-guard.ts", "redact-secrets.ts", "save-markdown.ts", "dictate/index.ts"]) {
    assert.equal(enabled(`/extensions/${suffix}`), true, suffix);
  }
});

test("git guard ignores non-git commands", () => {
  assert.deepEqual(guardGitCommand("rg git"), { action: "pass" });
});

test("git guard makes git noninteractive", () => {
  const result = guardGitCommand("git rebase -i HEAD~2");
  assert.equal(result.action, "rewrite");
  if (result.action === "rewrite") assert.match(result.command, /GIT_SEQUENCE_EDITOR=true/);
});

test("git guard blocks hook bypass", () => {
  const result = guardGitCommand("git commit --no-verify -m nope");
  assert.equal(result.action, "block");
});

test("continuation prompt points to the active JSONL branch", () => {
  const prompt = continuationPrompt("/tmp/session.jsonl", "entry-42");
  assert.match(prompt, /parentId/);
  assert.match(prompt, /entry-42/);
  assert.match(prompt, /immediately perform the next unfinished step/);
});

test("assistant text keeps only text blocks", () => {
  assert.equal(
    assistantText([{ type: "text", text: "one" }, { type: "image", data: "ignored" }, { type: "text", text: "two" }]),
    "one\n\ntwo",
  );
});

test("secret redaction uses environment names and common token formats", () => {
  const secrets = environmentSecrets({ DEEPGRAM_API_KEY: "private-deepgram-value", PATH: "/bin" });
  assert.deepEqual(secrets, ["private-deepgram-value"]);
  assert.equal(
    redactText("key=private-deepgram-value Authorization: Bearer visible-token", secrets),
    "key=[REDACTED] Authorization: Bearer [REDACTED]",
  );
});

test("dictation prefers a rotated Keychain key over a stale process key", () => {
  assert.equal(resolveDeepgramApiKey("stale-process-key", "rotated-keychain-key"), "rotated-keychain-key");
  assert.equal(resolveDeepgramApiKey("current-process-key", null), "current-process-key");
  assert.equal(resolveDeepgramApiKey("  ", "  "), null);
});

test("dictation uses an explicit login Keychain derived from the macOS account", () => {
  assert.deepEqual(deepgramKeychainLocation({ username: "alice", homedir: "/Users/alice" }), {
    account: "alice",
    keychain: "/Users/alice/Library/Keychains/login.keychain-db",
  });
});

test("Deepgram key validation accepts only an authenticated response", async () => {
  const valid = await validateDeepgramApiKey("candidate", async () => new Response("{}", { status: 200 }));
  assert.deepEqual(valid, { valid: true, status: 200 });

  const rejected = await validateDeepgramApiKey("candidate", async () => new Response("no", { status: 401 }));
  assert.deepEqual(rejected, { valid: false, status: 401 });

  const unavailable = await validateDeepgramApiKey("candidate", async () => {
    throw new Error("offline");
  });
  assert.deepEqual(unavailable, { valid: false, status: null });
});
