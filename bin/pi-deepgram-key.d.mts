export interface DeepgramValidationResult {
  valid: boolean;
  status: number | null;
}

export function validateDeepgramApiKey(
  apiKey: string,
  request?: typeof fetch,
): Promise<DeepgramValidationResult>;
