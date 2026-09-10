import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";

const NONINTERACTIVE_GIT_ENV =
  "export GIT_EDITOR=true GIT_SEQUENCE_EDITOR=true GIT_MERGE_AUTOEDIT=no\n";

export function guardGitCommand(command: string):
  | { action: "pass" }
  | { action: "block"; reason: string }
  | { action: "rewrite"; command: string } {
  if (!/(^|[;&|()]\s*)(?:(?:command|sudo)\s+)?git(?:\s|$)/.test(command)) {
    return { action: "pass" };
  }

  if (/(^|\s)--no-verify(?:\s|$)/.test(command)) {
    return {
      action: "block",
      reason: "Git hook bypass is disabled. Fix the failing hook or ask the user for direction.",
    };
  }

  return { action: "rewrite", command: NONINTERACTIVE_GIT_ENV + command };
}

export default function gitGuard(pi: ExtensionAPI): void {
  pi.on("tool_call", (event) => {
    if (!isToolCallEventType("bash", event)) return;

    const result = guardGitCommand(event.input.command);
    if (result.action === "block") return { block: true, reason: result.reason };
    if (result.action === "rewrite") event.input.command = result.command;
  });
}
