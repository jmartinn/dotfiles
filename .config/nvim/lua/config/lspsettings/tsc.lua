return {
  -- TypeScript's native LSP currently registers watchers for bundled:// URIs,
  -- which Neovim cannot represent as filesystem globs. Project files are still
  -- refreshed through normal buffer notifications; restart the LSP after
  -- changing tsconfig.json or package metadata.
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = false,
      },
    },
  },
}
