import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const SECRET_NAME = /(?:api[_-]?key|token|secret|password|passwd|credential|private[_-]?key)/i;
const TOKEN_PATTERNS = [
  /\b(?:sk|rk|pk)-[A-Za-z0-9_-]{16,}\b/g,
  /\bgh[opsu]_[A-Za-z0-9]{20,}\b/g,
  /\bgithub_pat_[A-Za-z0-9_]{20,}\b/g,
  /(authorization\s*:\s*bearer\s+)[^\s"']+/gi,
  /((?:api[_-]?key|token|secret|password|passwd|credential)\s*[=:]\s*)[^\s,"']+/gi,
];

export function environmentSecrets(env: NodeJS.ProcessEnv): string[] {
  return Object.entries(env)
    .filter(([name, value]) => SECRET_NAME.test(name) && typeof value === "string" && value.length >= 8)
    .map(([, value]) => value as string)
    .sort((left, right) => right.length - left.length);
}

export function redactText(text: string, secrets: readonly string[]): string {
  let redacted = text;
  for (const secret of secrets) redacted = redacted.split(secret).join("[REDACTED]");
  for (const pattern of TOKEN_PATTERNS) {
    redacted = redacted.replace(pattern, (match, prefix?: string) =>
      typeof prefix === "string" ? `${prefix}[REDACTED]` : "[REDACTED]",
    );
  }
  return redacted;
}

export default function redactSecrets(pi: ExtensionAPI): void {
  const secrets = environmentSecrets(process.env);

  pi.on("tool_result", (event) => {
    const content = event.content.map((block) =>
      block.type === "text" ? { ...block, text: redactText(block.text, secrets) } : block,
    );
    return { content };
  });
}
