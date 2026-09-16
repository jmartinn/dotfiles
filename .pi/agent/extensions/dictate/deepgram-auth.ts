import { spawnSync } from "node:child_process";
import { userInfo } from "node:os";
import { join } from "node:path";

export const DEEPGRAM_KEYCHAIN_SERVICE = "pi-deepgram-api-key";

interface MacUserIdentity {
  username: string;
  homedir: string;
}

const normalized = (value: string | null | undefined): string | null => {
  const trimmed = value?.trim();
  return trimmed ? trimmed : null;
};

/**
 * Prefer Keychain so a rotated credential takes effect without restarting Pi.
 * The process environment remains a fallback for non-macOS and headless use.
 */
export function resolveDeepgramApiKey(
  environmentKey: string | null | undefined,
  keychainKey: string | null | undefined,
): string | null {
  return normalized(keychainKey) ?? normalized(environmentKey);
}

export function deepgramKeychainLocation(identity: MacUserIdentity = userInfo()) {
  return {
    account: identity.username,
    keychain: join(identity.homedir, "Library", "Keychains", "login.keychain-db"),
  };
}

export function readDeepgramKeychainKey(): string | null {
  if (process.platform !== "darwin") return null;

  const { account, keychain } = deepgramKeychainLocation();
  const result = spawnSync(
    "/usr/bin/security",
    ["find-generic-password", "-a", account, "-s", DEEPGRAM_KEYCHAIN_SERVICE, "-w", keychain],
    { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] },
  );

  return result.status === 0 ? normalized(result.stdout) : null;
}

export function getDeepgramApiKey(): string | null {
  return resolveDeepgramApiKey(process.env.DEEPGRAM_API_KEY, readDeepgramKeychainKey());
}
