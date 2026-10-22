# My Neovim Config

Based on: [🚀Launch.nvim](https://github.com/LunarVim/Launch.nvim)

## Kotlin and Android

Run `just android-setup` from the dotfiles repo to install JDK 21, ktlint, Kotlin LSP,
Android command-line tools, platform-tools (adb), SDK 37 and Build Tools 37.0.0.
The SDK versions match bitchat's version catalog (Google names the platform
package `android-37.0`); override `ANDROID_API` and
`ANDROID_BUILD_TOOLS` for other projects. The setup prompts for SDK licenses.
Restart the shell afterward so `JAVA_HOME`, `ANDROID_HOME`, and `PATH` are loaded.
An existing `JAVA_HOME` or `ANDROID_HOME` is respected; ensure the selected JDK
matches the project's toolchain.

Open Neovim from the Android project's root. JetBrains' official Homebrew
package supplies `kotlin_lsp`; Mason automatically installs `lemminx` for
Android XML and `taplo` for TOML version catalogs. Treesitter installs Kotlin,
Java, Groovy, XML, and TOML parsers.
Both `.kt` and `.kts` files use Kotlin support and four-space indentation.
Allow the Kotlin server time to import Gradle dependencies on the first launch.

- Completion uses blink.cmp; `K` shows documentation and `gd` jumps to definitions.
- `gr` finds references, `<leader>lr` renames, and `<leader>la` opens code actions.
- `<leader>lf` formats Kotlin with ktlint, respecting the project's `.editorconfig`.
- `:checkhealth vim.lsp`, `:Mason`, and `:ConformInfo` show tool status.

Use the project's Gradle wrapper from `:terminal` (no global Gradle or Kotlin
compiler is needed):

```sh
./gradlew :app:assembleDebug :wear:assembleDebug
./gradlew testDebugUnitTest lintDebug
./gradlew :app:installDebug  # connected, authorized Android device
adb logcat
```

JetBrains' [Kotlin LSP](https://github.com/Kotlin/kotlin-lsp) is alpha software
with experimental Android Gradle support. Android Studio remains useful for
Compose previews, graphical debugging, and emulator management; the existing
Neovim DAP UI does not configure an Android debugger. Android lint runs through
Gradle; LSP diagnostics cover editing and ktlint handles explicit formatting.
For bitchat, Bluetooth mesh validation requires physical devices.
