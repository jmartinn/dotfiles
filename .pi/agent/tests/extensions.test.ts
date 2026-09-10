import assert from "node:assert/strict";
import test from "node:test";

import { continuationPrompt } from "../extensions/continue-after-compaction.ts";
import { guardGitCommand } from "../extensions/git-guard.ts";
import { environmentSecrets, redactText } from "../extensions/redact-secrets.ts";
import { assistantText } from "../extensions/save-markdown.ts";

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
