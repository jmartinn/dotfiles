import { writeFile } from "node:fs/promises";
import { resolve } from "node:path";

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export function assistantText(content: unknown): string {
  if (!Array.isArray(content)) return "";
  return content
    .filter(
      (block): block is { type: "text"; text: string } =>
        typeof block === "object" &&
        block !== null &&
        "type" in block &&
        block.type === "text" &&
        "text" in block &&
        typeof block.text === "string",
    )
    .map((block) => block.text)
    .join("\n\n");
}

export default function saveMarkdown(pi: ExtensionAPI): void {
  pi.registerCommand("save-md", {
    description: "Save the latest assistant response as a new Markdown file",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();

      let latest: AssistantMessage | undefined;
      for (const entry of ctx.sessionManager.getBranch().toReversed()) {
        if (entry.type === "message" && entry.message.role === "assistant") {
          latest = entry.message;
          break;
        }
      }

      if (!latest) {
        ctx.ui.notify("No assistant response to save", "warning");
        return;
      }

      const name = args.trim();
      if (!name || name.includes("/") || name.includes("\\")) {
        ctx.ui.notify("Usage: /save-md filename", "warning");
        return;
      }

      const text = assistantText(latest.content);
      if (!text.trim()) {
        ctx.ui.notify("The latest assistant response has no text", "warning");
        return;
      }

      const fileName = name.endsWith(".md") ? name : `${name}.md`;
      const path = resolve(ctx.cwd, fileName);

      try {
        await writeFile(path, text.endsWith("\n") ? text : `${text}\n`, {
          encoding: "utf8",
          flag: "wx",
        });
      } catch (error) {
        if (typeof error === "object" && error !== null && "code" in error && error.code === "EEXIST") {
          ctx.ui.notify(`File already exists: ${path}`, "error");
          return;
        }
        throw error;
      }

      ctx.ui.notify(`Saved Markdown to ${path}`, "info");
    },
  });
}
