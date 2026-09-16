import { pathToFileURL } from "node:url";

const DEEPGRAM_AUTH_URL = "https://api.deepgram.com/v1/auth/token";

export async function validateDeepgramApiKey(apiKey, request = fetch) {
  try {
    const response = await request(DEEPGRAM_AUTH_URL, {
      headers: { Authorization: `Token ${apiKey}` },
      signal: AbortSignal.timeout(10_000),
    });
    return { valid: response.status === 200, status: response.status };
  } catch {
    return { valid: false, status: null };
  }
}

async function readStdin() {
  const chunks = [];
  for await (const chunk of process.stdin) chunks.push(chunk);
  return Buffer.concat(chunks).toString("utf8").trim();
}

async function main() {
  if (process.argv[2] !== "validate") {
    console.error("Usage: pi-deepgram-key.mjs validate");
    process.exitCode = 2;
    return;
  }

  const apiKey = await readStdin();
  if (!apiKey) {
    console.error("No Deepgram API key provided.");
    process.exitCode = 2;
    return;
  }

  const result = await validateDeepgramApiKey(apiKey);
  if (result.valid) {
    console.log("Deepgram API key validated.");
    return;
  }

  if (result.status === 401) {
    console.error("Deepgram rejected this key (401). Create a key with usage:write permission and Expiration set to Never.");
    process.exitCode = 3;
    return;
  }

  if (result.status === null) {
    console.error("Could not reach Deepgram to validate the key; the stored credential was not changed.");
  } else {
    console.error(`Deepgram key validation returned HTTP ${result.status}; the stored credential was not changed.`);
  }
  process.exitCode = 4;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  await main();
}
