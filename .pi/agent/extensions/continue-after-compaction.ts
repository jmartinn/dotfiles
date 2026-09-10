import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export function continuationPrompt(sessionFile: string | undefined, entryId: string): string {
  const source = sessionFile
    ? `Read the active branch ending at ${JSON.stringify(entryId)} from ${JSON.stringify(sessionFile)}. Follow parentId links; JSONL append order may include abandoned branches.`
    : "This session is ephemeral, so recover only from the compaction summary and current worktree.";

  return `Compaction completed. Continue the existing task without waiting for another user prompt.

${source}

Recover the original objective, user constraints, decisions, changed files, verification already run, unresolved issues, and intended next action. Reconcile that history with the current worktree, briefly state what you recovered, and immediately perform the next unfinished step. Do not ask the user to repeat context unless the available state is genuinely ambiguous.`;
}

export default function continueAfterCompaction(pi: ExtensionAPI): void {
  const timers = new Set<ReturnType<typeof setTimeout>>();

  pi.on("session_compact", (event, ctx) => {
    const prompt = continuationPrompt(
      ctx.sessionManager.getSessionFile(),
      event.compactionEntry.id,
    );
    const timer = setTimeout(() => {
      timers.delete(timer);
      pi.sendUserMessage(prompt, { deliverAs: "steer" });
    }, 0);
    timers.add(timer);
  });

  pi.on("session_shutdown", () => {
    for (const timer of timers) clearTimeout(timer);
    timers.clear();
  });
}
